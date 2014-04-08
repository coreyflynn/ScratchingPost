// Module dependencies.
var express = require('express');
var routes = require('./routes');
var post = require('./routes/post');
var user = require('./routes/user');
var http = require('http');
var path = require('path');
var email_notifier = require('./util/email_notifier').email_notifier;
var CORS = require('./util/CORS');

// globals
var app = express();

// all environments
app.set('port', process.env.PORT || 8080);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');
app.use(express.favicon());
app.use(express.logger('dev'));
app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(app.router);
app.use(express.static(path.join(__dirname, 'public')));
//app.use(email_notifier);
app.use(CORS);

// development only
if ('development' == app.get('env')) {
  app.use(express.errorHandler());
}

// GET routes
app.get('/', routes.index);
app.get('/users', user.list);

// POST routes
app.post('/',post.default);

// start the server
http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});