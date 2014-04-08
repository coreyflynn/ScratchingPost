var path = require('path');

// given a ssh2 connection and a command to run, submit it using 
// a system call to 'q' after seting up the environment in the cluster.
var submit = function (ssh2_connection, command, callback){
	var tmp_folder = 'sig_tool_result' + new Date().getTime();
	ssh2_connection.exec('source /etc/profile; mkdir -p $HOME/public_html/' + tmp_folder + '; q '  + command + ' --out ' + tmp_folder + ' --mkdir 0 ', function (err, stream){
		// if we error out, bubble the error through the callback
		if (err) callback(err);

		// grab the second line of the output from the stream as it provides
		// the job number that the cluster is going to use for the submitted
		// process
		var job_object = {};
		var chunk_number = 0;
		stream.on('data', function (chunk){
			chunk_number ++;
			if (chunk_number === 2){
				job_object.job_number = chunk.toString().split(' ')[2];
				job_object.status = 'submitted';
				job_object.output_folder = '$HOME/public_html/' + tmp_folder;

			}
		});

		// if the stream ends normally, call the callback and provide
		// the job number to the callback
		stream.on('end', function (){
			callback(null, job_object);
		});
	})
};

// check for the execution of the job by leveraging qstat and grep.  If there is a
// job number in the qstat response, then it is still running. If it is empty, the
// tool has finished
var poll = function (ssh2_connection, job_object, callback){
	// tell the user that we are polling
	console.log('polling for job number ' + job_object.job_number);

	var poll_timer = setInterval(function (){
		ssh2_connection.exec('source /etc/profile; qstat -j '+ job_object.job_number + ' | grep job_number', function (err,stream){
			// if we error out, bubble the error through the callback
			if (err) callback(err);

			// if we receive data back, set a flag
			var is_running = false;
			stream.on('data', function (chunk){
				// console.log(chunk.toString());
				if (chunk.toString().indexOf('job_number:') === -1){
					is_running = false
				}else{
					is_running = true;
				}
			});

			// if the stream ends normally, check the is_running flag.  If the job is
			// still running, leave poll_timer alone and do not call the callback. If
			// it is not running, clear the timer and call the callback with the job_object
			stream.on('end', function (){
				if (!is_running){
					clearTimeout(poll_timer);
					job_object.status = 'completed';
					callback(null,job_object);
				}
			});
		});
	}, 1000);
};

// given a ssh connection and a job object, tar the path given
// by job_object.output_folder and add a tar_path property to 
// the job object
var tar = function (ssh2_connection,job_object, callback){
	var tar_path = path.basename(job_object.output_folder) + '.tgz';
	var tar_command = 'tar -czf ' + tar_path + ' -C $HOME/public_html ' + path.basename(job_object.output_folder);
	console.log(tar_command);
	ssh2_connection.exec(tar_command, function (err,stream){
		// if we error out, bubble the error through the callback
		if (err) callback(err);

		// if the stream ends normally, return the job object with the tar_path
		// attribute added
		stream.on('end', function (){
			job_object.tar_path = tar_path;
			job_object.status = 'compressed';
			callback(null,job_object);
		});
	});
};

// given a ssh connection, clean up the output_folder folder for the
// given job object
var cleanup = function (ssh2_connection,job_object,callback){
	ssh2_connection.exec('rm -r ' + job_object.output_folder + '; rm ' + job_object.tar_path, function (err,stream){
		// if we error out, bubble the error through the callback
		if (err) callback(err);

		// if the stream ends normally, return the job object with the tar_path
		// attribute added
		stream.on('end', function (){
			job_object.status = 'cleared';
			callback(null,job_object);
		});
	});
};

module.exports = {submit:submit, poll: poll, tar: tar, cleanup:cleanup};