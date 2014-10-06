module.exports = function(req, res){
  res.render('share',{title: 'CPW ' + req.params.app});
};
