var spawn = require('child_process').spawn;
var scp_config = require('./scp_config.json');

var download = function (src,dest,callback){
	console.log(scp_config.server + ':' + src);
	var scp = spawn('scp',['-i',scp_config.rsa_key,scp_config.server + ':' + src,dest]);
	scp.stderr.on('data',function (data){
		callback(new Error('scp error: ' + data.toString()));
	});

	scp.on('close', function (code) {
		callback(null,code);
	});
};

module.exports = {download:download};