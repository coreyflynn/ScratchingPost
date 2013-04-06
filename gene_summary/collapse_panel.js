function Collapse_Panel(options){
	options = (options !== undefined) ? options : {};
	this.image = (options.image !== undefined) ? options.image : "http://coreyflynn.github.com/Bellhop/img/plus_round_small.png";
	this.image_max = (options.image_max !== undefined) ? options.image_max : 60;
	this.div_target = (options.div_target !== undefined) ? options.div_target : "body";
	this.div_id = (options.div_id !== undefined) ? options.div_id : "CPanel" + Math.floor(Math.random()*1000000000);
	this.text = (options.text !== undefined) ? options.text : "Title";
	this.style = (options.style !== undefined) ? options.style : "background-color:#f0f0f0";
	this.html = ['<div class="row-fluid" id="' + this.div_id + '" class="span12" style=' + this.style + '>',
				'<div class="row-fluid">',
				'<span class="span1"><img style="max-width:' + this.image_max + 'px;max-height:' + this.image_max + 'px;" src="' + this.image + '"/></span>',
				'<h3 class="span10">' + this.text + '</h3>',
				'<span class="span1"><img id="' + this.div_id + '_button" style="max-width:60px;max-height:60px;" src="http://coreyflynn.github.com/Bellhop/img/plus_round_small_blue.png"/></span>',
				'</div>',
				'</div>'
				].join('\n');
	this.panels = (options.panels !== undefined) ? options.panels : [];

	var self = this;
	$(this.div_target).append(this.html);

	$("#" + this.div_id + "_button").click(function (evt) { self.buttonCallback(evt); });

	this.close_height = $("#" + this.div_id).outerHeight();
	this.open_height = $("#" + this.div_id).outerHeight();

	this.panels.forEach(function(panel){
		panel.add_to_div(self.div_id);
		$("#" + panel.div_id).addClass(self.div_id + "_sub_panel");
		self.open_height = self.open_height + $("#" + panel.div_id).outerHeight();
	});

	this.init_Panel = init_Panel;
	this.add_Panel = add_Panel;
	this.buttonCallback = buttonCallback;
	this.collapse = collapse;
	this.expand = expand;

	this.open = false;
	this.collapse(0);

	function init_Panel(panel){
		var self = this;
		this.panels.push(panel);
		panel.add_to_div(self.div_id);
		$("#" + panel.div_id).addClass(self.div_id + "_sub_panel");
		self.open_height = self.open_height + $("#" + panel.div_id).outerHeight();
	}

	function add_Panel(panel){
		var duration = 300;
		var self = this;
		this.panels.push(panel);
		this.collapse();
		setTimeout(function(){
			panel.add_to_div(self.div_id);
			$("#" + panel.div_id).addClass(self.div_id + "_sub_panel");
			self.open_height = self.open_height + $("#" + panel.div_id).outerHeight();
			self.expand();
		},duration);
	}

	function buttonCallback(evt){
		if (this.open){
			this.collapse(300);
			this.open = false;
		}else{
			this.expand(300);
			this.open = true;
		}
	}

	function collapse(duration){
		$("." + this.div_id + "_sub_panel").fadeOut(duration);
		$("#" + this.div_id).animate({height:this.close_height},duration);
		$("#" + this.div_id + "_button").rotate({animateTo:0,duration:duration});
	}

	function expand(duration){
		$('.' + this.div_id + "_sub_panel").fadeIn(duration);
		$("#" + this.div_id).animate({height:this.open_height},duration);
		$("#" + this.div_id + "_button").rotate({animateTo:45,duration:duration});
	}

}

function Panel(options){
	options = (options !== undefined) ? options : {};
	this.image = (options.image !== undefined) ? options.image : "";
	this.image_max = (options.image_max !== undefined) ? options.image_max : 60;
	this.text = (options.text !== undefined) ? options.text : "Title";
	this.div_id = (options.div_id !== undefined) ? options.div_id : "Panel" + Math.floor(Math.random()*1000000000);
	this.style = (options.style !== undefined) ? options.style : "background-color:#f0f0f0";
	this.html = ['<div class="row-fluid" id="' + this.div_id + '" class="span12" style=' + this.style + '>',
				'<span class="span1"><img style="max-width:' + this.image_max + 'px;max-height:' + this.image_max + 'px;" src="' + this.image + '"/></span>',
				'<p class="lead offset1 span10">' + this.text + '</p>',
				'</div>'
				].join('\n');

	this.add_to_div = add_to_div;

	function add_to_div(div_target){
		$("#" + div_target).append(this.html);
	}
}

function Split_Text_Panel(options){
	options = (options !== undefined) ? options : {};
	this.image = (options.image !== undefined) ? options.image : "";
	this.image_max = (options.image_max !== undefined) ? options.image_max : 60;
	this.text1 = (options.text1 !== undefined) ? options.text1 : "Title";
	this.text2 = (options.text2 !== undefined) ? options.text2 : "text";
	this.div_id = (options.div_id !== undefined) ? options.div_id : "Split_Text_Panel" + Math.floor(Math.random()*1000000000);
	this.style = (options.style !== undefined) ? options.style : "background-color:#f0f0f0";
	this.html = ['<div class="row-fluid" id="' + this.div_id + '" class="span12" style=' + this.style + '>',
				'<span class="span1"><img style="max-width:' + this.image_max + 'px;max-height:' + this.image_max + 'px;" src="' + this.image + '"/></span>',
				'<p class="lead offset1 span1"><b>' + this.text1 + '</b></p>',
				'<p class="lead span9">' + this.text2 + '</p>',
				'</div>'
				].join('\n');

	this.add_to_div = add_to_div;

	function add_to_div(div_target){
		$("#" + div_target).append(this.html);
	}
}

