function plate_zscore_dist_plot(gct_path,control_string)
%function to display the histogram of all z-scores of control wells versus that of all other compounds

%load the gct file
gct = parse_gct(gct_path);

%find the control well inds in the combined gct file
control_inds = cids_from_cdesc(gct,control_string);

%find the non-control inds
exp_inds = 1:length(gct.cid);
exp_inds(control_inds) = [];

%plot the normalized histogram of each distribution
control_mat = gct.mat(:,control_inds);
[control_n,control_x] = hist(control_mat(:),1000);

exp_mat = gct.mat(:,exp_inds);
[exp_n,exp_x] = hist(exp_mat(:),1000);

control_n = control_n/max(control_n);
exp_n = exp_n/max(exp_n);

plot(control_x,control_n);hold on;
plot(exp_x,exp_n,'r');hold off;
legend({'control','exp'},'Location','NorthWest');