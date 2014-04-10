var logentries = require('node-logentries');
var log = logentries.logger({
  token:'f0d5ca99-119e-44f6-8544-c56b085d6675'
});

module.exports = {log: log};