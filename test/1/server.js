'use strict';

var http = require( 'http' );

process.env.PORT = process.env.PORT || 8080;

var server = http.createServer( function ( req, res ) {
  var start = new Date();
  setImmediate( function () {
    res.writeHead( 200, { 'Content-Type': 'application/json' } );
    res.end( ( new Date() - start ).valueOf() + 'ms\r\n' );
  } );
} );

server.listen( process.env.PORT );

process.stdout.write( 'node server listening on port :' + ( process.env.PORT ) + '...\n' );
