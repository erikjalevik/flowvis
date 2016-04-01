var ws = require("nodejs-websocket")
var _ = require('lodash');

// Keep track of connections with the connection store
var global_counter = 0;
var all_active_connections = {};

// Create the server and listen to connections in port 8001
var server = ws.createServer(function (conn) {
	console.log("New connection")

	// Add new connections to the connection store
	var id = global_counter++;
  all_active_connections[id] = conn;
	conn.id = id;

	// Handler for incoming text
	conn.on("text", function (str) {

    var message = filterMessage(JSON.parse(str));

    console.log("Received: " + JSON.stringify(message));

		for (conn in all_active_connections) {
			all_active_connections[conn].sendText(JSON.stringify(message));
		}
	})

	// Handler for closing connections
	conn.on("close", function (code, reason) {
		console.log("Connection closed");
		delete all_active_connections[conn.id];
	})
}).listen(8001)

// Filter junk that's not needed from the message object
function filterMessage(message) {

  // Pick the properties we need
  var msg = _.pick(message, ['nick', 'content', 'created_at', 'tags', 'thread_id', ]);

  // Remove tags from message contente as they are in the tags array already
  var regexp = new RegExp('#([^\\s]*)','g');
  msg.content = _.trim(msg.content.replace(regexp, ''));

  return msg;
}
