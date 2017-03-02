/* lib/rxvalidator/index.js */
'use strict';

const UTIL = require('lib/util');

const ERROR = require('lib/error');

const rxdef = {
	"NOT_ACCEPT_JSON": {
		type:"BadHeaderError",
		condition:"!request.headers.accept || request.headers.accept.indexOf('application/json')<0",
		message:"Must accept application/json",
		value:Math.pow(2,0)
	},
	"NOT_FORM_ENCODED": {
		type:"BadHeaderError",
		condition:"request.headers['content-type'].indexOf('application/x-www-form-urlencoded')<0",
		message:"Content-Type must be: application/x-www-form-urlencoded",
		value:Math.pow(2,1)
	},
	"NOT_APP_JSON": {
		type:"BadHeaderError",
		condition:"!request.headers['content-type'] || request.headers['content-type'].indexOf('application/json')<0",
		message:"Content-Type must be: application/json",
		value:Math.pow(2,2)
	},
	"ALREADY_LOGGED_IN": {
		type:"AuthError",
		condition:"request.dtoken",
		message:"current session already logged in",
		value:Math.pow(2,3)
	},
	"NOT_LOGGED_IN": {
		type:"AuthError",
		condition:"!request.dtoken",
		message:"user not logged in",
		value:Math.pow(2,4)
	},
	"NOT_FORMENCODED_OR_APPJSON": {
		type:"BadHeaderError",
		condition:"!request.headers['content-type'] || (request.headers['content-type'].indexOf('application/x-www-form-urlencoded')<0 && request.headers['content-type'].indexOf('application/json')<0)",
		message:"Request Content-Type must be: application/x-www-form-urlencoded or application/json",
		value:Math.pow(2,5)
	}
};

const buildEnum = function ( obj ) {
	let dict = {};
	for ( let key in obj ){
		if (typeof obj[key].value == 'number') {
			dict[key] = obj[key].value;
		}
	}
	return dict;
}

const rxenum = buildEnum ( rxdef );

const getKey = function getKey ( val ) {
	// search val in rxenum
	for ( let key in rxenum ) {
		if ( rxenum[key] == val ) return key;
	}
}

const validate = function validate ( rx ) {
	return function ( req, res, next ) {
		// TODO: perform bitwise to turn rx (int) to bitwise array
		let rxarr = UTIL.toBitwiseArray ( rx );
		for ( let rx of arrRX ) {
			let key = getKey(rx);
			let conditionresult = false;
			if ( rxdef[key] && rxdef[key].condition ) {
				conditionresult = eval( rxdef[key].condition );
			}
			if ( conditionresult ) {
				let err = new ERROR[ rxdef[key].type ] ( rxdef[key].message, rxdef[key].code );
				return RESPOND.InvalidRequest ( res, req, err );
			}
		}
		return next();
	}
}

let obj = {};

for( let enm in rxenum ) {
	obj[enm] = rxenum[enm];
}
obj.validate = validate;
module.exports = obj;
