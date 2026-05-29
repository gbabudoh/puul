const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth.middleware');
const {
  listCategories,
  createCategory,
  getCategoryById,
  updateCategory,
  deleteCategory,
  addMember,
  removeMember,
  listMembers,
} = require('../controllers/category.controller');

router.use(authenticate);

router.get('/', listCategories);
router.post('/', createCategory);
router.get('/:id', getCategoryById);
router.put('/:id', updateCategory);
router.delete('/:id', deleteCategory);

// Member management
router.post('/:id/members', addMember);
router.delete('/:id/members/:userId', removeMember);
router.get('/:id/members', listMembers);

// Category content
router.get('/:id/content', require('../controllers/content.controller').listCategoryContent);

module.exports = router;
