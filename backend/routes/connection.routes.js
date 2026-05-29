const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth.middleware');
const {
  listConnections,
  sendRequest,
  acceptRequest,
  removeConnection,
} = require('../controllers/connection.controller');

router.use(authenticate);

router.get('/', listConnections);
router.post('/request', sendRequest);
router.post('/accept/:id', acceptRequest);
router.delete('/:id', removeConnection);

module.exports = router;
