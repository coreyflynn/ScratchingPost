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
			'<span class="span1"><img id="'+ this.div_id.split("#")[1] + '_button" style="max-width:50px;max-height:50px;" src="http://coreyflynn.github.com/Bellhop/img/plus_round_small_blue.png"></span>' +
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
															};
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
															};
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

function Query_Info_Table_Object2(options){
	// columns for the query info table
	var columns = [
		{id: "pert_desc", name: "Reagent Name", field: "pert_desc"},
		{id: "pert_type", name: "Reagent Type", field: "pert_type"},
		{id: "cell_id", name: "Cell ID", field: "cell_id"},
		{id: "score", name: "Score", field: "score"}
	];

	// place holders for pert_type and cell_id autocompete_data lists
	this.pert_types = [];
	this.cell_ids = [];
	this.autocomplete_data = [];
	this.grid_filter_columns = ["pert_desc","pert_type","cell_id"];

	var self = this;
	this.typeahead_options = {source: self.autocomplete_data,
                          highlighter: function(item){
                            if (self.pert_types.indexOf(item) != -1){
                              return '<div><span class="label label-important">Pert Type</span>  ' + item  +  '</div>';
                            }
                            if (self.cell_ids.indexOf(item) != -1){
                              return '<div><span class="label label-warning">Cell ID</span>  ' + item  +  '</div>';
                            }
                            return '<div><span class="label">Reagent Name</span>  ' + item  +  '</div>';
                            }
                          };

	list_search_panel = new List_Search_Panel({image:"",
                             placeholder_text:"Search Connections",
                             style:"background-color:#dbdbdb",
                             grid_columns:columns,
                             autocomplete_data:this.autocomplete_data,
                             typeahead_options:this.typeahead_options,
                             grid_filter_columns:this.grid_filter_columns
                           });
	options.panels = [list_search_panel];

	this.collapse_panel = new Collapse_Panel(options);

	this.add_data_from_queries = add_data_from_queries;
	this.hide = hide;
	this.show = show;
	this.expand = expand;
	this.collapse = collapse;

	function hide(){
		this.collapse_panel.hide();
	}

	function show(){
		this.collapse_panel.show();
	}

	function expand(){
		this.collapse_panel.expand();
	}

	function collapse(){
		this.collapse_panel.collapse();
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

		this.autocomplete_data = [];
		this.cell_ids = [];
		this.pert_types = [];
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
															};
						self.autocomplete_data.push(element.pert_desc);
						self.cell_ids.push(element.cell_id);
						self.pert_types.push(element.pert_type);
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
															};
					self.autocomplete_data.push(element.pert_desc);
					self.cell_ids.push(element.cell_id);
					self.pert_types.push(element.pert_type);
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
				self.collapse_panel.panels[0].grid_data = query_result_list;
				self.collapse_panel.panels[0].grid.setData(query_result_list);
				self.collapse_panel.panels[0].grid.render();
				self.show();

				// update the autocomplete_data
				self.cell_ids = _.uniq(self.cell_ids);
				self.pert_types = _.uniq(self.pert_types);
				self.autocomplete_data = _.uniq(self.autocomplete_data);
				self.autocomplete_data = self.autocomplete_data.concat(self.cell_ids).concat(self.pert_types);
				var typeahead = $("#" + self.collapse_panel.panels[0].div_id + "_search").typeahead();
				typeahead.data('typeahead').source = self.autocomplete_data;

			});
		});
	}

}