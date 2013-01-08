function draw_simple_bar(container,height,width,data,title,labels){
	var chart = d3.select(container).append("svg")
		.attr("class","chart")
		.attr("height",height + 40)
		.attr("width",width+20);
		
	chart.append("g")
		.attr("class","ticks");
	chart.append("g")
		.attr("class","bars");
	
	var chart_ticks = d3.select(container).select("g.ticks");
	var chart_bars = d3.select(container).select("g.bars");
		
	//set up y axis scaling	
	var y = d3.scale.linear()
		.domain([0 ,d3.max(data)])
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
		.text(String);
		
	
	//draw bars
	chart_bars.selectAll(".data_rect")
		.data(data)
		.enter().append("rect")
		.attr("class", "data_rect")
		.attr("x",function(d,i){return i*(width/data.length);})
		.attr("height", y)
		.attr("transform",function(d){return "translate(20," + (height - y(d) +30) + ")";})
		.attr("width", width/data.length)
		.attr("style", function(d){
			var fill_color = (parseFloat(d) > 4) ? "steelblue" : "gainsboro";
			return "fill: " + fill_color;
		});

	//data labels
	chart_bars.selectAll(".data_label")
		.data(data)
		.enter().append("text")
		.attr("class", "data_label")
		.attr("x",function(d,i){return i*(width/data.length);})
		.attr("y", function(d){return (height - y(d));})
		.attr("dy", 15)
		.attr("dx", width/data.length/2)
		.attr("transform","translate(20,30)")
		.attr("text-anchor","middle")
		.text(String);
	
	//bottom panel
	chart_bars.selectAll(".bottom_panel")
		.data([1])
		.enter().append("rect")
		.attr("class","bottom_panel")
		.attr("y",height + 20)
		.attr("x", 10)
		.attr("height",20)
		.attr("width", width+20);
	
	//bar_labels 
	chart_bars.selectAll(".bar_label")
		.data(labels)
		.enter().append("text")
		.attr("class", "bar_label")
		.attr("x",function(d,i){return i*(width/data.length);})
		.attr("y", height)
		.attr("dy", 5)
		.attr("dx", width/data.length/2)
		.attr("font-size", function(d){
			var computed_size = (width/data.length)/d.length*1.5;
			var optimal_size = (computed_size > 20) ? 20 : computed_size;
			return optimal_size;
			})
		.attr("transform","translate(20,30)")
		.attr("text-anchor","middle")
		.text(String);
	
	//top label
	chart_bars.selectAll(".chart_title")
		.data([1])
		.enter().append("text")
		.attr("class","chart_title")
		.attr("y",15)
		.attr("x", width/2)
		.attr("text-anchor","middle")
		.attr("font-size",20)
		.text(title);
	
}

function update_simple_bar(container,data,title){
	//select the top level svg element and grab chart dimensions
	var chart = d3.select(container).select("svg");
	var chart_ticks = d3.select(container).select("g.ticks");
	var chart_bars = d3.select(container).select("g.bars");
	var height = chart.attr("height") - 40;
	var width = chart.attr("width") - 20;
	
	//set up y axis scaling	
	var y = d3.scale.linear()
		.domain([0 ,d3.max(data)])
		.range([10, height-40]);
	
	//update chart
	//set up variables
	var ticks = chart_ticks.selectAll("line") 
		.data(y.ticks(8));
	var tick_labels = chart_ticks.selectAll(".tick_label")
		.data(y.ticks(8));
	var data_rect = chart_bars.selectAll(".data_rect")
		.data(data);
	var data_label = chart_bars.selectAll(".data_label")
		.data(data);
	var chart_title = chart_bars.selectAll(".chart_title")
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
		.text(String);
	data_rect.enter().insert("rect")
		.attr("class", "data_rect")
		.attr("x",function(d,i){return i*(width/data.length);})
		.attr("height", y)
		.attr("transform",function(d){return "translate(20," + (height - y(d) +30) + ")";})
		.attr("width", width/data.length);
	data_label.enter().append("text")
		.attr("class", "data_label")
		.attr("x",function(d,i){return i*(width/data.length);})
		.attr("y", function(d){return (height - y(d));})
		.attr("dy", 15)
		.attr("dx", width/data.length/2)
		.attr("transform","translate(20,30)")
		.attr("text-anchor","middle")
		.text(String);
		
	//transition
	ticks.transition()
		.duration(1000)
		.attr("y1", function(d){return (height - y(d));})
		.attr("y2", function(d){return (height - y(d));});
	tick_labels.transition()
		.duration(1000)
		.attr("y", function(d){return (height - y(d) - 10);})
		.text(String);
	data_rect.transition()
		.duration(1000)
		.attr("x",function(d,i){return i*(width/data.length);})
		.attr("height", y)
		.attr("transform",function(d){return "translate(20," + (height - y(d) + 30) + ")";})
		.attr("width", width/data.length)
		.style("fill", function(d){
			var fill_color = (parseFloat(d) > 4) ? "steelblue" : "gainsboro";
			return fill_color;
		});
	data_label.transition()
		.duration(1000)
		.attr("x",function(d,i){return i*(width/data.length);})
		.attr("y", function(d){return (height - y(d));})
		.attr("dx", width/data.length/2)
		.attr("transform","translate(20,30)")
		.text(String);
	chart_title.transition().text(title);

	//exit
	ticks.exit().remove();
	tick_labels.exit().remove();
	data_rect.exit().remove();
	data_label.exit().remove();
	chart_title.exit().remove();
			
}