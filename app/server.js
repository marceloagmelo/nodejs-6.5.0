// Load the http module to create an http server.
var http = require('http');

// Configure our HTTP server to respond with Hello World to all requests.
var server = http.createServer(function (request, response) {
  //response.writeHead(200, {"Content-Type": "text/plain"});
  //response.end("Hello World!\nIm working!!");
  response.sendFile(__dirname + "/app.js");
});

server.listen(process.env.VCAP_APP_PORT || 8080);

// Put a friendly message on the terminal
console.log("Server UP&Running");
