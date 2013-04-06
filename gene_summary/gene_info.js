function Gene_Info_Object(div_id,width,height,margin){
	this.div_id = div_id;
	this.width = width;
	this.height = height;
	this.margin = margin;
	this.symbol = "";
	this.kd_num = 0;
	this.oe_num = 0;
	this.kd_num_lines = 0;
	this.oe_num_lines = 0;
	this.init = false;

	this.clear = clear;
	this.draw = draw;
	this.draw_bg = draw_bg;
	this.draw_symbol = draw_symbol;
	this.draw_KD = draw_KD;
	this.draw_OE = draw_OE;
	this.update_symbol = update_symbol;
	this.update_long_name = update_long_name;
	this.update_kd = update_kd;
	this.update_oe = update_oe;
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
		this.draw_symbol(x,y);
		this.draw_KD(x,y);
		this.draw_OE(x,y);

	}

	function update_symbol(symbol,width){
		this.symbol = symbol;
		this.width = width;
		var self = this;
		var geneinfo = 'http://lincscloud.org/api/geneinfo?callback=?';
		var siginfo = 'http://lincscloud.org/api/siginfo?callback=?';
		$.getJSON(geneinfo,{q:'{"pr_gene_symbol":"' + symbol + '"}'},
                          function(response){
                            self.update_long_name(response[0].pr_gene_title);

			$.getJSON(siginfo,{q:'{"pert_desc":"' + symbol +'"}',
								f:'{"cell_id":1,"pert_type":1}',
								l:1000},
								function(response){
									var oe_sigs = [];
									var kd_sigs = [];
									var kd_cells = [];
									var oe_cells = [];
									response.forEach(function(element,index,array){
										if (element.pert_type == "trt_oe"){
											oe_sigs.push(element);
											oe_cells.push(element.cell_id);
										}
										if (element.pert_type == "trt_sh"){
											kd_sigs.push(element);
											kd_cells.push(element.cell_id);
										}
									});
								oe_cells = _.uniq(oe_cells);
								kd_cells = _.uniq(kd_cells);
								self.update_oe(oe_sigs.length,oe_cells.length);
								self.update_kd(kd_sigs.length,kd_cells.length);
								self.draw(self.width);
			});
        });
	}

	function update_long_name(long_name){
		this.long_name = long_name;
	}

	function update_kd(kd_num,kd_num_lines){
		this.kd_num = kd_num;
		this.kd_num_lines = kd_num_lines;
	}	
	
	function update_oe(oe_num,oe_num_lines){
		this.oe_num = oe_num;
		this.oe_num_lines = oe_num_lines;
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

	function draw_symbol(x,y){
		// long name text element
		this.svg.selectAll(".long").data([]).exit().remove();

		this.svg.selectAll(".long").data([this.long_name])
			.enter().append("foreignObject")
			.attr("class","long")
			.attr("x",x(0))
			.attr("y",y(0.9) + 5)
			.attr("width",this.width - margin)
			.attr("height",50)
			.append("xhtml:body")
			.style("font", "20px 'Helvetica Neue'")
			.style("background-color","#f0f0f0")
			.html(function(d) {return "<p>" + d + "</p>";});

		this.svg.selectAll("text.symbol").data([]).exit().remove();

		this.svg.selectAll("text.symbol").data([this.symbol])
			.enter().append("text")
			.attr("class","symbol")
			.attr("x",x(0))
			.attr("y",y(0.9))
			.attr("font-size",40)
			.text(function(d){ return d;});

		
	}

	function draw_KD(x,y){
		this.svg.selectAll("image.down").data([]).exit().remove();
		this.svg.selectAll("image.down").data([this.kd_num])
			.enter().append("image")
			.attr("xlink:href","http://coreyflynn.github.com/Bellhop/img/arrow_down_round_small.png")
			.attr("class","down")
			.attr("x",x(0) + 50)
			.attr("y",y(0.6))
			.attr("height",100)
			.attr("width",100);

		this.svg.selectAll("text.kd_text").data([]).exit().remove();
		this.svg.selectAll("text.kd_text").data([this.kd_num])
			.enter().append("text")
			.attr("class","kd_text")
			.attr("x",x(0) + 100)
			.attr("y",y(0.6) + 60)
			.attr("font-size",25)
			.attr("text-anchor","middle")
			.attr("fill","#f0f0f0")
			.text(this.kd_num);

		this.svg.selectAll("text.down").data([]).exit().remove();
		this.svg.selectAll("text.down").data([this.kd_num])
			.enter().append("text")
			.attr("class","down")
			.attr("x",x(0) + 100)
			.attr("y",y(0.6) + 115)
			.attr("font-size",20)
			.attr("text-anchor","middle")
			.text("KD Experiments");

		this.svg.selectAll("text.kd_lines_text").data([]).exit().remove();
		this.svg.selectAll("text.kd_lines_text").data([this.kd_num])
			.enter().append("text")
			.attr("class","kd_lines_text")
			.attr("x",x(0) + 100)
			.attr("y",y(0.6) + 135)
			.attr("font-size",20)
			.attr("text-anchor","middle")
			.text("In " + this.kd_num_lines + " Cell Lines");
	}

	function draw_OE(x,y){
		this.svg.selectAll("image.up").data([]).exit().remove();
		this.svg.selectAll("image.up").data([this.oe_num])
			.enter().append("image")
			.attr("xlink:href","http://coreyflynn.github.com/Bellhop/img/arrow_up_round_small.png")
			.attr("class","up")
			.attr("x",x(1) - 150)
			.attr("y",y(0.6))
			.attr("height",100)
			.attr("width",100);

		this.svg.selectAll("text.oe_text").data([]).exit().remove();
		this.svg.selectAll("text.oe_text").data([this.oe_num])
			.enter().append("text")
			.attr("class","oe_text")
			.attr("x",x(1) - 100)
			.attr("y",y(0.6) + 60)
			.attr("font-size",25)
			.attr("text-anchor","middle")
			.attr("fill","#f0f0f0")
			.text(this.oe_num);

		this.svg.selectAll("text.up").data([]).exit().remove();
		this.svg.selectAll("text.up").data([this.oe_num])
			.enter().append("text")
			.attr("class","up")
			.attr("x",x(1) - 100)
			.attr("y",y(0.6) + 115)
			.attr("font-size",20)
			.attr("text-anchor","middle")
			.text("OE Experiments");

		this.svg.selectAll("text.oe_lines_text").data([]).exit().remove();
		this.svg.selectAll("text.oe_lines_text").data([this.oe_num])
			.enter().append("text")
			.attr("class","oe_lines_text")
			.attr("x",x(1) - 100)
			.attr("y",y(0.6) + 135)
			.attr("font-size",20)
			.attr("text-anchor","middle")
			.text("In " + this.oe_num_lines + " Cell Lines");
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
