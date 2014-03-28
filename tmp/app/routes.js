module.exports = function(app, passport){
    //home page
    app.get('/', function(req, res){
        res.render('index.jade');
    });
            
    //login
    app.get('/login', function(req, res) {
		// render the page and pass in any flash data if it exists
		var message = req.flash('loginMessage');
        if (!message[0]){
            console.log('false');
            res.render('login.jade', {'message': false });
        }else{
            console.log(message);
            res.render('login.jade', {'message': message });
        }
	});
    app.post('/login', passport.authenticate('local-login', {
        successRedirect: '/profile',
        failureRedirect: '/login',
        failureFlash: true
    }));
    
    //signup
    app.get('/signup', function(req, res) {
		// render the page and pass in any flash data if it exists
        var message = req.flash('signupMessage');
        if (!message[0]){
            console.log('false');
            res.render('signup.jade', {'message': false });
        }else{
            console.log(message);
            res.render('signup.jade', {'message': message });
        }
	});
    app.post('/signup', passport.authenticate('local-signup', {
        successRedirect: '/profile',
        failureRedirect: '/signup',
        failureFlash: true
    }));
    
    // facebook routes
    // route for facebook authenitcation and login
    app.get('/auth/facebook', passport.authenticate('facebook', {scope: 'email'}));
    
    // handle the the callback after facebook authenitcates the user
    app.get('/auth/facebook/callback',
            passport.authenticate('facebook', {
                successRedirect: '/profile',
                failureRedirect: '/'
            })
    );
    
    // example of a protected route
	app.get('/profile', isLoggedIn, function(req, res) {
		res.render('profile.jade', {
			user : req.user // get the user out of session and pass to template
		});
	});

    //logout
	app.get('/logout', function(req, res) {
		req.logout();
		res.redirect('/');
	});
    
}

// route middleware to make sure a user is logged in
function isLoggedIn(req, res, next) {

	// if user is authenticated in the session, carry on 
	if (req.isAuthenticated())
		return next();

	// if they aren't redirect them to the home page
	res.redirect('/');
}