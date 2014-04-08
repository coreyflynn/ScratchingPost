var fs = require('fs');

// utility function to save the input file object to a local temp file
// in file_uploads
var save_tmp_file = function(file_object,callback) {
    fs.readFile(file_object.path, function(err,data) {
        if (err) throw callback(err);
        var newPath = 'file_uploads/' + new Date().getTime() + file_object.name;
        fs.writeFile(newPath, data, function(err, data) {
            if (err) throw callback(err);
            var obj = {}
            obj[file_object.fieldName] = newPath
            callback(null,obj);
        });
    });
}

module.exports = save_tmp_file;