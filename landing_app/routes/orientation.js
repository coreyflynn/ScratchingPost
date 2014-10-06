module.exports = function(req, res){
    var page = req.params.page;
    if (!req.query.module){
        res.render('orientation/index',{title:'CLUE Orientation'});
    }else{
        res.render('orientation/' + req.query.module, {title: 'CLUE ' + req.query.module.slice(3,req.query.module.length)});
    }
};
