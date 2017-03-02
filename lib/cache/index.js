/* lib/cache/index.js */
/* a memcache wrapper package - simplifying namespacing for key/value store */
'use strict'

/* TODO: migrate to ES6 class */

var Memcached = require('memcached');

function NSMemcached ( namespace, servers, options ) {
	var _self = this;
	var _namespace = namespace;
	var _memcached = new Memcached( servers, options );
	var _nsk = function _nsk ( key ) { return _namespace + "::" + key; };
	this.nsk = function nsk ( key ) { return _nsk(key); };
	this.getNamespace = function getNamespace () { return _namespace; };
	this.touch = function touch ( key, lifetime, callback ) {
		_memcached.touch( _nsk(key), lifetime, callback );
	};
	this.get = function get ( key, callback ) {
		_memcached.get ( _nsk(key), callback );
	};
	this.gets = function gets ( key, callback ) {
		_memcached.gets ( _nsk(key), callback );
	};
	this.getMulti = function getMulti ( keys, callback ) {
		for ( var i=0; i < keys.length; i++ ) {
			keys[i] = _nsk(keys[i]);
		}
		_memcached.getMulti ( keys, callback );
	};
	this.set = function set ( key, value, lifetime, callback ) {
		_memcached.set ( _nsk(key), value, lifetime, callback );
	};
	this.replace = function replace ( key, value, lifetime, callback ) {
		_memcached.replace ( _nsk(key), value, lifetime, callback );
	};
	this.add = function add ( key, value, lifetime, callback ) {
		_memcached.add ( _nsk(key), value, lifetime, callback );
	};
	this.cas = function cas ( key, value, lifetime, casstr,  callback ) {
		_memcached.cas ( _nsk(key), value, lifetime, casstr, callback );
	};
	this.append = function append ( key, value, callback ) {
		var newkey = _nsk(key);
		_memcached.append ( newkey, value, callback );
	};
	this.prepend = function append ( key, value, callback ) {
		_memcached.prepend ( _nsk(key), value, callback );
	};
	this.incr = function incr ( key, amount, callback ) {
		_memcached.incr ( _nsk(key), amount, callback );
	};
	this.decr = function incr ( key, amount, callback ) {
		_memcached.decr ( _nsk(key), amount, callback );
	};
	this.del = function del ( key, callback ) {
		_memcached.del ( _nsk(key), callback );
	};
	this.flush = function flush ( callback ) {
		// TODO: go through all keys and delete those with namespace
	};
}

module.exports = NSMemcached;
