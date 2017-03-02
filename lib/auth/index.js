/* lib/auth/index.js */
/* authorization (not authentication) */
'use strict';

const JWT = require('jwt-simple');

const RESPOND = require('lib/respond');

class Auth {

	constructor ( secret ) {
		this.JWT_SECRET = secret || false;
		if (!this.JWT_SECRET) {
			let err = new ERROR.ServerError(null,"JWT_SECRET not supplied.");
			Logger.error(err);
			throw err;
		}
	}

	static decodeJWT ( jwt, secret ) {
		return JWT.decode( jwt, secret );
	}

	static encodeJWT ( payload, secret ) {
		return JWT.encode( payload, secret );
	}

	static hasRequiredRoles ( uroles, rroles ) {
		let filtered = ( uroles & rroles );
		return !( filtered ^ rroles );
	}

	// NOTE: returns false when a role in uroles is matched in rroles
	static hasNoDeniedRoles ( uroles, rroles ) {
		return !( uroles & rroles );
	}

	static parseAuthHeaders ( headers ) {
		if ( headers && headers.authorization ) {
			let parts = req.headers.authorization.split(' ');
			if (parts.length == 2) {
				let scheme = parts[0];
				let credentials = parts[1];
				if (/^Bearer$/i.test(scheme)) {
					return credentials;
				} else {
					let err = new ERROR.AuthError('Format is Authorization: Bearer [token]',ERROR.codes.JWT_CREDS_BAD_SCHEME);
					RouterBase.respondNotAuthorized( res, req, err );
					return false;
				}
			} else {
				let err = new ERROR.LoginError('Format is Authorization: Bearer [token]',ERROR.codes.JWT_CREDS_BAD_FORMAT);
				RouterBase.respondNotAuthorized( res, req, err );
				return false;
			}
		} else {
			let err = new ERROR.LoginError('JWT Authorization is required',ERROR.codes.JWT_CREDS_REQUIRED);
			RouterBase.respondNotAuthorized ( res, req, err );
			return false;
		}
	}

	static denyroles ( roles ) {
		return function ( req, res, next ) {
			let error;
			let token = Auth.constructor.parseAuthHeaders ( req.headers );
			if ( token instanceof ERROR.ErrorBase ) {
				return RESPOND.NotAuthorized( res, req, token );
			} else {
				try {
					let dtoken = AUTH.constructor.decodeJWT(token,AUTH.JWT_SECRET);
					let uroles = dtoken.roles;
					if ( !roles || roles == 0 ) {
						req.dtoken = dtoken;
						return next();
					} else if ( typeof uroles != 'number' || uroles < 0 ) {
						let err = new ERROR.LoginError('JWT payload is corrupt',ERROR.codes.JWT_PAYLOAD_CORRUPT);
						return RESPOND.NotAuthorized( res, req, err );
					} else {
						if ( !AUTH.constructor.hasNoDeniedRoles( uroles, rroles ) ) {
							let err = new ERROR.LoginError('Forbidden resource',ERROR.codes.FORBIDDEN);
							return RESPOND.Forbidden( res, req, err );
						} else {
							req.dtoken = dtoken;
							return next();
						}
					}
				} catch ( e ) {
					let err;
					switch ( e.message ) {
						case "Algorithm not supported":
							err = new ERROR.LoginError('JWT algorithm not supported',ERROR.codes.JWT_UNSUPPORTED_ALGORITHM);
						case "Token not yet active":
							err = new ERROR.LoginError('Token not yet active',ERROR.codes.JWT_TOKEN_NOT_ACTIVE);
						case "Token expired":
							err = new ERROR.LoginError('Token expired',ERROR.codes.JWT_TOKEN_EXPIRED);
						case "Signature verification failed":
							err = new ERROR.LoginError('Signature verification failed',ERROR.codes.JWT_SIG_VERIFY_FAILED);
						default:
							err = new ERROR.ServerError(e, e.message, ERROR.codes.SERVER_ERROR);
							return RESPOND.ServerError( res, req, err);
					}
					return RESPOND.NotAuthorized( res, req, err );
				}
			}
		}
	}

	static requireroles ( roles ) {
		return function ( req, res, next ) {
			let error;
			let token = Auth.constructor.parseAuthHeaders ( req.headers );
			if ( token instanceof ERROR.ErrorBase ) {
				return RESPOND.NotAuthorized( res, req, token );
			} else {
				try {
					let dtoken = AUTH.constructor.decodeJWT(token,AUTH.JWT_SECRET);
					let uroles = dtoken.roles;
					if ( !roles || roles == 0 ) {
						req.dtoken = dtoken;
						return next();
					} else if ( typeof uroles != 'number' || uroles < 0 ) {
						let err = new ERROR.LoginError('JWT payload is corrupt',ERROR.codes.JWT_PAYLOAD_CORRUPT);
						return RESPOND.NotAuthorized( res, req, err );
					} else {
						if ( !AUTH.constructor.hasRequiredRoles( uroles, rroles ) ) {
							let err = new ERROR.LoginError('Forbidden resource',ERROR.codes.FORBIDDEN);
							return RESPOND.Forbidden( res, req, err );
						} else {
							req.dtoken = dtoken;
							return next();
						}
					}
				} catch ( e ) {
					let err;
					switch ( e.message ) {
						case "Algorithm not supported":
							err = new ERROR.LoginError('JWT algorithm not supported',ERROR.codes.JWT_UNSUPPORTED_ALGORITHM);
						case "Token not yet active":
							err = new ERROR.LoginError('Token not yet active',ERROR.codes.JWT_TOKEN_NOT_ACTIVE);
						case "Token expired":
							err = new ERROR.LoginError('Token expired',ERROR.codes.JWT_TOKEN_EXPIRED);
						case "Signature verification failed":
							err = new ERROR.LoginError('Signature verification failed',ERROR.codes.JWT_SIG_VERIFY_FAILED);
						default:
							err = new ERROR.ServerError(e, e.message, ERROR.codes.SERVER_ERROR);
							return RESPOND.ServerError( res, req, err);
					}
					return RESPOND.NotAuthorized( res, req, err );
				}
			}
		}
	}

}

module.exports = Auth;
