function varargout = sc_plot(ss,cc,varargin)

%parse optional arguments
pnames = {'output','color'};
dflts = {'',[0 0 1]};
args = parse_args(pnames,dflts,varargin{:});

%annotate the graph with percentages for each quadrant
hold on;
high_cc_inds = find(cc >= .25);
low_cc_inds = find(cc < .25);
high_ss_inds = find(ss >= 6);
low_ss_inds = find(ss < 6);

num_inds = length(cc);
bot_left = length(intersect(low_ss_inds,low_cc_inds))/num_inds;
bot_right = length(intersect(low_ss_inds,high_cc_inds))/num_inds;
top_left = length(intersect(high_ss_inds,low_cc_inds))/num_inds;
top_right = length(intersect(high_ss_inds,high_cc_inds))/num_inds;

rectangle('Position',[-1 0 1.25 6],'FaceColor',[1-(1*bot_left) 1 1-(1*bot_left)]);
rectangle('Position',[-1 6 1.25 14],'FaceColor',[1-(1*top_left) 1 1-(1*top_left)]);
rectangle('Position',[.25 0 .75 6],'FaceColor',[1-(1*bot_right) 1 1-(1*bot_right)]);
rectangle('Position',[.25 6 .75 14],'FaceColor',[1-(1*top_right) 1 1-(1*top_right)]);


%plot signature strength against cc
scatter(cc,ss,20,args.color,'filled');

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
title('S-C plot');
xlabel('mean replicate spearman CC');
ylabel('modz signature strength');

hold off;


%handle variable output
if strcmp(args.output,'top_right')
    varargout{1} = pert_id(intersect(high_ss_inds,high_cc_inds));
elseif strcmp(args.output,'all')
    varargout{1} = pert_id;
end