'use strict';

var http = require( 'http' );

var server = http.createServer( function ( req, res ) {
  var start = new Date();
  setImmediate( function () {
    res.writeHead( 200, { 'Content-Type': 'application/json' } );
    res.end( ( new Date() - start ).valueOf() + 'ms\r\n' );
  } );
} );

server.listen( process.env.PORT || 8080 );

process.stdout.write( 'node server launched\n' );

setTimeout( function () {
  process.stdout.write( '"standard node server" test passed\n' );
  process.exit();
}, 1000 );
