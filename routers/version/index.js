/* routers/version/index.js */
'use strict';

const express = require('express');
const router = express.Router();
const AUTH = require('lib/auth');
const RX = require('lib/rxvalidator');
const RXE = RX.enum
const version_ctrl = require('controllers/version');

router.get('/', [ RX.validate(RX.NOT_ACCEPT_JSON), version_ctrl.getVersion ] );

module.exports = router
