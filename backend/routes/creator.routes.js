const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth.middleware');
const {
  getDashboard,
  listCampaigns,
  requestPayout,
} = require('../controllers/creator.controller');

router.use(authenticate);

router.get('/dashboard', getDashboard);
router.get('/campaigns', listCampaigns);
router.post('/payout', requestPayout);

module.exports = router;
