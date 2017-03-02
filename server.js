/* server.js */
'use strict';

require('dotenv').config();
require('app-module-path').addPath(__dirname);

const path = require('path');
const express = require('express');
const nunjucks = require ('nunjucks');
const compression = require('compression');

global.app = express();

app.enable('trust proxy');
app.use( require('cors')() );
//app.disable('etag');
app.disable('x-powered-by');
app.use( compression( { threshold: 256 } ) ); // gzip deflate compression over http

// TRUST_PROXY
let tp = process.env.TRUST_PROXY || false;
console.log(tp);
if ( !( tp === false || tp == 'false' || tp == '0' ) ) {
	app.enable('trust proxy');
}


app.set('strict routing', true);

app.set('case sensitive routing', true);

global.Template_Env = nunjucks.configure( 'views',{ autoescape:true, express:app } );
app.engine( 'nunj', nunjucks.render );
app.set('view engine', 'nunj');

// STATIC_DIR
let staticDir = process.env.STATIC_DIR || null;
if ( staticDir ) {
	staticDir = path.resolve( __dirname, staticDir );
	let staticRUrl = process.env.STATIC_RURL || "/static";
	app.use( staticRUrl, express.static(staticDir) );
	console.info ("Static directory: " + staticDir + " exposed at: " + staticRUrl );
}



// some globals

global.ERROR = require('lib/error');
const logger = require('lib/logger');
global.LOGGER = new logger(process.env.NODE_ENV);
global.UTIL = require('lib/util');
global.RX = require('lib/rxvalidator');

const Auth = require('lib/auth');
global.DB = require('lib/db');
if ( process.env.JWT_SECRET ) {
	global.JWT_SECRET = process.env.JWT_SECRET;
	global.AUTH = new Auth(process.env.JWT_SECRET);
} else {
	throw new Error("JWT_SECRET env var not set.")
}

const fs = require('fs');
try {
	global.version = fs.readFileSync('./.version',{encoding:'utf8'}).replace(/(\r\n|\n|\r)/gm,"");
} catch ( e ) {
	var errlog = new ERROR.ServerError ( e, e.message );
	LOGGER.error( errlog );
	global.version = "error";
}


// routers
app.use( '/v1/me',      require('routers/me')      );
app.use( '/v1/version', require('routers/version') );

app.set('port', ( process.env.PORT || 8888 ));
app.listen( app.get('port'), function() {
	console.info(`Node app is running on port ${ app.get('port') }`);
});
