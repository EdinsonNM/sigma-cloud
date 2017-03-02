/* controllers/users/index.js */
'use strict';

const umodel = require('models/users');

const ECODES = ERROR.codes;
const DBERR = DB.errcodes;
const RESPOND = require('lib/respond');

const _getme = function _getme ( req, res, next ) {
	let path = req.path;
	umodel.getMe ( req.dtoken.uid, function ( error, data ) {
		if ( error ) {
			switch (error.code) {
				case DBERR.resource_not_found :
					let wrapper = RESPOND.wrapper ( {}, path, true );
					RESPOND.Success( res, req, wrapper );
					return next();
				default:
					let errlog = new ERROR.DataBaseError ( error, error.message );
					LOGGER.error( errlog );
					RESPOND.ServerError ( res, req, errlog );
					return next ();
			}
		} else {
			let wrapper = RESPOND.wrapper ( data, path, true );
			RESPOND.Success( res, req, wrapper );
			return next();
		}
	});
};

const _putme = function _putme ( req, res, next ) {
	let path = req.path;
	umodel.putme ( req.body, function ( error, data ) {
		if ( error ) {
			let errlog = new ERROR.DataBaseError ( error, error.message );
			LOGGER.error( errlog );
			RESPOND.ServerError ( res, req, errlog );
			return next ();
		} else {
			let wrapper = RESPOND.wrapper( data, path, true );
			RESPOND.Success( res, req, wrapper );
			return next();
		}
	});
};

const _getusers = function _getusers ( req, res, next ) {
	let path = req.path;
	umodel.getUsers ( function ( error, data ) {
		if ( error ) {
			let errlog = new ERROR.DataBaseError ( error, error.message );
			LOGGER.error( errlog );
			RESPOND.ServerError ( res, req, errlog );
			return next ();
		} else {
			let wrapper = RESPOND.wrapper( data, path, true );
			RESPOND.Success( res, req, wrapper );
			return next();
		}
	});
};

exports.putme = _putme;
exports.getme = _getme;
exports.getusers = _getusers;
