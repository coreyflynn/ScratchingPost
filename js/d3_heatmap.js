/*
var data = [{probeName:"probe1", sample1:"1", sample2:"0"},
            {probeName:"probe2", sample1:"0.9", sample2:"0.1"},
            {probeName:"probe3", sample1:"0.8", sample2:"0.2"},
            {probeName:"probe4", sample1:"0.7", sample2:"0.3"},
            {probeName:"probe5", sample1:"0.6", sample2:"0.4"},
            {probeName:"probe6", sample1:"0.55", sample2:"0.45"},
            {probeName:"probe7", sample1:"0.4", sample2:"0.6"},
            {probeName:"probe8", sample1:"0.3", sample2:"0.7"},
            {probeName:"probe9", sample1:"0.2", sample2:"0.8"},
            {probeName:"probe10", sample1:"0.1", sample2:"0.9"},
            {probeName:"probe11", sample1:"0", sample2:"1.0"}];

*/

function draw_heatmap(data){
//base size parameter.  Scale the whole graphic to the displayed window size
var chartH = window.innerHeight;


//grab the names of the samples to be used
var sample_names = [];
for (var key in data[0]){
	if (data[0].hasOwnProperty(key)){
		if (key != "probeName"){
			sample_names.push(key);
		}
	}
}



//for each sample_name build an array of its data and package into a top level array
var sample_data = [];
for (var ii in sample_names){
	var tmp_array = [];
	for (var jj in data){
		tmp_array.push(data[jj][sample_names[ii]]);
	}
	sample_data.push(tmp_array);
}

//build an array of probe color mappings
var probe_color_mappings = [];
for (var ii in sample_data[0]){
	var tmp_vals = [];
	for (var jj in sample_data){
		tmp_vals.push(sample_data[jj][ii]);
	}
	probe_color_mappings.push(d3.scale.linear().domain([-10,10]));
}

//find the maximum length sample name and compute a height offset to make room for it
var sample_name_lengths = [];
for (var ii in sample_names){
	sample_name_lengths.push(sample_names[ii].length);
}
var max_sample_name_length = d3.max(sample_name_lengths);

// build an array of probe names and set the square_size based on the number of probes and
// screen size
var probe_names = [];
for (var ii in data){
	probe_names.push(data[ii].probeName);
}
var square_size = chartH/(probe_names.length);
var font_size = square_size/1.7;

var H_offset = max_sample_name_length*font_size/1.7;
H_offset = (H_offset > chartH/2 ? chartH/2 : H_offset);
var square_size = (chartH-H_offset)/(probe_names.length);

//set up the base graphic container in the document body
var chartW = (sample_names.length + 2)*square_size;
var chart = d3.select("body")
	.append("svg:svg")
	.attr("class", "chart")
	.attr("width", (chartW > 400) ? chartW:400) 
	.attr("height", chartH);

//draw a square for each (sample,probeset) pair at location (x,y).  Give each sample and 
//probeset attributes so we can query them on mouseover
for (ii in sample_names){
chart.selectAll("rect." + "sample" + ii)
	.data(sample_data[ii])
	.enter().append("svg:rect")
	.attr("class","sample" + ii)
	.attr("sample",sample_names[ii])
	.attr("probeset",function(d,i){return probe_names[i];})
	.attr("val", String)
	.attr("x", 0 + square_size*ii)
	.attr("y", function(d,i){return H_offset + i*square_size;})
	.attr("height", square_size)
	.attr("width", square_size)
	.attr("stroke-width",0.5)
	.attr("opacity",1)
	.attr("fill",function (d,i){
		var val = parseFloat(d);
		var color_mapper = probe_color_mappings[i];
		var color_val = color_mapper(val);
		var r = (color_val > 0.4) ? 255: 255 - Math.abs(color_val - 0.5)*255*2;
		var b = (color_val < 0.6) ? 255: 255 - Math.abs(color_val - 0.5)*255*2;
		var g = (color_val < 0.6 & color_val > 0.4 ) ? 255: 255 - Math.abs(color_val - 0.5)*255*2;
		return d3.rgb(r,g,b);
		})
	.on("mouseover",mouse_over)
	.on("mouseout",mouse_out);
}

//draw probe labels.  Give them probeset attributes so we can query them on mouseover 
//callbacks
chart.selectAll("text.probe_name")
	.data(probe_names)
	.enter().append("svg:text")
	.attr("class","probe_name")
	.attr("probeset", String)
	.attr("x", 0 + square_size*sample_names.length + square_size/10)
	.attr("y", function(d,i){return H_offset + i*square_size + square_size/1.5;})
	.attr("opacity",1)
	.attr("font-size",font_size)
	.attr("font-weight","normal")
	.text(String);

//draw sample labels.  Give them sample attributes so we can query them on mouseover 
//callbacks
chart.selectAll("text.sample_name")
	.data(sample_names)
	.enter().append("svg:text")
	.attr("class","sample_name")
	.attr("sample", String)
	.attr("x", function(d,i) {return 0 + square_size*i + square_size/1.5;})
	.attr("y", H_offset - square_size/10)
	.attr("transform", function(d,i) {
		return "rotate(-90 " + (0 + square_size*i + square_size/1.5) + " " + (H_offset - square_size/10) + ")";})
	.attr("opacity",1)
	.attr("font-size",font_size)
	.text(String);

//set up a function to display a hovering info box at the mouse position and to highlight
//the appropriate sample and probeset labels in bold text
function mouse_over(){
	var pos = d3.svg.mouse(this);
	var sample = d3.select(this).attr("sample");
	var probeset = d3.select(this).attr("probeset");
	var val = d3.select(this).attr("val");
	
	//bold labels
	chart.selectAll("text.probe_name")
		.attr("font-weight",function(d){return (d == probeset) ? "bold":"normal";});
	chart.selectAll("text.sample_name")
		.attr("font-weight",function(d){return (d == sample) ? "bold":"normal";});
	
	//hover background
	chart.selectAll("rect.hover_bg")
		.data([1])
		.enter().append("svg:rect")
		.attr("class","hover_bg")
		.attr("x",pos[0])
		.attr("y",pos[1]- 52)
		.attr("height",44)
		.attr("font-size",16)
		.attr("width",sample.length*16/1.7);
	
	//hover sample text
	chart.selectAll("text.hover_sample")
		.data([1])
		.enter().append("svg:text")
		.attr("class","hover_sample")
		.attr("x",pos[0])
		.attr("y",pos[1]- 40)
		.attr("font-weight","bold")
		.text(sample);
	
	//hover probeset text
	chart.selectAll("text.hover_probeset")
		.data([1])
		.enter().append("svg:text")
		.attr("class","hover_probeset")
		.attr("x",pos[0])
		.attr("y",pos[1]- 25)
		.attr("font-weight","bold")
		.text(probeset);
	
	//hover value text
	chart.selectAll("text.hover_val")
		.data([1])
		.enter().append("svg:text")
		.attr("class","hover_val")
		.attr("x",pos[0])
		.attr("y",pos[1]- 10)
		.attr("font-weight","bold")
		.text(val);
	
}

//clear all mousever effects on mouseout
function mouse_out(d){
	chart.selectAll("text.probe_name")
	.attr("font-weight","normal");
	chart.selectAll("text.sample_name")
	.attr("font-weight","normal");
	chart.selectAll("rect.hover_bg")
	.data([])
	.exit().remove();
	chart.selectAll("text.hover_sample")
	.data([])
	.exit().remove();
	chart.selectAll("text.hover_probeset")
	.data([])
	.exit().remove();
	chart.selectAll("text.hover_val")
	.data([])
	.exit().remove();
}
}