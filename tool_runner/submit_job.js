var Connection = require('ssh2'),
fs = require('fs'),
path = require('path'),
q_runner = require('./q_runner'),
scp_methods = require('./scp_methods'),
aws_methods = require('./aws_methods');


// grab command line arguments
var args = process.argv.slice(2,process.argv.length);

// configure a new connection object and tell it what to do when the
// connection is ready, when we see an error, when the connection ends,
// and when it closes
var c = new Connection();

// when the connection is ready, execute a tool function and poll for its
// completion
c.on("ready", function (){
	console.log("Connection :: Ready");
	
	// run the job
	q_runner.submit(c,args.join(' '), function (err,job){
		if (err) throw err;
		console.log(job);
		
		// poll for the completed job
		q_runner.poll(c,job, function (err, job){
			if (err) throw err;
			console.log(job);

			// tar the result directory
			q_runner.tar(c,job, function (err,job){
				if (err) throw err;
				console.log(job);
				
				// download the tar file
				scp_methods.download(job.tar_path,path.basename(job.tar_path),function (err){
					if (err) throw err;
					console.log('downloaded ' + path.basename(job.tar_path));
					
					// cleanup the temp files that the tool makes
					q_runner.cleanup(c,job, function (err,job){
						if (err) throw err;
						console.log(job);

						// close the connection
						c.end();
					});

					// upload the file to AWS and delete the temp file
					aws_methods.upload_file_to_bucket(path.basename(job.tar_path),'sig_tool_output', function (err){
						if (err) throw err;
						fs.unlinkSync(path.basename(job.tar_path));
					});
				});
			});
		});
	});
});

// when the connection errors out, log the error message
c.on('error', function (err){
	console.log('Connection :: Error :: ' + error);
});

// when the connection ends, log a message telling us that
c.on("end", function (){
	console.log('Connection :: End');
});

// when the connection closes, log a message telling us that
c.on("close", function (){
	console.log('Connection :: Close');
});

// connect to the remote server
c.connect({
	host: 'c3.lincscloud.org',
	port: 22,
	username: 'cflynn',
	privateKey: fs.readFileSync('/Users/cflynn/.ssh/cflynn.rsa')
})

