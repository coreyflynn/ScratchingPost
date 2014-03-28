// load strategies
var LocalStategy = require('passport-local').Strategy;
var FacebookStrategy = require('passport-facebook').Strategy;

// load the user model
var User = require('../app/models/user');

// load the local auth variable
var configAuth = require('./auth');

module.exports = function(passport) {
    // passport session setup
    // in order to use persistent login sessions, we need to serialize and deserialize users out of the session
    passport.serializeUser(function(user, callback){
        callback(null, user.id);
    });
    passport.deserializeUser(function(id, callback){
        User.findById(id, function(err, user){
            callback(err, user);
        });
    });
    
    // LOCAL SIGNUP
    passport.use('local-signup', new LocalStategy({
        usernameField: 'email',
        passwordField: 'password',
        passReqToCallback: true // allows us to pass back the entire request to the callback
        },
        function(req, email, password, callback){
            process.nextTick(function(){
                User.findOne({'local.email': email}, function(err, user){
                    if (err){
                        return callback(err);
                    }
                    
                    // check to see if there is already a user with that email
                    if (user){
                        return callback(null, false, req.flash('signupMessage', 'That email is already taken'));
                    }else{
                        // create the user in the database
                        var newUser = new User();
                        
                        // set the user's credentials
                        newUser.local.email = email;
                        newUser.local.password = newUser.generateHash(password);
                        
                        // save the user
                        newUser.save(function(err){
                            if (err){
                                throw err;
                            }
                            return callback(null, newUser);
                        });
                    }
                });
            });
        }
        )
    );
    
    // LOCAL LOGIN
    passport.use('local-login', new LocalStategy({
            usernameField: 'email',
            passwordField: 'password',
            passReqToCallback: true // allows us to pass back the entire request to the callback
        },
        function(req, email, password, callback) {
            // find a user whose email is the same as that given in the form
            User.findOne({'local.email': email},function(err, user){
                if (err){
                    return callback(err);
                }
                
                //  if we don't find a user, flash a message
                if (!user){
                    return callback(null, false, req.flash('loginMessage', "We don't have a User with that email. Please signup"));
                }
                
                // if the user is found but the password is not right
                if (!user.validPassword(password)){
                    return callback(null, false, req.flash('loginMessage', "Wrong Password"));
                }
                
                // otherwise, return the successful user
                return callback(null,user);
            });
        }
        )
    );
    
    // FACBOOK
    passport.use(new FacebookStrategy({
            // pull in id and secret from the auth file
            clientID: configAuth.facebookAuth.clientID,
            clientSecret: configAuth.facebookAuth.clientSecret,
            callbackURL: configAuth.facebookAuth.callbackURL
        },
        function(token, refreshToken, profile, callback){
            process.nextTick(function(){
                User.findOne({'facbook.id': profile.id}, function (err, user){
                    if (err){
                        return callback(err);
                    }
                    // if we find the user, log them in
                    if (user) {
                        return callback(null, user);
                    }else{
                        // if there is no user with that facebook id, create them
                        var newUser = new User();
                        newUser.facebook.id = profile.id;
                        newUser.facebook.token = token;
                        newUser.facebook.name = profile.name.givenName + ' ' + profile.name.familyName;
                        newUser.facebook.email = profile.emails[0].value;
                        
                        // save our user to the database
                        newUser.save(function(err){
                            if (err){
                                throw err;
                            }
                            return callback(null, newUser);
                        });
                    }
                });
            });
        }                           
        )
    );
};