function List_Search_Panel(options){
	options = (options !== undefined) ? options : {};
	this.image = (options.image !== undefined) ? options.image : "";
	this.image_max = (options.image_max !== undefined) ? options.image_max : 60;
	this.text = (options.text !== undefined) ? options.text : "Title";
	this.div_id = (options.div_id !== undefined) ? options.div_id : "List_Search_Panel" + Math.floor(Math.random()*1000000000);
	this.style = (options.style !== undefined) ? options.style : "background-color:#f0f0f0";
	this.grid_height = (options.grid_height !== undefined) ? options.grid_height : 300;
	this.placeholder_text = (options.placeholder_text !== undefined) ? options.placeholder_text : "Search";
	this.html = ['<div class="row-fluid" id="' + this.div_id + '" class="span12" style=' + this.style + '>',
				'<span class="span1"><img style="max-width:' + this.image_max + 'px;max-height:' + this.image_max + 'px;" src="' + this.image + '"/></span>',
				'<input class="span10" type="text" placeholder="' + this.placeholder_text + '" data-provide="typeahead" id="' + this.div_id + '_search">',
				'<div id="' + this.div_id + '_grid" style="height:' + this.grid_height + 'px">',
				'</div>'
				].join('\n');

	this.add_to_div = add_to_div;

	function add_to_div(div_target){
		$("#" + div_target).append(this.html);

		this.grid_columns = [
			{id: "pert_iname", name: "Reagent Name", field: "pert_iname"},
			{id: "pert_type", name: "Reagent Type", field: "pert_type"},
			{id: "cell_id", name: "Cell ID", field: "cell_id"},
			{id: "num_inst", name: "Experiments", field: "num_inst"}
		];

		this.grid_options = {
			enableCellNavigation: true,
			enableColumnReorder: false,
			fullWidthRows: true,
			forceFitColumns: true
		};

		// build dummy data for the table
		var fake_data = [];
		var auto_data = [];
		var pert_types = ["trt_sh","trt_oe","trt_oe"];
		var cell_ids = ["MCF7","VCAP","PC3","A375","A549","HEPG2"];
		for (var i =0; i < 45000; i++){
			type_index = Math.floor(Math.random() * pert_types.length);
			cell_index = Math.floor(Math.random() * pert_types.length);
			reagent = "Reagent " + Math.floor(Math.random()*1000000000);
			fake_data.push({
				pert_iname: reagent,
				pert_type: pert_types[type_index],
				cell_id: cell_ids[cell_index],
				num_inst: Math.floor(Math.random()*100)
			});
			auto_data.push(reagent);
		}
		auto_data = auto_data.concat(pert_types,cell_ids);
		this.grid_data = fake_data;
		$("#" + this.div_id + "_search").typeahead({source: auto_data,
													highlighter: function(item){
														if (pert_types.indexOf(item) != -1){
															return '<div><span class="label label-important">Pert Type</span>  ' + item  +  '</div>';
														}
														if (cell_ids.indexOf(item) != -1){
															return '<div><span class="label label-warning">Cell ID</span>  ' + item  +  '</div>';
														}
														return '<div><span class="label">Reagent Name</span>  ' + item  +  '</div>';
													}});

		this.grid = new Slick.Grid("#" + this.div_id + "_grid", this.grid_data, this.grid_columns, this.grid_options);

	}
}

function List_Panel(options){
	options = (options !== undefined) ? options : {};
	this.div_id = (options.div_id !== undefined) ? options.div_id : "List_Search_Panel" + Math.floor(Math.random()*1000000000);
	this.style = (options.style !== undefined) ? options.style : "background-color:#f0f0f0";
	this.grid_height = (options.grid_height !== undefined) ? options.grid_height : 300;
	this.grid_columns = (options.grid_columns !== undefined) ? options.grid_columns : [{id: "data", name: "Data", field: "data"}];
	this.grid_options = (options.grid_options !== undefined) ? options.grid_options : {enableCellNavigation: true,enableColumnReorder: false,fullWidthRows: true,forceFitColumns: true};
	this.grid_data = (options.grid_data !== undefined) ? options.grid_data : ["DataPoint1","DataPoint2","DataPoint3"];
	this.html = ['<div class="row-fluid" id="' + this.div_id + '" class="span12" style=' + this.style + '>',
				'<div id="' + this.div_id + '_grid" style="height:' + this.grid_height + 'px">',
				'</div>'
				].join('\n');

	this.add_to_div = add_to_div;

	function add_to_div(div_target){
		$("#" + div_target).append(this.html);

		this.grid = new Slick.Grid("#" + this.div_id + "_grid", this.grid_data, this.grid_columns, this.grid_options);

	}
}