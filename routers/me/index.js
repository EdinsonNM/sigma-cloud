/* routers/auth/index.js */
'use strict';

const express = require('express');
const router = express.Router();
const users_ctrl = require('controllers/users');

router.get('/', [ AUTH.constructor.requireroles(), RX.validate(RX.NOT_ACCEPT_JSON), users_ctrl.getme ] );
router.put('/', [ AUTH.constructor.requireroles(), RX.validate(RX.NOT_ACCEPT_JSON), users_ctrl.putme ] );

module.exports = router;
