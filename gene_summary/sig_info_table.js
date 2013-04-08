function Sig_Info_Table_Object(div_id,title,show_height){
  this.div_id = div_id;
  this.show_height = show_height;
  this.show = show;
  this.hide = hide;
  this.collapse = collapse;
  this.expand = expand;
  this.buttonCallback = buttonCallback;
  this.add_data = add_data;
  this.clear_data = clear_data;
  this.open = true;
  this.add_data_from_symbol = add_data_from_symbol;
  this.add_data_from_sig_id = add_data_from_sig_id;

  header_html = '<div class="row-fluid" id="' + this.div_id.split("#")[1] + '_head" class="span12" style="background-color:#f0f0f0">' +
      '<span class="span1"><img style="max-width:60px;max-height:60px;" src="http://coreyflynn.github.com/Bellhop/img/signature.png"></span>' +
      '<h3 class="span10">' + title + '</h3>' +
      '<span class="span1"><img id="'+ this.div_id.split("#")[1] + '_button" style="max-width:60px;max-height:60px;" src="http://coreyflynn.github.com/Bellhop/img/plus_round_small_blue.png"></span>' +
      '</div>';

  $(this.div_id).append(header_html);
  var self = this;
  $(this.div_id + '_button').click(function (evt) { self.buttonCallback(evt); });
  $(this.div_id).append('<div id="' +
              this.div_id.split("#")[1] +
              '_SIT" style="height:' +
              (this.show_height - $(this.div_id + "_head").outerHeight(true)) +
              'px"></div>');

  this.columns = [
    {id: "sig_id", name: "Sig ID", field: "sig_id"},
    {id: "cell_id", name: "Cell ID", field: "cell_id"},
    {id: "pert_type", name: "Pert Type", field: "pert_type"}
  ];

  this.options = {
    enableCellNavigation: true,
    enableColumnReorder: false,
    fullWidthRows: true,
    forceFitColumns: true
  };

  this.data = [];

  this.grid = new Slick.Grid(this.div_id + "_SIT", this.data, this.columns, this.options);
  this.expand();

  function add_data_from_symbol(symbol){
    var siginfo = 'http://lincscloud.org/api/siginfo?callback=?';
    var sig_id_list = [];
    var self = this;
    $.getJSON(siginfo,{q:'{"pert_desc":"' + symbol + '"}',
                f:'{"sig_id":1,"cell_id":1,"pert_type":1}',
                l:1000},
                function(response){
                  self.grid.setData(response);
                  self.grid.render();
                  self.show();
                });

  }

  function add_data_from_sig_id(sig_id_list){
    var self = this;
    var siginfo = 'http://lincscloud.org/api/siginfo?callback=?';
    sig_id_list.forEach(function(element,index,array){
      $.getJSON(siginfo,{q:'{"sig_id":"' + element + '"}',
                f:'{"sig_id":1,"cell_id":1,"pert_type":1}'},
                function(response){
                  self.add_data(response[0]);
                });
    });
  }

  function add_data(d){
    var data = this.grid.getData();
    data.push(d);
    this.grid.setData(data);
    this.grid.render();
  }

  function clear_data(){
    this.grid.setData([]);
    this.grid.render();
  }

  function hide(){
    $(this.div_id).hide();
  }

  function show(){
    $(this.div_id).show();
  }

  function collapse(){
    var duration = 300;
    $(this.div_id + "_SIT").fadeOut(duration);
    $(this.div_id).animate({height:$(this.div_id + "_head").outerHeight(true)},duration);
    $(this.div_id + "_button").rotate({animateTo:0,duration:duration});
  }

  function expand(){
    var duration = 300;
    $(this.div_id + "_SIT").fadeIn(duration);
    $(this.div_id).animate({height:this.show_height},duration);
    $(this.div_id + "_button").rotate({animateTo:45,duration:duration});
  }

  function buttonCallback(evt){
    if (this.open){
      this.collapse();
      this.open = false;
    }else{
      this.expand();
      this.open = true;
    }
  }
}