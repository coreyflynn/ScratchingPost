var fs = require("fs"),
path = require('path'),
AWS = require('aws-sdk');

// upload the specified file to the specified AWS bucket
var upload_file_to_bucket = function (file_path,bucket_name,callback){
	// load AWS configuration and create a new S3 object to work with
	AWS.config.loadFromPath('./aws_config.json');
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
			console.log('file url: https://s3.amazonaws.com/' + bucket_name + '/' + file_base);
			callback(null,'https://s3.amazonaws.com/' + bucket_name + '/' + file_base);
		});
	});
}

module.exports = {upload_file_to_bucket: upload_file_to_bucket};