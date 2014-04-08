var fs = require('fs');
var aws_methods = require('./aws_methods');
loggly_client = require('../config/loggly').client;

// utility function to save the input file object to a local temp file
// in file_uploads as well as load save the file out to AWS in a bucket
// named ComputeAPITempFiles
var save_tmp_file = function(file_object,callback) {
    fs.readFile(file_object.path, function(err,data) {
        if (err) callback(err);
        var newPath = 'file_uploads/' + new Date().getTime() + file_object.name;
        fs.writeFile(newPath, data, function(err, data) {
            if (err) callback(err);
            aws_methods.upload_file_to_bucket(newPath, 'ComputeAPITempFiles', function(err, s3_locations){
                if (err) callback(err);
                var locations = {}
                var obj = {};
                locations['aws_url'] = s3_locations.url;
                locations['aws_key'] = s3_locations.key;
                locations['local'] = newPath;
                obj[file_object.fieldName] = locations;
                loggly_client.log(obj,['ComputeAPISubmission','save_tmp_file']);
                callback(null,obj);
            });
        });
    });
}

module.exports = save_tmp_file;