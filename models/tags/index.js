/* models/tags/index.js */
'use strict';

const _getTagsSearch = function _getTagsSearch ( tagtxt, locale, next ) {
	let stmt = "select fn_get_tags_search($1::text)";
	let params = [ tagtxt.split(" ") ];
	DB.query( stmt, params, function ( error, result ) {
		if ( error ) {
			next ( error );
		} else {
			next ( null, result.rows[0].fn_get_tags_search );
		}
	});
};


const _putTag = function _putTag ( tag, locale, ref, next ) {
	let stmt = "select fn_put_tag($1::text, $2::text, $3::text)";
	let params = [ tag, locale, ref ];
	DB.query( stmt, params, function ( error, result ) {
		if ( error ) {
			next ( error );
		} else {
			next ( null, result.rows[0].fn_put_tag );
		}
	});
}



exports.getTagsSearch = _getTagsSearch;
exports.putTag = _putTag;
