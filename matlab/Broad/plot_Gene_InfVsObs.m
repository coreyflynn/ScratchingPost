function plot_Gene_InfVsObs(inferredStruct,observedStruct,geneNum)
plot(inferredStruct.mat(geneNum,:),observedStruct.mat(geneNum,:),'.');
xlabel('Observed Data');
ylabel('Inferred Data');
title(inferredStruct.rid{geneNum});