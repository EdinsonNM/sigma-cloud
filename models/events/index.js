/* models/events/index.js */
'use strict';

const _getEventsByTags = function _getEvents ( tagmaskarr, next ) {
	let stmt = "select fn_get_event_by_tags($1::int[])";
	let params = [ tagmaskarr ];
	DB.query( stmt, params, function ( error, result ) {
		if ( error ) {
			next ( error );
		} else {
			next ( null, result.rows[0].fn_get_event_by_tags );
		}
	});
};


const _getEventsByIds = function _getEventsByIds ( eidsarray, next ) {
	let stmt = "select fn_get_events_by_ids($1::int[])";
	let params = [ eidsarray ];
	DB.query( stmt, params, function ( error, result ) {
		if ( error ) {
			next ( error );
		} else {
			next ( null, result.rows[0].fn_get_events_by_ids );
		}
	});
};


const _getEventById = function _getEventById ( eid, next ) {
	let stmt = "select fn_get_event_by_id($1::int)";
	let params = [ eid ];
	DB.query( stmt, params, function ( error, result ) {
		if ( error ) {
			next ( error );
		} else {
			next ( null, result.rows[0].fn_get_event_by_id );
		}
	});
};


const _postEvent = function _postEvent ( eventObj, uid, next ) {
	let stmt = "select fn_post_event($1::json, $2::int)";
	let params = [ eventObj, uid ];
	DB.query( stmt, params, function ( error, result ) {
		if ( error ) {
			next ( error );
		} else {
			next ( null, result.rows[0].fn_post_event );
		}
	});
};


const _patchEvent = function _postEvent ( eid, eventObj, uid, next ) {
	let stmt = "select fn_patch_event($1::int, $2::json, $3::int)";
	let params = [ eid, eventObj, uid ]
	DB.query( stmt, params, function ( error, result ) {
		if ( error ) {
			next ( error );
		} else {
			next ( null, result.rows[0].fn_patch_event );
		}
	});
};


const _deleteEvent = function _deleteEvent ( eid, uid, next ) {
	let stmt = "select fn_delete_event($1::int, $2::int)";
	let params = [ eid, uid ]
	DB.query( stmt, params, function ( error, result ) {
		if ( error ) {
			next ( error );
		} else {
			next ( null, result.rows[0].fn_delete_event );
		}
	});
};


const _unpublishEvent = function _unpublishEvent ( eid, uid, next ) {
	let stmt = "select fn_unpublish_event($1::int, $2::int)";
	let params = [ eid, uid ];
	DB.query( stmt, params, function ( error, result ) {
		if ( error ) {
			next ( error );
		} else {
			next ( null, result.rows[0].fn_unpublishEvent_event );
		}
	});
};


const _publishEvent = function _publishEvent ( eid, uid, next ) {
	let stmt = "select fn_publish_event($1::int, $2::int)";
	let params = [ eid, uid ];
	DB.query( stmt, params, function ( error, result ) {
		if ( error ) {
			next ( error );
		} else {
			next ( null, result.rows[0].fn_publishEvent_event );
		}
	});
};


exports.getEventById = _getEventById;
exports.postEvent = _postEvent;
