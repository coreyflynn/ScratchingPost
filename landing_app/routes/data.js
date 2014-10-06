module.exports = function(req, res){
  res.render('data',{title: 'CPW ' + req.params.app});
};
