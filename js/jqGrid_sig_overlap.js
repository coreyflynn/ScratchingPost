function make_sig_overlap_table(table_id,pager_id,caption){
	jQuery(table_id).jqGrid({
		datatype: "local",
		height: 250,
	   	colNames:['name','up', 'down'],
	   	colModel:[
	   		{name:'name',index:'name', width:200, sorttype:"text"},
	   		{name:'up',index:'up', width:90, sorttype:"float"},
	   		{name:'down',index:'down', width:90, sorttype:"float"}		
	   	],
	   	rowNum:30,
	   	rowList:[10,20,30, 40, 50],
	   	pager: pager_id,
	   	caption: caption
	});
	jQuery(table_id).jqGrid('navGrid',pager_id,{add:false,edit:false,del:false});
	 
	for(var i=0;i<=data.length;i++)
		jQuery(table_id).jqGrid('addRowData',i+1,data[i]);
}