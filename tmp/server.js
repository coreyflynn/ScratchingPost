//get all of the libraries we need to run the app
var express = require('express');
var app = express();
var port = 8080;
var mongoose = require('mongoose');
var passport = require('passport');
var flash = require('connect-flash');

var configDB = require('./config/database.js');

//config
mongoose.connect(configDB.url);

require('./config/passport')(passport); // pass passport for configuration

app.configure(function() {
    //set up the express app
    app.use(express.logger('dev')); //lag all requests to the console
    app.use(express.cookieParser()); // read cookies (needed for OAuth)
    app.use(express.bodyParser()); //get info from html forms
    app.set('view engine','jade');
    app.use(express.static(__dirname + '/public'));
    
    //required for passport to work
    app.use(express.session({secret: 'sessionsecret'}));
    app.use(passport.initialize());
    app.use(passport.session()); //persistent login sessions
    app.use(flash()); //use connect-flash for flash messages stored in session
});

//routes
require('./app/routes.js')(app,passport); //load our routes and pass in our app and fully configured passport

//launch
app.listen(port);
console.log('app listening on port ' + port);