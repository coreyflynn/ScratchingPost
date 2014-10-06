module.exports = function(req, res){
    var page = req.params.page;
    if (!req.query.module){
        res.render('orientation/index');
    }else{
        res.render('orientation/' + req.query.module);
    }
};
