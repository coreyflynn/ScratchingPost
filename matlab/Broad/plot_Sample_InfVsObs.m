function plot_Sample_InfVsObs(inferredStruct,observedStruct,sampleNum)
plot(inferredStruct.mat(:,sampleNum),observedStruct.mat(:,sampleNum),'.');
xlabel('Observed Data');
ylabel('Inferred Data');
title(inferredStruct.cid{sampleNum});