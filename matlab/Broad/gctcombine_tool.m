function combined  = gctcombine_tool(gct_1,gct_2)
%combine two gct files
combined.mat = horzcat(gct_1.mat, gct_2.mat);
combined.rid = gct_1.rid;
combined.rhd = gct_1.rhd;
combined.rdesc = horzcat(gct_1.rdesc, gct_2.rdesc);
combined.cid = vertcat(gct_1.cid, gct_2.cid);
%combined.chd = vertcat(gct_1.chd, gct_2.chd);
combined.chd = gct_1.chd;
combined.cdesc = vertcat(gct_1.cdesc, gct_2.cdesc);
combined.version = '#1.3';
combined.src = [gct_1.src '|' gct_2.src];
combined.cdict = vertcat(gct_1.cdict, gct_2.cdict);
combined.rdict = vertcat(gct_1.rdict, gct_2.rdict);