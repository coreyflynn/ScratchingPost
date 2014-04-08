var loggly = require('loggly');

var client = loggly.createClient({
    token: "2c798b45-f07a-4a72-8a64-a84af0e1d4a2",
    subdomain: "coreyflynn",
    auth: {
        username: "coreyflynn",
        password: "Cf973800"
    },
    json: true,
    //
    // Optional: Tag to send with EVERY log message
    //
//    tags: ['ComputeAPIDaemon']
});

module.exports = {client: client};