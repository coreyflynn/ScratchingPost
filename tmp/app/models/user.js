var mongoose = require('mongoose');
var bcrypt = require('bcrypt-nodejs');

//define the schema for our user model
var userSchema = mongoose.Schema({
    local:{
        email: String,
        password: String
    },
    facebook:{
        id: String,
        token: String,
        email: String,
        name: String
    },
    twitter:{
        id: String,
        token: String,
        displayName: String,
        username: String
    },
    google:{
        id: String,
        token: String,
        email: String,
        name: String
    }
});

//utility method to generate password hash
userSchema.methods.generateHash = function(password) {
    return bcrypt.hashSync(password, bcrypt.genSaltSync(8),null);
};

//utility method to check if password is valid
userSchema.methods.validPassword = function(password) {
    return bcrypt.compareSync(password, this.local.password);
}

//create the user model and expose it
module.exports = mongoose.model('User', userSchema);