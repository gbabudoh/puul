const db = require('../config/database');

const listConnections = async (req, res) => {
  try {
    const result = await db.query(
      `SELECT c.id, c.status, c.created_at, c.accepted_at,
              u.id as user_id, u.phone_number, u.email
       FROM connections c
       JOIN users u ON (c.requester_id = u.id OR c.receiver_id = u.id)
       WHERE (c.requester_id = $1 OR c.receiver_id = $1) 
       AND c.status = 'accepted'
       AND u.id != $1
       ORDER BY c.accepted_at DESC`,
      [req.user.userId]
    );

    res.json({ connections: result.rows });
  } catch (error) {
    console.error('List connections error:', error);
    res.status(500).json({ error: 'Failed to fetch connections' });
  }
};

const sendRequest = async (req, res) => {
  try {
    const { receiver_id } = req.body;

    if (!receiver_id) {
      return res.status(400).json({ error: 'receiver_id is required' });
    }

    if (receiver_id === req.user.userId) {
      return res.status(400).json({ error: 'Cannot connect with yourself' });
    }

    // Check if connection already exists
    const existing = await db.query(
      'SELECT id, status FROM connections WHERE (requester_id = $1 AND receiver_id = $2) OR (requester_id = $2 AND receiver_id = $1)',
      [req.user.userId, receiver_id]
    );

    if (existing.rows.length > 0) {
      return res.status(409).json({ error: 'Connection request already exists', status: existing.rows[0].status });
    }

    const result = await db.query(
      'INSERT INTO connections (requester_id, receiver_id, status) VALUES ($1, $2, $3) RETURNING *',
      [req.user.userId, receiver_id, 'pending']
    );

    res.status(201).json({ connection: result.rows[0] });
  } catch (error) {
    console.error('Send request error:', error);
    res.status(500).json({ error: 'Failed to send connection request' });
  }
};

const acceptRequest = async (req, res) => {
  try {
    const connectionId = req.params.id;

    const result = await db.query(
      'UPDATE connections SET status = $1, accepted_at = NOW() WHERE id = $2 AND receiver_id = $3 AND status = $4 RETURNING *',
      ['accepted', connectionId, req.user.userId, 'pending']
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Connection request not found' });
    }

    // Update connect_count for both users
    await db.query(
      'UPDATE users SET connect_count = connect_count + 1 WHERE id = $1 OR id = $2',
      [result.rows[0].requester_id, result.rows[0].receiver_id]
    );

    res.json({ connection: result.rows[0] });
  } catch (error) {
    console.error('Accept request error:', error);
    res.status(500).json({ error: 'Failed to accept connection request' });
  }
};

const removeConnection = async (req, res) => {
  try {
    const connectionId = req.params.id;

    const result = await db.query(
      'DELETE FROM connections WHERE id = $1 AND (requester_id = $2 OR receiver_id = $2) RETURNING requester_id, receiver_id',
      [connectionId, req.user.userId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Connection not found' });
    }

    // Decrement connect_count for both users
    await db.query(
      'UPDATE users SET connect_count = GREATEST(connect_count - 1, 0) WHERE id = $1 OR id = $2',
      [result.rows[0].requester_id, result.rows[0].receiver_id]
    );

    res.json({ message: 'Connection removed successfully' });
  } catch (error) {
    console.error('Remove connection error:', error);
    res.status(500).json({ error: 'Failed to remove connection' });
  }
};

module.exports = {
  listConnections,
  sendRequest,
  acceptRequest,
  removeConnection,
};
