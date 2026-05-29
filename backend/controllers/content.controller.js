const db = require('../config/database');

const requestUpload = async (req, res) => {
  try {
    const { category_id, file_type } = req.body;

    if (!category_id || !file_type) {
      return res.status(400).json({ error: 'category_id and file_type are required' });
    }

    // Verify user has access to category
    const categoryCheck = await db.query(
      'SELECT id FROM categories WHERE id = $1 AND (owner_id = $2 OR id IN (SELECT category_id FROM category_members WHERE user_id = $2))',
      [category_id, req.user.userId]
    );

    if (categoryCheck.rows.length === 0) {
      return res.status(403).json({ error: 'Access denied to this category' });
    }

    // TODO: Generate MinIO presigned URL
    const uploadUrl = `https://minio.example.com/upload/${Date.now()}`;
    const contentId = require('crypto').randomUUID();

    res.json({
      content_id: contentId,
      upload_url: uploadUrl,
      expires_in: 3600,
    });
  } catch (error) {
    console.error('Request upload error:', error);
    res.status(500).json({ error: 'Failed to request upload' });
  }
};

const finalizeUpload = async (req, res) => {
  try {
    const { content_id, category_id, file_url, thumbnail_url, file_type, caption, location } = req.body;

    const result = await db.query(
      'INSERT INTO content (id, category_id, owner_id, file_url, thumbnail_url, file_type, caption, location) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *',
      [content_id, category_id, req.user.userId, file_url, thumbnail_url, file_type, caption || null, location || null]
    );

    res.status(201).json({ content: result.rows[0] });
  } catch (error) {
    console.error('Finalize upload error:', error);
    res.status(500).json({ error: 'Failed to finalize upload' });
  }
};

const getViewUrl = async (req, res) => {
  try {
    const contentId = req.params.id;

    const result = await db.query(
      `SELECT c.*, cat.name as category_name 
       FROM content c 
       JOIN categories cat ON c.category_id = cat.id 
       WHERE c.id = $1 AND (cat.owner_id = $2 OR cat.id IN (SELECT category_id FROM category_members WHERE user_id = $2))`,
      [contentId, req.user.userId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Content not found or access denied' });
    }

    res.json({ content: result.rows[0] });
  } catch (error) {
    console.error('Get view URL error:', error);
    res.status(500).json({ error: 'Failed to fetch content' });
  }
};

const listCategoryContent = async (req, res) => {
  try {
    const categoryId = req.params.id;

    // Verify access
    const categoryCheck = await db.query(
      'SELECT id FROM categories WHERE id = $1 AND (owner_id = $2 OR id IN (SELECT category_id FROM category_members WHERE user_id = $2))',
      [categoryId, req.user.userId]
    );

    if (categoryCheck.rows.length === 0) {
      return res.status(403).json({ error: 'Access denied to this category' });
    }

    const result = await db.query(
      'SELECT * FROM content WHERE category_id = $1 ORDER BY uploaded_at DESC',
      [categoryId]
    );

    res.json({ content: result.rows });
  } catch (error) {
    console.error('List category content error:', error);
    res.status(500).json({ error: 'Failed to fetch content' });
  }
};

const deleteContent = async (req, res) => {
  try {
    const contentId = req.params.id;

    const result = await db.query(
      'DELETE FROM content WHERE id = $1 AND owner_id = $2 RETURNING id',
      [contentId, req.user.userId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Content not found' });
    }

    // TODO: Delete from MinIO storage

    res.json({ message: 'Content deleted successfully' });
  } catch (error) {
    console.error('Delete content error:', error);
    res.status(500).json({ error: 'Failed to delete content' });
  }
};

module.exports = {
  requestUpload,
  finalizeUpload,
  getViewUrl,
  listCategoryContent,
  deleteContent,
};
