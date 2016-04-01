var ws = require("nodejs-websocket")
var _ = require('lodash');

var global_counter = 0;
var all_active_connections = {};

// Scream server example: "hi" -> "HI!!!"
var server = ws.createServer(function (conn) {
	console.log("New connection")

	var id = global_counter++;
  all_active_connections[id] = conn;
	conn.id = id;

	conn.on("text", function (str) {

    var message = filterMessage(JSON.parse(str));

    console.log("Received: " + JSON.stringify(message));

		for (conn in all_active_connections) {
			all_active_connections[conn].sendText(JSON.stringify(message));
		}
	})
	conn.on("close", function (code, reason) {
		console.log("Connection closed");
		delete all_active_connections[conn.id];
	})
}).listen(8001)

function filterMessage(message) {

  // Pick the properties we need
  var msg = _.pick(message, ['nick', 'content', 'created_at', 'tags', 'thread_id', ]);

  // Remove tags from message contente as they are in the tags array already
  var regexp = new RegExp('#([^\\s]*)','g');
  msg.content = _.trim(msg.content.replace(regexp, ''));

  return msg;
}

// Object {user: "52589", content: "Test", event: "message", tags: Array[0], id: 6…}
// app
// :
// "chat"
// attachments
// :
// Array[0]
// content
// :
// "Test"
// created_at
// :
// "2016-04-01T06:12:54.595Z"
// edited
// :
// null
// edited_at
// :
// null
// event
// :
// "message"
// flow
// :
// "78e9b3f0-d566-4810-9f01-9bc32b5d5cee"
// id
// :
// 6
// nick
// :
// "TimoL"
// sent
// :
// 1459491174595
// tags
// :
// Array[0]
// thread
// :
// Object
// thread_id
// :
// "8NN1O6Y73uduxiwY_CeVg88ICn0"
// user
// :
// "52589"
// uuid
// :
// "KHVQzuH_JaiQmvAw"
// __proto__
// :
// Object
