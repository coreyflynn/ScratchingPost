var mongoose = require('mongoose');
var mongo_config = require('./config/mongo');
var queue = require('./models/tool_collections').queue;
var loggly_client = require('./config/loggly').client;

//configure mongoose and get a connection reference
mongoose.connect(mongo_config.url);
var db = mongoose.connection;

//handle connection errors
db.on('error', console.error.bind(console, 'connection error:'));

//handle successful connections
db.on('open', function(){
    //as documents come across the stream, check their status and run them
    //if they have not been run.  Added the jobs to the log and update their
    //status as they progress through the job system
    var stream = queue.find({status:'pending'}).tailable().stream();
    stream.on("data", function(doc){
        console.log(doc);
        loggly_client.log(doc,['ComputeAPIDaemon','NewJob']);
    });
});