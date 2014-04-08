var nodemailer = require('nodemailer');

function email_middleware(err,req,res,next){
    if (err){
        // create reusable transport method (opens pool of SMTP connections)
        var smtpTransport = nodemailer.createTransport("SMTP",{
            service: "Gmail",
            auth: {
                user: "flynn.corey@gmail.com",
                pass: ""
            }
        });

        // configure the mail options object
        var opts = {
            to: 'flynn.corey@gmail.com',
            from: 'flynn.corey@gmail.com',
            subject: 'TOOL RUNNER API ERROR: ' + err.constructor.name,
            text: err.stack,
            html: err.stack
        }

        // send mail with defined transport object
        smtpTransport.sendMail(opts, function(error, response){
            if(error){
                console.log(error);
            }else{
                console.log("Message sent: " + response.message);
            }

            // if you don't want to use this transport object anymore, uncomment following line
            smtpTransport.close(); // shut down the connection pool, no more messages
        });
    }
    next(err);
}

module.exports = {email_notifier: email_middleware};