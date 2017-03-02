/* lib/util/index.js */
'use strict';

exports.toBitwiseArray = function toBitwiseArray ( intmask ) {
	let bwarr = [];
	for ( let x=31; x >= 0; x--) {
		if ( intmask >> x == 0 ) continue;
		else bwarr.push(Math.pow(2,x));
	}
	return bwarr.reverse();
}

exports.getJSON = function getJSON (parsedUrl, next) {
	var url = require('url');
	var http = require('https');
	var strUrl = url.format(parsedUrl);
	http.get(strUrl, function (res) {
		var strData = '';
		res.on('data', function (chunk) {
			strData += chunk;
		});
		res.on('error', function (error) {
			return next(error, strData);
		});
		res.on('end', function () {
			try {
				return next(null,JSON.parse(strData));
			}
			catch (e) {
				return next(e,"Could not parse JSON from server response.");
			}
		});
	});
};
