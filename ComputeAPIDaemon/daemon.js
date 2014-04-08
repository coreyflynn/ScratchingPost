var mongoose = require('mongoose');
var async = require('async');
var Q = require('q');
var path = require('path');
var exec = require('child_process').exec;
var mongo_config = require('./config/mongo');
var queue = require('./models/tool_collections').queue;
var log = require('./models/tool_collections').log;
var loggly_client = require('./config/loggly').client;
var aws_methods = require('./util/aws_methods');

//configure mongoose and get a connection reference
mongoose.connect(mongo_config.url);
var db = mongoose.connection;

//log the start of the Daemon
loggly_client.log({}, ['ComputeAPIDaemon','DaemonStart']);

//handle connection errors
db.on('error', console.error.bind(console, 'connection error:'));

//handle successful connections
db.on('open', function(){
    //as documents come across the stream, check their status and run them
    //if they have not been run.  Added the jobs to the log and update their
    //status as they progress through the job system
    var stream = queue.find({}).tailable().stream();
    stream.on("data", function(doc){
        Q.nfcall(get_log_doc,doc.job_id)
        .then(function(doc){
            return Q.nfcall(save_local_files,doc);
        })
        .then(function(doc){
            return Q.nfcall(submit_job,doc);
        })
        .catch(function(err){throw err});
        });
    });


var get_log_doc = function(job_id,callback){
    log.findOne({job_id: job_id},function(err, doc){
        if (err) callback(err);
        callback(null,doc);
    });
}

var save_local_files = function(doc,callback){
    if (doc.status === 'pending'){
        loggly_client.log(doc, ['ComputeAPIDaemon','SaveLocalFiles']);
        console.log('saving local files: ' + doc.job_id);
        var keys = Object.keys(doc.params);
        keys.forEach(function(key){
            var aws_key = doc.params[key].aws_key;
            if (aws_key !== undefined){
               aws_methods.download_file_from_bucket('ComputeAPITempFiles',aws_key,'file_downloads/' + aws_key,function(err,file_path){
                   if (err) callback(err);
               });
            }
        });
    }
    callback(null,doc);
}

var submit_job = function(doc,callback){
    if (doc.status === 'pending'){
        loggly_client.log(doc, ['ComputeAPIDaemon','SubmitJob']);
        console.log('submitting: ' + doc.job_id);
        
        var tmp_folder = 'sig_tool_result' + new Date().getTime();
        fs.mkdirSync('tmp');
        var q_submit = exec('q sig_query_tool',function(err,stdout,stderr){
            if (err !== null){
                console.log(err);
            }
            console.log(stdout);
        });
    }
}

var update_log = function(doc,status,callback){
    log.update({job_id: doc.job_id},{status: status},function(err){
        if (err) callback(err);   
        console.log('updated job status: ' + doc.job_id + ':' + status);
        loggly_client.log(doc, ['ComputeAPIDaemon','UpdateStatus',status]);
        callback(null,doc);
    });
}

// given a ssh2 connection and a command to run, submit it using 
// a system call to 'q' after seting up the environment in the cluster.
var submit = function (ssh2_connection, command, callback){
	var tmp_folder = 'sig_tool_result' + new Date().getTime();
	ssh2_connection.exec('source /etc/profile; mkdir -p $HOME/public_html/' + tmp_folder + '; q '  + command + ' --out ' + tmp_folder + ' --mkdir 0 ', function (err, stream){
		// if we error out, bubble the error through the callback
		if (err) callback(err);

		// grab the second line of the output from the stream as it provides
		// the job number that the cluster is going to use for the submitted
		// process
		var job_object = {};
		var chunk_number = 0;
		stream.on('data', function (chunk){
			chunk_number ++;
			if (chunk_number === 2){
				job_object.job_number = chunk.toString().split(' ')[2];
				job_object.status = 'submitted';
				job_object.output_folder = '$HOME/public_html/' + tmp_folder;

			}
		});

		// if the stream ends normally, call the callback and provide
		// the job number to the callback
		stream.on('end', function (){
			callback(null, job_object);
		});
	})
};