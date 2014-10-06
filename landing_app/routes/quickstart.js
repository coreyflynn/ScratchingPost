module.exports = function(req, res){
  res.render('quickstart',{title: 'CPW ' + req.params.app});
};
