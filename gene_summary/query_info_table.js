function Query_Info_Table_Object(div_id,title,show_height){
	this.div_id = div_id;
	this.show_height = show_height;
	this.show = show;
	this.hide = hide;
	this.collapse = collapse;
	this.expand = expand;
	this.buttonCallback = buttonCallback;
	this.open = true;
	this.clear_data = clear_data;
	this.add_data_from_queries = add_data_from_queries;

	header_html = '<div class="row-fluid" id="' + this.div_id.split("#")[1] + '_head" class="span12" style="background-color:#f0f0f0">' +
			'<h1 class="span11">' + title + '</h1>' +
			'<span class="span1"><img id="'+ this.div_id.split("#")[1] + '_button" style="max-width:50px;max-height:50px;" src="http://coreyflynn.github.com/Bellhop/img/plus_round_small.png"></span>' +
			'</div>';

	$(this.div_id).append(header_html);
	var self = this;
	$(this.div_id + '_button').click(function (evt) { self.buttonCallback(evt); });
	$(this.div_id).append('<div class="row-fluid" id="' +
						this.div_id.split("#")[1] +
						'_QIT" style="height:' +
						(this.show_height - $(this.div_id + "_head").outerHeight(true)) +
						'px"></div>');

	this.columns = [
	{id: "pert_desc", name: "Gene Symbol", field: "pert_desc"},
	{id: "cell_id", name: "Cell ID", field: "cell_id"},
	{id: "pert_type", name: "Pert Type", field: "pert_type"},
	{id: "score", name: "Score", field: "score"}
	];

	this.options = {
	enableCellNavigation: true,
	enableColumnReorder: false,
	fullWidthRows: true,
	forceFitColumns: true
	};

	this.data = [];

	this.grid = new Slick.Grid(this.div_id + "_QIT", this.data, this.columns, this.options);
	this.expand();

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
		$(this.div_id).animate({height:$(this.div_id + "_head").outerHeight(true)},duration);
		$(this.div_id + "_QIT").fadeOut(duration);
		$(this.div_id + "_button").rotate({animateTo:0,duration:duration});
	}

	function expand(){
		var duration = 300;
		$(this.div_id + "_QIT").fadeIn(duration);
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

	function add_data_from_queries(){
	    // integrate results from a number of queries and consolidate them into one 
	    // list.  Queries should be passed as a set of sig_ids
	    // 
	    // DUMMY DATA FOR NOW
	    
	    
	    // for each sig_id in the query list, grab the query data and integrate it
	    // over the pert_desc, pert_type, and cell_id
	    // 
	    // for now this is a DUMMY CALL to siginfo just to get data to work on
	    var siginfo = 'http://lincscloud.org/api/siginfo?callback=?';
	    var query_result_object = {};
	    var self = this;
	    $.getJSON(siginfo,{q:'{"pert_type":"trt_sh"}',
	    f:'{"pert_desc":1,"cell_id":1,"pert_type":1}',
	    l:1000},
	    function(kd_response){
	    	$.getJSON(siginfo,{q:'{"pert_type":"trt_oe"}',
	        f:'{"pert_desc":1,"cell_id":1,"pert_type":1}',
	        l:1000},
	        function(oe_response){
				// handle the kd response
				kd_response.forEach(function(element,index,array){
					unique_key = element.pert_desc + element.cell_id + element.pert_type;
					if (!query_result_object.hasOwnProperty(unique_key)){
						query_result_object[unique_key] = {pert_desc: element.pert_desc,
														 cell_id: element.cell_id,
														 pert_type: element.pert_type,
														 score: Math.random() * 2 -1,
														 num_sigs: 1
														}
					} else {
						score = query_result_object[unique_key].score;
						num_sigs = query_result_object[unique_key].num_sigs;
						query_result_object[unique_key].score = score + (Math.random() * 2 -1 - score) / num_sigs;
					}
				});

				// handle the oe response
				oe_response.forEach(function(element,index,array){
					unique_key = element.pert_desc + element.cell_id + element.pert_type;
					if (!query_result_object.hasOwnProperty(unique_key)){
						query_result_object[unique_key] = {pert_desc: element.pert_desc,
														 cell_id: element.cell_id,
														 pert_type: element.pert_type,
														 score: Math.random() * 2 -1,
														 num_sigs: 1
														}
					} else {
						score = query_result_object[unique_key].score;
						num_sigs = query_result_object[unique_key].num_sigs;
						query_result_object[unique_key].score = score + (Math.random() * 2 -1 - score) / num_sigs;
					}
				});

				// convert the query_result_object to an array and sort it by score
				query_result_list = _.toArray(query_result_object);
				query_result_list.sort(function(a, b){
					return b.score-a.score;
				});

				//replace the data in the table
				self.grid.setData(query_result_list);
				self.grid.render();
				self.show();

	        });
	    });
	}
}