/* lib/db/index.js */
'use strict';

const pg = require('pg');
const PGProfiler = require('lib/pg-profiler');
const logger = require('lib/logger');
const Logger = global.Logger || new logger(process.env.NODE_ENV);

let config = { max:10, idleTimeoutMillis: 10000 };

let pool = new pg.Pool(config);

pool.on('error', function(error, client) {
	Logger.error(error);
})

let _query = function _query ( statement, params, next ) {
	pool.queryT = pool.query;
	if ( process.env.PGPROFILE &&  process.env.PGPROFILE != "false" ) {
		let pgProfiler = new PGProfiler(pool.query, Logger);
		pool.queryT = pgProfiler.profile(pool);
	}
	return pool.queryT( statement, params, next );
};
exports.query = _query;


exports.errcodes = {
	"integrity_constraint_violation":"23000",
	"restrict_violation":"23001",
	"not_null_violation":"23502",
	"foreign_key_violation":"23503",
	"unique_violation":"23505",
	"check_violation":"23514",
	"numeric_value_out_of_range":"22003",
	"string_data_length_mismatch":"22026",
	"identity_not_found":"C1U00",
	"resource_not_found":"R1QA1"
}
