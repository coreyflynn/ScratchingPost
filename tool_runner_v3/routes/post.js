var fs = require('fs');
var path = require('path');
var async = require('async');
var mongoose = require('mongoose');
var tool_collections = require('../models/tool_collections');
var mongo_config = require('../config/mongo');
var save_tmp_file = require('../util/save_tmp_file');

//configure mongoose
mongoose.connect(mongo_config.url);

// default post handling
exports.default = function(req, res) {
    // grab the parameters passed in the POST request out of the
    // request body
    var params = req.body;
    
    // grab the files that are attached to the POST request and
    // make an array out of the individual file objects.  For each
    // file that comes through, save it to disk and extend the params
    // object to include a file path to that file
    var files_object  = req.files;
    var files_array = [];
    var file_keys = Object.keys(files_object);
    async.map(file_keys,function(key,callback){
        callback(null,files_object[key]);
    },function(err,result){
        if (err) throw err;
        async.map(result,save_tmp_file,function(err,result){
            if (err) throw err;
            async.each(result,function(res,callback){
                var res_key = Object.keys(res)[0]
                params[res_key] = res[res_key];
                callback(null);
            },function(err){
                if (err) throw err;
                // once everything is complete, store a new job in The
                // job queue and the job log as well as return a 
                // response to the client
                new_queue_item = new tool_collections.queue();
                new_queue_item.status = 'pending';
                new_queue_item.job_id = 'job' + new Date().getTime();
                new_queue_item.save(function(err){
                    if (err) throw err;
                    new_log_item = new tool_collections.log(params);
                    new_log_item.status = 'pending';
                    new_log_item.job_id = new_queue_item.job_id
                    new_log_item.save(function(err){
                        if (err) throw err;
                        params.status = 'pending';
                        params.job_id = new_log_item.job_id;
                        res.jsonp(params);
                    });
                });
            });
        });
    });
}