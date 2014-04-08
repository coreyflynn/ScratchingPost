var loggly = require('loggly');

var client = loggly.createClient({
    token: "2c798b45-f07a-4a72-8a64-a84af0e1d4a2",
    subdomain: "coreyflynn",
    auth: {
        username: "coreyflynn",
        password: "cancer4175"
    },
    json: true,
});

module.exports = {client: client};