var fs = require("fs"),
path = require('path'),
AWS = require('aws-sdk'),
loggly_client = require('../config/loggly').client;

// configure AWS 
AWS.config.loadFromPath('./config/aws_config.json');

// upload the specified file to the specified AWS bucket
var upload_file_to_bucket = function (file_path,bucket_name,callback){
	// load AWS configuration and create a new S3 object to work with

	var s3 = new AWS.S3();

	// attempt to read the given file_path and upload it. Report back the error
	// if one occurs
	fs.readFile(file_path, function (err,data){
		if (err) {
			return callback(err);
		}
		// grab the base name of the file for later use
		console.log(file_path);
		var file_base = path.basename(file_path);

		// create a new buffer from the file_path given
		var file_buffer = new Buffer(data,'binary');

		// set up the parameters for the object to be placed on amazon.
		// we're going to pass the buffer from above to AWS and make the file
		// public read only
		var params = {
			Bucket: bucket_name,
			ACL: 'public-read',
			Key: file_base,
			Body: file_buffer
		};

		// upload the object to AWS and return the file_url to the callback
		// on success
		s3.putObject(params, function (err,data){
			if (err) {
				callback(err);
			}
			console.log('successully uploaded to ' + bucket_name + '/' + file_base);
			var url = 'https://s3.amazonaws.com/' + bucket_name + '/' + file_base;
            var s3_locations = {url: url, key: file_base}
            console.log('file url: ' + s3_locations.url);
            loggly_client.log(s3_locations,['ComputeAPISubmission','S3_upload']);
			callback(null,s3_locations);
		});
	});
}

//download the specified bucket/key to the specified file locally
var download_file_from_bucket = function(bucket,key,file_path, callback){
    var s3 = new AWS.S3();
    var params = {Bucket: bucket, Key: key};
    var file = fs.createWriteStream(file_path);
    s3.getObject(params).createReadStream().pipe(file);
    callback(null,file_path);
};

module.exports = {upload_file_to_bucket: upload_file_to_bucket,
                  download_file_from_bucket: download_file_from_bucket
                 };
