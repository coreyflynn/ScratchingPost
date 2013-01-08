function gct = gctadd_sample_annot(gct,hd,desc)

gct.chd = vertcat(gct.chd,hd);
gct.cdesc = horzcat(gct.cdesc,repmat({desc},size(gct.cdesc,1),1));