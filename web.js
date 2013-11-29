// Load the http module to create an http server.
var http = require('http');
var CoffeeScript = require('coffee-script');

// Configure our HTTP server to respond with Hello World to all requests.
/*var server = http.createServer(function (request, response) {
  response.writeHead(200, {"Content-Type": "text/plain"});
  response.end("Hello World\n");
});*/

var express = require('express');
var app = express();
app.use(express.logger());
app.use('/', express.static(__dirname + '/static'));
app.use('/js', express.static(__dirname + '/bower_components'));
app.use('/nodejs', express.static(__dirname + '/node_modules'));

var port = process.env.PORT || 5000;
app.listen(port, function() {
  console.log("Listening on " + port);
});

app.get('/', function(request, response) {
  response.send('Hello World!');
});

app.get('/test', function(request, response) {
  response.send('Hello Test!');
});

//app.use require('connect-assets')(directory)

app.get('/coffee/list-github.js', function(request, response) {
  var result = CoffeeScript.compile('coffee/list-github.coffee');
  response.send(result);
});

// Listen on port 8000, IP defaults to 127.0.0.1
//server.listen(process.env.PORT, process.env.IP);

// Put a friendly message on the terminal
console.log("Server running at " + process.env.IP + ":" + process.env.PORT)
