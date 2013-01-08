function draw_simple_line(container,height,width,data,title){
	var chart = d3.select(container).append("svg")
		.attr("class","chart")
		.attr("height",height + 40)
		.attr("width",width+20);
		
	chart.append("g")
		.attr("class","ticks");
	chart.append("g")
		.attr("class","lines");
	
	var chart_ticks = d3.select(container).select("g.ticks");
	var chart_lines = d3.select(container).select("g.lines");
		
	//set up y axis scaling	
	var x = d3.scale.linear()
		.domain([0 ,data.length-1])
		.range([20, width]);
	
	//set up y axis scaling	
	var y = d3.scale.linear()
		.domain([d3.min(data) ,d3.max(data)])
		.range([10, height-40]);
	
	//build tick lines
	chart_ticks.selectAll("line")
		.data(y.ticks(8))
		.enter().append("line")
		.attr("x1",0)
		.attr("x2",width)
		.attr("y1", function(d){return (height - y(d));})
		.attr("y2", function(d){return (height - y(d));})
		.attr("transform","translate(20,30)");
	
	//build tick labels
	chart_ticks.selectAll(".tick_label")
		.data(y.ticks(8))
		.enter().append("text")
		.attr("class", "tick_label")
		.attr("y", function(d){return (height - y(d) - 10);})
		.attr("transform","translate(0,45)")
		.text(function(d){return String(d.toFixed(1));});
		
	
	//draw lines
	var make_line = d3.svg.line()
		.x(function (d,i){return x(i);})
		.y(function (d){return height -y(d) +30;});
	
	chart_lines.selectAll("path.data_line")
		.data([data])
		.enter().append("svg:path")
		.attr("class", "data_line")
		.attr("d",make_line)
		.attr("fill", "none");
	
	//top label
	chart_lines.selectAll(".chart_title")
		.data([1])
		.enter().append("text")
		.attr("class","chart_title")
		.attr("y",15)
		.attr("x", width/2)
		.attr("text-anchor","middle")
		.attr("font-size",20)
		.text(title);
	
}

function update_simple_line(container,data,title){
	//select the top level svg element and grab chart dimensions
	var chart = d3.select(container).select("svg");
	var chart_ticks = d3.select(container).select("g.ticks");
	var chart_lines = d3.select(container).select("g.lines");
	var height = chart.attr("height") - 40;
	var width = chart.attr("width") - 20;
	    
    //set up y axis scaling	
	var x = d3.scale.linear()
		.domain([0 ,data.length-1])
		.range([20, width]);
	
	//set up y axis scaling	
	var y = d3.scale.linear()
		.domain([d3.min(data) ,d3.max(data)])
		.range([10, height-40]);
	
    //define drawing function
	var make_line = d3.svg.line()
		.x(function (d,i){return x(i);})
		.y(function (d){return height -y(d) +30;});
    
	//update chart
	//set up variables
	var ticks = chart_ticks.selectAll("line") 
		.data(y.ticks(8));
	var tick_labels = chart_ticks.selectAll(".tick_label")
		.data(y.ticks(8));
	var data_line = chart_lines.selectAll(".data_line")
		.data([data]);
	var chart_title = chart_lines.selectAll(".chart_title")
		.data([1]);
	    
	//enter
	ticks.enter().append("line")
		.attr("x1",0)
		.attr("x2",width)
		.attr("y1", function(d){return (height - y(d));})
		.attr("y2", function(d){return (height - y(d));})
		.attr("transform","translate(20,30)");
	tick_labels.enter().append("text")
		.attr("class", "tick_label")
		.attr("y", function(d){return (height - y(d) - 10);})
		.attr("transform","translate(0,45)")
		.text(function(d){return String(d.toFixed(2));});
	data_line.enter().append("svg:path")
        .attr("class", "data_line")
		.attr("d",make_line)
		.attr("fill", "none");
		
	//transition
	ticks.transition()
		.duration(1000)
		.attr("y1", function(d){return (height - y(d));})
		.attr("y2", function(d){return (height - y(d));});
	tick_labels.transition()
		.duration(1000)
		.attr("y", function(d){return (height - y(d) - 10);})
		.text(function(d){return String(d.toFixed(1));});
    data_line.transition()
        .duration(1000)
        .attr("d",make_line);
    chart_title.transition().text(title);

	//exit
	ticks.exit().remove();
	tick_labels.exit().remove();
    data_line.exit().remove();
	chart_title.exit().remove();
			
}