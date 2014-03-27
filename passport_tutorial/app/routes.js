module.exports = function(app, passport){
    //home page
    app.get('/', function(req, res){
        res.render('index.jade');
    });
            
    //login
    app.get('/login', function(req, res) {
		// render the page and pass in any flash data if it exists
		res.render('login.jade', { message: req.flash('loginMessage') }); 
	});
    
    //signup
    app.get('/signup', function(req, res) {
		// render the page and pass in any flash data if it exists
		res.render('signup.jade', { message: req.flash('signupMessage') }); 
	});
    
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