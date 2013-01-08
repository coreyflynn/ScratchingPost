//requires D3.js
function signature_bars(data){
	//window scaling
	var winW = window.innerWidth-20;
	
	//data specification
	var ups = [];
	var downs = [];
	var names = [];
	data.forEach(function(d){
		ups.push(d.up);
		downs.push(d.down);
		names.push(d.name);
	});
	var data_max = d3.max(ups.concat(downs));
	
	//set up y scale range and bar width
	var y = d3.scale.linear()
	     .domain([0, data_max])
	     .range([0, 200]);
	     
	var bar_width = winW/data.length;
	
	//set up the chart svg container
	var chart = d3.select("body")
	     .append("svg:svg")
	     .attr("class", "chart")
	     .attr("width", winW)
	     .attr("height", 250);
	
	//build the bars in the chart based on data
	chart.selectAll("rect.up")
		.data(ups)
		.enter().append("svg:rect")
		.attr("class","up")
		.attr("sig_name",function(d,i){return names[i];})
		.attr("up",function(d,i){return ups[i];})
		.attr("down",function(d,i){return downs[i];})
		.attr("x", function(d,i){return i*bar_width;})
		.attr("y", function(d){return 120 - y(d)/2;})
		.attr("ry", bar_width/20)
		.attr("height", function(d){return y(d)/2;})
		.attr("width", bar_width )
		.attr("stroke-width",0.5)
		.attr("opacity",function(d){return (d> data_max/2) ? 1: 0.3;})
		.on("mouseover",mouse_over)
		.on("mouseout",mouse_out);
	
	chart.selectAll("rect.down")
		.data(downs)
		.enter().append("svg:rect")
		.attr("class","down")
		.attr("sig_name",function(d,i){return names[i];})
		.attr("up",function(d,i){return ups[i];})
		.attr("down",function(d,i){return downs[i];})
		.attr("x", function(d,i){return i*bar_width;})
		.attr("y", 120)
		.attr("ry", bar_width/20)
		.attr("height", function(d){return y(d)/2;})
		.attr("width", bar_width )
		.attr("stroke-width",0.5)
		.attr("opacity",function(d){return (d>data_max/2) ? 1: 0.3;})
		.on("mouseover",mouse_over)
		.on("mouseout",mouse_out);
	
	//build the scale lines
	var y_lines = d3.scale.linear()
	.domain([-data_max, data_max])
	.range([20, 220]);
	var lines = [data_max, data_max/2, -data_max/2, -data_max];
	chart.selectAll("line")
		.data(lines)
		.enter().append("svg:line")
		.attr("x1",0)
		.attr("x1",winW)
		.attr("y1",y_lines)
		.attr("y2",y_lines);
	
	chart.selectAll("text.line_label")
		.data(lines)
		.enter().append("svg:text")
		.attr("class","line_label")
		.attr("x",0)
		.attr("y",function(d){
			if(y_lines(d) < 120){
				return y_lines(d)+20;
			}
			else{
				return y_lines(d)-5;
			}
		})
		.attr("font-size",20)
		.attr("font-weight","bold")
		.text(function(d){return Math.abs(String(d));});
	
	
	chart.selectAll("text.x_label")
		.data([1])
		.enter().append("svg:text")
		.attr("class","x_label")
		.attr("x",0)
		.attr("y",15)
		.attr("font-size",20)
		.attr("font-weight","bold")
		.text("Probesets in Common");
	
	chart.selectAll("text.y_label")
		.data([1])
		.enter().append("svg:text")
		.attr("class","y_label")
		.attr("x",winW/2)
		.attr("y",240)
		.attr("text-anchor","middle")
		.attr("font-size",20)
		.attr("font-weight","bold")
		.text("Signatures (N=" + data.length + ")");
	
	chart.selectAll("text.legend_up")
		.data([1])
		.enter().append("svg:text")
		.attr("class","legend_up")
		.attr("x",winW - 231)
		.attr("y",15)
		.attr("font-size",12)
		.attr("font-weight","bold")
		.text("Up Probsets");
	
	chart.selectAll("rect.legend_up")
		.data([1])
		.enter().append("svg:rect")
		.attr("class","legend_up")
		.attr("x",winW - 242)
		.attr("y",6)
		.attr("height",10)
		.attr("width",10);
	chart.selectAll("text.legend_down")
		.data([1])
		.enter().append("svg:text")
		.attr("class","legend_down")
		.attr("x",winW - 151)
		.attr("y",15)
		.attr("font-size",12)
		.attr("font-weight","bold")
		.text("Down Probsets");

	chart.selectAll("rect.legend_down")
		.data([1])
		.enter().append("svg:rect")
		.attr("class","legend_down")
		.attr("x",winW - 162)
		.attr("y",6)
		.attr("height",10)
		.attr("width",10);
	
	chart.selectAll("text.legend_max")
		.data([1])
		.enter().append("svg:text")
		.attr("class","legend_max")
		.attr("x",winW - 49)
		.attr("y",15)
		.attr("font-size",12)
		.attr("font-weight","bold")
		.text("< Max/2");
	
	chart.selectAll("rect.legend_down_op")
		.data([1])
		.enter().append("svg:rect")
		.attr("class","legend_up_op")
		.attr("x",winW - 70)
		.attr("y",6)
		.attr("height",10)
		.attr("width",10);
	
	chart.selectAll("rect.legend_down_op")
		.data([1])
		.enter().append("svg:rect")
		.attr("class","legend_down_op")
		.attr("x",winW - 60)
		.attr("y",6)
		.attr("height",10)
		.attr("width",10);

	function mouse_over(){
		var pos = d3.svg.mouse(this);
		var sig_name = d3.select(this).attr("sig_name");
		var up = d3.select(this).attr("up");
		var down = d3.select(this).attr("down");
		chart.selectAll("rect.sig_label_bg")
		.data([1])
		.enter().append("svg:rect")
		.attr("class","sig_label_bg")
		.attr("x",pos[0])
		.attr("y",pos[1]- 52)
		.attr("height",44)
		.attr("width",100);
		
		chart.selectAll("text.sig_label_name")
		.data([1])
		.enter().append("svg:text")
		.attr("class","sig_label_name")
		.attr("x",pos[0])
		.attr("y",pos[1]- 40)
		.attr("font-weight","bold")
		.text(sig_name);
		chart.selectAll("text.sig_label_up")
		.data([1])
		.enter().append("svg:text")
		.attr("class","sig_label_up")
		.attr("x",pos[0])
		.attr("y",pos[1]- 25)
		.attr("font-weight","bold")
		.text("Up: " + up);
		chart.selectAll("text.sig_label_down")
		.data([1])
		.enter().append("svg:text")
		.attr("class","sig_label_down")
		.attr("x",pos[0])
		.attr("y",pos[1]- 10)
		.attr("font-weight","bold")
		.text("Down: " + down);
	}
	
	function mouse_out(d){
		chart.selectAll("rect.sig_label_bg")
		.data([])
		.exit().remove();
		chart.selectAll("text.sig_label_name")
		.data([])
		.exit().remove();
		chart.selectAll("text.sig_label_up")
		.data([])
		.exit().remove();
		chart.selectAll("text.sig_label_down")
		.data([])
		.exit().remove();
	}
}