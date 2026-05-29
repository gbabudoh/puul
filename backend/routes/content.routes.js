const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth.middleware');
const {
  requestUpload,
  finalizeUpload,
  getViewUrl,
  listCategoryContent,
  deleteContent,
} = require('../controllers/content.controller');

router.use(authenticate);

router.post('/upload/request', requestUpload);
router.post('/upload/finalize', finalizeUpload);
router.get('/view/:id', getViewUrl);
router.delete('/:id', deleteContent);

module.exports = router;
