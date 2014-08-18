var fs = require('fs'),
    execSync = require('execSync');
exports.index = function(req, res){
  res.render('index');
};

exports.slice = function(req, res){
    var col_inds = req.query.col_inds;
    var row_inds = req.query.row_inds;
    if (row_inds){
        execSync.run('. ~/virtualenv/cjf/bin/activate;export PYTHONPATH=/Users/cflynn/Code/pestle/;cd ' + __dirname + ';python ../bin/summly_slice.py ' + col_inds + ' ' + row_inds + ' ../data/meanrankpt4.gctx')    
    }else{
        execSync.run('. ~/virtualenv/cjf/bin/activate;export PYTHONPATH=/Users/cflynn/Code/pestle/;cd ' + __dirname + ';python ../bin/summly_slice.py ' + col_inds + ' all ../data/meanrankpt4.gctx')
    }

    fs.readFile(__dirname + '/slice.json',function(err,data){
        if (err) throw err;
        res.json(JSON.parse(data));
    })
};
