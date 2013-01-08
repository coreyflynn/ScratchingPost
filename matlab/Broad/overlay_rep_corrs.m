function overlay_rep_corrs(rep_corrs,color)
%simple function to draw vertical lines on top of a correlation histogram based on inputs
hold on;
for ii = 1:length(rep_corrs)
    plot([rep_corrs(ii) rep_corrs(ii)],[0 1],color,'LineWidth',3)
end
hold off;