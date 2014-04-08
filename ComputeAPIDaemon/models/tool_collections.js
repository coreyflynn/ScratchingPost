var mongoose = require('mongoose');

//define the schema for our queue model
var queueSchema = mongoose.Schema({
    job_id: String,
    status: String
},{
    collection: 'queue',
});

//define the schema for our log model
var logSchema = mongoose.Schema({
    job_id: String,
    status: String
},{
    collection: 'log',
    strict: false
});

//create the models and expose them
module.exports = {
    queue: mongoose.model('queue', queueSchema),
    log: mongoose.model('log', logSchema)
}