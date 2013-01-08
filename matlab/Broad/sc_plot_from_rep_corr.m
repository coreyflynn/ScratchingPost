function varargout = sc_plot_from_rep_corr(tab_file,varargin)
%make a signature strength vs. mean correlation plot for the given cell line name from the data in 
%input_csv

%parse optional arguments
pnames = {'output','exclude','include'};
dflts = {'',{},'all'};
args = parse_args(pnames,dflts,varargin{:});

%read in the data
[pert_id,num_reps,max_cc,min_cc,mean_cc,ss] = textread(tab_file,'%s %f %f %f %f %f','delimiter','\t','headerlines',1);

%find the inds of samples with only one replicate and remove them from the data that we are goind to plot
empty_inds = find(num_reps == 1);
pert_id(empty_inds) = [];
mean_cc(empty_inds) = [];
ss(empty_inds) = [];

%include any samples that are specified
if ~strcmp(args.include,'all')
    if ischar(args.include)
        args.include = {args.include};
    end
    include_inds = [];
    for ii = 1:length(args.include)
        include_inds = vertcat(include_inds,get_cell_inds(pert_id,args.include{ii}));
    end
    pert_id = pert_id(include_inds);
    mean_cc = mean_cc(include_inds);
    ss = ss(include_inds);
else
    args.include = {'all'};    
end

%exclude any samples that are specified
for ii = 1:length(args.exclude)
    inds = get_cell_inds(pert_id,args.exclude{ii});
    pert_id(inds) = [];
    mean_cc(inds) = [];
    ss(inds) = [];    
end

%find the dmso inds of only those samples from the target cell line
dmso_inds = get_cell_inds(pert_id,'DMSO');

%annotate the graph with percentages for each quadrant
hold on;
high_cc_inds = find(mean_cc>= .25);
low_cc_inds = find(mean_cc< .25);
high_ss_inds = find(ss>= 6);
low_ss_inds = find(ss< 6);

num_inds = length(mean_cc);
bot_left = length(intersect(low_ss_inds,low_cc_inds))/num_inds;
bot_right = length(intersect(low_ss_inds,high_cc_inds))/num_inds;
top_left = length(intersect(high_ss_inds,low_cc_inds))/num_inds;
top_right = length(intersect(high_ss_inds,high_cc_inds))/num_inds;

rectangle('Position',[-1 0 1.25 6],'FaceColor',[1-(1*bot_left) 1 1-(1*bot_left)]);
rectangle('Position',[-1 6 1.25 14],'FaceColor',[1-(1*top_left) 1 1-(1*top_left)]);
rectangle('Position',[.25 0 .75 6],'FaceColor',[1-(1*bot_right) 1 1-(1*bot_right)]);
rectangle('Position',[.25 6 .75 14],'FaceColor',[1-(1*top_right) 1 1-(1*top_right)]);


%plot signature strength against mean_cc
scatter(mean_cc,ss,20,[0 0 1],'filled');
scatter(mean_cc(dmso_inds),ss(dmso_inds),50,[1 0 0],'filled');

%add cutoff value indicators
xlim([-1 1]);
ylim([0 20]);
line(xlim,[6 6],'Color','k','LineWidth',4);
line([.25 .25],ylim,'Color','k','LineWidth',4);

%add percentage annotations
text(-.9,1,['\fontsize{20}' sprintf('%.1f',bot_left*100) '%'],'BackgroundColor',[1-(1*bot_left) 1 1-(1*bot_left)]);
text(.6,1,['\fontsize{20}' sprintf('%.1f',bot_right*100) '%'],'BackgroundColor',[1-(1*bot_right) 1 1-(1*bot_right)]);
text(-.9,18.5,['\fontsize{20}' sprintf('%.1f',top_left*100) '%'],'BackgroundColor',[1-(1*top_left) 1 1-(1*top_left)]);
text(.6,18.5,['\fontsize{20}' sprintf('%.1f',top_right*100) '%'],'BackgroundColor',[1-(1*top_right) 1 1-(1*top_right)]);
%add labels
title_string = args.include{1};
if length(args.include) > 1
    for ii = 2:length(args.include)
        title_string = [title_string ':' args.include{ii}];
    end
end
title(['S-C plot for ' title_string]);
xlabel('mean replicate spearman CC');
ylabel('modz signature strength');

%legend
legend({'perts','dmso'},'location','West');

hold off;


%handle variable output
if strcmp(args.output,'top_right')
    varargout{1} = pert_id(intersect(high_ss_inds,high_cc_inds));
elseif strcmp(args.output,'all')
    varargout{1} = pert_id;
elseif strcmp(args.output,'top_right_bool')
    tmp_list = pert_id(intersect(high_ss_inds,high_cc_inds));
    tmp_inds = zeros(1,length(pert_id));
    for ii = 1:length(tmp_list)
end