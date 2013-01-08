function cm2gct(cm,labels,gct_path)
%write a gct file from a correlation matri and given labels
gct_struct.mat = cm;
gct_struct.cid = labels;
gct_struct.rid = labels;
gct_struct.chd = '';
gct_struct.rhd = '';
gct_struct.cdesc = '';
gct_struct.rdesc = '';
mkgct(gct_path,gct_struct);
