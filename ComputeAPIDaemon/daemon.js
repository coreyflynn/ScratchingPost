var mongoose = require('mongoose');
var async = require('async');
var fs = require('fs');
var Q = require('q');
var path = require('path');
var spawn = require('child_process').spawn;
var execSync = require('execSync');
var mongo_config = require('./config/mongo');
var queue = require('./models/tool_collections').queue;
var log = require('./models/tool_collections').log;
var loggly_client = require('./config/loggly').client;
var logentries_log = require('./config/logentries').log;
var aws_methods = require('./util/aws_methods');

//configure mongoose and get a connection reference
mongoose.connect(mongo_config.url);
var db = mongoose.connection;

//log the start of the Daemon
logentries_log.log("info", {tags: ['ComputeAPIDaemon','DaemonStart']});
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
            return Q.nfcall(build_arguments,doc);
        })
        .then(function(obj){
            return Q.nfcall(submit_job,obj.doc,obj.arguments);
        })
        .then(function(job_object){
            return Q.nfcall(update_log,job_object,'submitted');
        })
        .then(function(job_object){
            return Q.nfcall(poll_job,job_object);
        })
        .then(function(job_object){
            return Q.nfcall(update_log,job_object,'completed');
        })
        .then(function(job_object){
            return Q.nfcall(tar,job_object);
        })
        .then(function(job_object){
            return Q.nfcall(s3_upload,job_object);
        })
        .then(function(job_object){
            return Q.nfcall(cleanup,job_object);
        })
        .catch(function(err){console.log('error: '+ err.stack)});
        });
    });


var get_log_doc = function(job_id,callback){
    log.findOne({job_id: job_id},function(err, doc){
        if (err) callback(err);
        logentries_log.log("info", {tags: ['ComputeAPIDaemon','GetLogDoc'], job_id: job_id});
        loggly_client.log(doc.toObject(), ['ComputeAPIDaemon','GetLogDoc']);
        callback(null,doc);
    });
}

