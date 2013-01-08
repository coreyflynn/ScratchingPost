function plot_geneSet_range(referenceSetStruct,comparisonSetStruct,range_begin, range_end)
%plot the specified range of genes from the referenceSetStruct and plot them against the matching genes in comparisonSetStruct using scatter plots

num_plots = range_end-range_begin;
figure;
for ii = 0:num_plots
    %find the index of the matching gene in comparisonSetStruct
    ind = strmatch(referenceSetStruct.rid(range_begin+ii),comparisonSetStruct.rid);
    subplot(num_plots5,5,ii+1);
    plot(referenceSetStruct.mat(range_begin+ii,:), comparisonSetStruct.mat(ind,:),'.');
    title(sprintf('%s',referenceSetStruct.rid{range_begin+ii}));
drawnow;
end