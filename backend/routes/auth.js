const express = require('express');
const router = express.Router();

// Route test
router.post('/login', (req, res) => {
    res.json({ token: "FAKE_JWT_TOKEN" });
});

module.exports = router;
