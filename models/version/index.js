/* models/ version/index.js */
'use strict';

const _getVersion = function _getSetById ( next ) {
	let stmt = "select fn_get_version()";
	DB.query( stmt, null, function ( error, result ) {
		if ( error ) {
			next ( error );
		} else {
			next ( null, result.rows[0].fn_get_version );
		}
	});
};

exports.getVersion = _getVersion;
