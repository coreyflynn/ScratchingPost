function Compound_Info_Object(div_id,width,height,margin){
	this.div_id = div_id;
	this.width = width;
	this.height = height;
	this.margin = margin;
	this.compound = "";
	this.nsample = 0;
	this.num_lines = 0;
	this.init = false;

	this.clear = clear;
	this.draw = draw;
	this.draw_bg = draw_bg;
	this.draw_name = draw_name;
	this.draw_compound_info = draw_compound_info;
	this.update_compound = update_compound;
	this.update_compound_info = update_compound_info;
	this.hide = hide;
	this.show = show;

	function clear(){
		if (this.init){
			this.svg.remove();
			this.init = false;
		}
	}

	function draw(width){
		if (!this.init){
			this.svg=d3.select(this.div_id).append("svg")
						.attr("class","card")
						.attr("width",width)
						.attr("height",height);
			this.init = true;
		}
		this.width = width;
		var x=d3.scale.linear().domain([0,1]).range([this.margin,this.width-this.margin]);
		var y=d3.scale.linear().domain([0,1]).range([this.height-this.margin,this.margin]);
		this.draw_bg(x,y,this.width);
		this.draw_name(x,y);
		this.draw_compound_info(x,y);

	}

	function update_compound(compound,width){
		this.compound = compound;
		this.width = width;
		var self = this;
		var siginfo = 'http://lincscloud.org/api/siginfo?callback=?';
		$.getJSON(siginfo,{q:'{"pert_desc":"' + compound +'"}',
							f:'{"cell_id":1,"pert_type":1,"pert_desc":1,"distil_nsample":1}',
							l:1000},
							function(response){
								var nsample = 0;
								var cells = [];
								response.forEach(function(element,index,array){
									nsample += element.distil_nsample;
									cells.push(element.cell_id);
								});
							cells = _.uniq(cells);
							self.update_compound_info(nsample,cells.length);
							self.draw(self.width);
		});
	}

	function update_compound_info(nsample,num_lines){
		this.nsample = nsample;
		this.num_lines = num_lines;
	}

	function draw_bg(x,y,width){
		this.svg.selectAll("rect.bg").data([]).exit().remove();

		this.svg.selectAll("rect.bg").data([1])
				.enter().append("rect")
				.attr("x",x(0) - margin)
				.attr("y",y(1) - margin)
				.attr("class","bg")
				.attr("height", height)
				.attr("width", width)
				.attr("fill", "#f0f0f0");
	}

	function draw_name(x,y){
		this.svg.selectAll("text.name").data([]).exit().remove();

		this.svg.selectAll("text.name").data([this.compound])
			.enter().append("text")
			.attr("class","name")
			.attr("x",x(0.5))
			.attr("y",40)
			.attr("font-size",40)
			.attr("text-anchor","middle")
			.text(function(d){ return d;});
	}

	function draw_compound_info(x,y){
		this.svg.selectAll("image.cp").data([]).exit().remove();
		this.svg.selectAll("image.cp").data([this.nsample])
			.enter().append("image")
			.attr("xlink:href","http://coreyflynn.github.com/Bellhop/img/arrow_down_round_small.png")
			.attr("class","cp")
			.attr("x",x(0.5) - 50)
			.attr("y",55)
			.attr("height",100)
			.attr("width",100);

		this.svg.selectAll("text.cp_text").data([]).exit().remove();
		this.svg.selectAll("text.cp_text").data([this.nsample])
			.enter().append("text")
			.attr("class","cp_text")
			.attr("x",x(0.5))
			.attr("y",55 + 60)
			.attr("font-size",25)
			.attr("text-anchor","middle")
			.attr("fill","#f0f0f0")
			.text(this.nsample);

		this.svg.selectAll("text.cp_static").data([]).exit().remove();
		this.svg.selectAll("text.cp_static").data([this.nsample])
			.enter().append("text")
			.attr("class","cp_static")
			.attr("x",x(0.5))
			.attr("y",55 + 115)
			.attr("font-size",20)
			.attr("text-anchor","middle")
			.text("Experiments");

		this.svg.selectAll("text.cell_lines_text").data([]).exit().remove();
		this.svg.selectAll("text.cell_lines_text").data([this.kd_num])
			.enter().append("text")
			.attr("class","cell_lines_text")
			.attr("x",x(0.5))
			.attr("y",55 + 135)
			.attr("font-size",20)
			.attr("text-anchor","middle")
			.text("In " + this.num_lines + " Cell Lines");
	}

	function hide(){
		if (this.init){
			$("svg.card").height(0);
			$("svg.card").hide();
		}
		$("svg.card").animate({height:0});
	}

	function show(){
		$("svg.card").show();
		$("svg.card").animate({height:this.height});
	}

}