var save_local_files = function(doc,callback){
    if (doc.status === 'pending' && doc.params !== undefined){
        update_log(doc,'claimed');
        logentries_log.log("info", {tags: ['ComputeAPIDaemon','SaveLocalFiles'], job_id: doc.job_id});
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

var build_arguments = function(doc,callback){
    if (doc.status === 'pending'){
        logentries_log.log("info", {tags: ['ComputeAPIDaemon','BuildArguments'], job_id: doc.job_id});
        loggly_client.log(doc, ['ComputeAPIDaemon','BuildArguments']);
        var arguments = new Array();
        console.log('building arguments: ' + doc.job_id);
        // get the tool name
        var tool = doc.params.tool;
        if (tool === undefined){
            tool = 'tool_foo';
        }
        arguments.push(tool);
        var output_folder = __dirname + '/sig_tool_result' + new Date().getTime();
        doc.output_folder = output_folder;
        arguments = arguments.concat(['--out',output_folder,'--mkdir','0']);

        // get the parameters
        var param_keys = Object.keys(doc.params);
        for(var i = 0; i < param_keys.length; i++){
            var key = param_keys[i];
            if (key !== 'tool'){
                if (key.length === 1){
                    arguments.push('-' + key);
                }else{
                    arguments.push('--' + key);
                }
                if (typeof(doc.params[key]) === 'object'){
                    arguments.push(__dirname + '/file_downloads/' + doc.params[key].aws_key);
                }else{
                    arguments.push(doc.params[key]);
                }
            }
        };
        // return the built array and the original mongo document
        callback(null,{doc: doc, arguments: arguments});
    }
    // return the built array and the original mongo document
    callback(null,{doc:doc, arguments: []});
}

var submit_job = function(doc,arguments,callback){
    if (doc.status === 'pending'){
        logentries_log.log("info", {tags: ['ComputeAPIDaemon','SubmitJob'], job_id: doc.job_id});
        loggly_client.log(doc, ['ComputeAPIDaemon','SubmitJob']);
        console.log('submitting: ' + doc.job_id);

        var tmp_folder = 'sig_tool_result' + new Date().getTime();
        execSync.run('mkdir -p ' + doc.output_folder);
        var q_submit = spawn('q',arguments);
        q_submit.stderr.setEncoding('utf8');
        q_submit.stderr.on('data',function(data){
            console.log(data);
        });
        var job_object = doc.toObject();
		var chunk_number = 0;
        q_submit.stdout.on('data',function(data){
            chunk_number ++;
			if (chunk_number === 2){
				doc.c3_job_number = data.toString().split(' ')[2];
                callback(null,doc);
			}
        });
    }
}

var poll_job = function(job_object,callback){
    logentries_log.log("info", {tags: ['ComputeAPIDaemon','PollJob'], job_id: job_object.job_id});
    loggly_client.log(job_object, ['ComputeAPIDaemon','PollJob']);
    console.log('polling: ' + job_object.job_id);
    // make sure our environment is set up correctly
    execSync.run('source /etc/profile');
    var poll_timer = setInterval(function (){
        var is_running = false;

        // spawn qstat and grep processes to work together
        var qstat = spawn('qstat', ['-j', job_object.c3_job_number]);

        qstat.stdout.setEncoding('utf8');
        qstat.stdout.on('data',function(data){
            if (/job_number/.test(data)){
                is_running = true;
            }
        });
        qstat.on('close',function(code){
            if (code !== 0){
                clearTimeout(poll_timer);
            }
            if (!is_running){
                clearTimeout(poll_timer);
                job_object.status = 'completed';
                callback(null,job_object);
            }

        });
	}, 1000);
}

var tar = function (job_object, callback){
	logentries_log.log("info", {tags: ['ComputeAPIDaemon','Tar'], job_id: job_object,job_id});
    loggly_client.log(job_object, ['ComputeAPIDaemon','Tar']);
    var tar_base = path.basename(job_object.output_folder);
    job_object.tar_path = tar_base + '.tgz';
    var tar = spawn('tar', ['-czf', job_object.tar_path, '-C', __dirname, tar_base]);
    tar.on('close',function(code){
        callback(null,job_object);
    });
}

var s3_upload = function(job_object,callback){
    logentries_log.log("info", {tags: ['ComputeAPIDaemon','S3upload'], job_id: job_object.job_id});
    loggly_client.log(job_object, ['ComputeAPIDaemon','S3Upload']);
    aws_methods.upload_file_to_bucket(job_object.tar_path,'ComputeAPITempFiles',function(err,s3_locations){
        if (err) callback(err);
        job_object.aws_tar_path = s3_locations.url;
        callback(null,job_object);
    });
}
var cleanup = function (job_object,callback){
	deleteFolderRecursive(job_object.output_folder);
    fs.unlinkSync(job_object.tar_path);
    logentries_log.log("info", {tags: ['ComputeAPIDaemon','Cleanup'], job_id: job_object.job_id});
    loggly_client.log(job_object, ['ComputeAPIDaemon','Cleanup']);
}

var update_log = function(job_object,status,callback){
    if (callback === undefined){
        callback = function(){};
    };
    log.update({job_id: job_object.job_id},{status: status},function(err){
        if (err) callback(err);
        console.log('updated job status: ' + job_object.job_id + ':' + status);
        logentries_log.log("info", {tags: ['ComputeAPIDaemon','UpdateStatus'], status:status, job_id: job_object.job_id});
        loggly_client.log(job_object, ['ComputeAPIDaemon','UpdateStatus',status]);
        callback(null,job_object);
    });
}

// taken from www.geedew.com/2012/10/24/remove-a-directory-that-is-not-empty-in-nodejs/
var deleteFolderRecursive = function(path) {
    if( fs.existsSync(path) ) {
        fs.readdirSync(path).forEach(function(file,index){
        var curPath = path + "/" + file;
        if(fs.lstatSync(curPath).isDirectory()) { // recurse
            deleteFolderRecursive(curPath);
        } else { // delete file
            fs.unlinkSync(curPath);
        }
        });
        fs.rmdirSync(path);
    }
};
