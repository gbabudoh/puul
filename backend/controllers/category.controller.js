const db = require('../config/database');

const listCategories = async (req, res) => {
  try {
    const result = await db.query(
      'SELECT * FROM categories WHERE owner_id = $1 ORDER BY created_at DESC',
      [req.user.userId]
    );
    res.json({ categories: result.rows });
  } catch (error) {
    console.error('List categories error:', error);
    res.status(500).json({ error: 'Failed to fetch categories' });
  }
};

const createCategory = async (req, res) => {
  try {
    const { name, category_tag, visibility } = req.body;
    
    if (!name || !category_tag) {
      return res.status(400).json({ error: 'Name and category_tag are required' });
    }

    const result = await db.query(
      'INSERT INTO categories (owner_id, name, category_tag, visibility) VALUES ($1, $2, $3, $4) RETURNING *',
      [req.user.userId, name, category_tag, visibility || 'private']
    );

    res.status(201).json({ category: result.rows[0] });
  } catch (error) {
    console.error('Create category error:', error);
    res.status(500).json({ error: 'Failed to create category' });
  }
};

const getCategoryById = async (req, res) => {
  try {
    const result = await db.query(
      'SELECT * FROM categories WHERE id = $1 AND owner_id = $2',
      [req.params.id, req.user.userId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Category not found' });
    }

    res.json({ category: result.rows[0] });
  } catch (error) {
    console.error('Get category error:', error);
    res.status(500).json({ error: 'Failed to fetch category' });
  }
};

const updateCategory = async (req, res) => {
  try {
    const { name, category_tag, visibility } = req.body;
    
    const result = await db.query(
      'UPDATE categories SET name = COALESCE($1, name), category_tag = COALESCE($2, category_tag), visibility = COALESCE($3, visibility) WHERE id = $4 AND owner_id = $5 RETURNING *',
      [name, category_tag, visibility, req.params.id, req.user.userId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Category not found' });
    }

    res.json({ category: result.rows[0] });
  } catch (error) {
    console.error('Update category error:', error);
    res.status(500).json({ error: 'Failed to update category' });
  }
};

const deleteCategory = async (req, res) => {
  try {
    const result = await db.query(
      'DELETE FROM categories WHERE id = $1 AND owner_id = $2 RETURNING id',
      [req.params.id, req.user.userId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Category not found' });
    }

    res.json({ message: 'Category deleted successfully' });
  } catch (error) {
    console.error('Delete category error:', error);
    res.status(500).json({ error: 'Failed to delete category' });
  }
};

const addMember = async (req, res) => {
  try {
    const { user_id } = req.body;
    const categoryId = req.params.id;

    // Verify category ownership
    const categoryCheck = await db.query(
      'SELECT id FROM categories WHERE id = $1 AND owner_id = $2',
      [categoryId, req.user.userId]
    );

    if (categoryCheck.rows.length === 0) {
      return res.status(404).json({ error: 'Category not found' });
    }

    // Add member
    await db.query(
      'INSERT INTO category_members (category_id, user_id) VALUES ($1, $2) ON CONFLICT DO NOTHING',
      [categoryId, user_id]
    );

    res.status(201).json({ message: 'Member added successfully' });
  } catch (error) {
    console.error('Add member error:', error);
    res.status(500).json({ error: 'Failed to add member' });
  }
};

const removeMember = async (req, res) => {
  try {
    const { userId } = req.params;
    const categoryId = req.params.id;

    // Verify category ownership
    const categoryCheck = await db.query(
      'SELECT id FROM categories WHERE id = $1 AND owner_id = $2',
      [categoryId, req.user.userId]
    );

    if (categoryCheck.rows.length === 0) {
      return res.status(404).json({ error: 'Category not found' });
    }

    await db.query(
      'DELETE FROM category_members WHERE category_id = $1 AND user_id = $2',
      [categoryId, userId]
    );

    res.json({ message: 'Member removed successfully' });
  } catch (error) {
    console.error('Remove member error:', error);
    res.status(500).json({ error: 'Failed to remove member' });
  }
};

const listMembers = async (req, res) => {
  try {
    const categoryId = req.params.id;

    // Verify category ownership
    const categoryCheck = await db.query(
      'SELECT id FROM categories WHERE id = $1 AND owner_id = $2',
      [categoryId, req.user.userId]
    );

    if (categoryCheck.rows.length === 0) {
      return res.status(404).json({ error: 'Category not found' });
    }

    const result = await db.query(
      `SELECT u.id, u.phone_number, u.email, cm.joined_at 
       FROM category_members cm 
       JOIN users u ON cm.user_id = u.id 
       WHERE cm.category_id = $1`,
      [categoryId]
    );

    res.json({ members: result.rows });
  } catch (error) {
    console.error('List members error:', error);
    res.status(500).json({ error: 'Failed to fetch members' });
  }
};

module.exports = {
  listCategories,
  createCategory,
  getCategoryById,
  updateCategory,
  deleteCategory,
  addMember,
  removeMember,
  listMembers,
};
