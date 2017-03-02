/* controllers/version/index.js */
'use strict';

const vmodel = require('models/version');

const DBERR = DB.errcodes;
const RESPOND = require('lib/respond');

const _getVersion = function _getVersion ( req, res, next ) {
	let path = req.path;
	let ver = { version:version };
	vmodel.getVersion ( function ( error, data ) {
		if ( error ) {
			let errlog = new ERROR.DataBaseError ( error, error.message );
			LOGGER.error( errlog );
			ver.db = "error";
			let wrapper = RESPOND.wrapper ( ver, path, true );
			RESPOND.Success( res, req, wrapper );
			return next();
		} else {
			ver.db = data;
			let wrapper = RESPOND.wrapper ( ver, path, true );
			RESPOND.Success( res, req, wrapper );
			return next();
		}
	});
};

exports.getVersion = _getVersion;
