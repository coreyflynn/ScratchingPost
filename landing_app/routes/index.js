var fs = require('fs');
var path = require('path');

// collect all of the routes and put them all on a single object
var files = fs.readdirSync(__dirname);
files.forEach(function(file){
    if (file !== 'index.js'){
        exports[path.basename(file,'.js')] = require('./' + file);
    }
});
