function ListBasedMontiLymphomaAnalysis(ObservedData_gct,InferredData_gct,geneList_grp,output_path)
% This function inputs an observed and inferred data set based on the CMap inference model and
% computes the optimal number of clusters in the data over the measured samples(patients) as well
% as computing various metrics about the aggrement of the clusters based on the observed data, 
% inferred data, and landmark data.

%first grab the input data from the observed and inferred .gct files.
ObservedData = parse_gct(ObservedData_gct);
InferredData = parse_gct(InferredData_gct);

%filter the input data sets by the specified gene list
geneList = parse_grp(geneList_grp);
filteredObservedData = filter_probes(ObservedData,geneList);
filteredInferredData = filter_probes(InferredData,geneList);

%check to see if the output directory exists.  If it does not, create it
if isdir(output_path) == 0
	mkdir(output_path)
end

%write the names and dataset generated to file
observedPrefix = strtok(ObservedData_gct,'.');
inferredPrefix = strtok(InferredData_gct,'.');
mkgct(sprintf('%s/%s_varFiltered.gct',output_path...
    ,observedPrefix),filteredObservedData);
mkgct(sprintf('%s/%s_varFiltered.gct',output_path...
    ,inferredPrefix),filteredInferredData);
    
%use concensus clustering to form clusters on the samples given the variable genes selected for analysis 
clusterSpace = 4;
[observedM,observedT,observedZ,observedMk,observedNumClusters] = conclust(transpose(...
    filteredObservedData.mat),clusterSpace);
[inferredM,inferredT,inferredZ,inferredMk,inferredNumClusters] = conclust(transpose(...
    filteredInferredData.mat),clusterSpace);

%reorder the M matrices to highlight data clusters, display them, and save them to file
observedMreordered = reorder_M(observedM,cluster_label_shuffle(observedT));
inferredMreordered = reorder_M(inferredM,cluster_label_shuffle(inferredT));

map=ones(64,3);
map(:,2) = transpose(([64:-1:1]/64));
map(:,3) = transpose(([64:-1:1]/64));

figure;imagesc(observedMreordered);title(sprintf('Observed data clustering, %i clusters', observedNumClusters));
colormap(map);drawnow;
print(sprintf('%s/observed_ConClust.png',output_path),'-dpng');
close(gcf);
figure;imagesc(inferredMreordered);title(sprintf('Inferred data clustering, %i clusters', inferredNumClusters));
colormap(map);drawnow;
print(sprintf('%s/inferred_ConClust.png',output_path),'-dpng');
close(gcf);

%save a structure with the consensus clustering results for the observed
%and inferred data
observedConClust.M = observedM;
observedConClust.T = observedT;
observedConClust.Z = observedZ;
observedConClust.Mk = observedMk;
observedConClust.NumClusters = observedNumClusters;

inferredConClust.M = inferredM;
inferredConClust.T = inferredT;
inferredConClust.Z = inferredZ;
inferredConClust.Mk = inferredMk;
inferredConClust.NumClusters = inferredNumClusters;

save(sprintf('%s/%s_ConClust.mat',output_path...
    ,ObservedData_gct),'observedConClust');
save(sprintf('%s/%s_ConClust.mat',output_path...
    ,InferredData_gct),'inferredConClust');
    
%save a .tex and pdf report
    %write header
fid = fopen(sprintf('%s/%s_report.tex',output_path,dashit(ObservedData_gct)),'w');
texIncludes(fid);
texTitleAuthorDate(fid,horzcat(output_path,' Sample Clustering report}'),'CMap');

    %write parameters
texLine(fid,'\section{Sample Clusting}');
texLine(fid,horzcat('probe set space = ',dashit(geneList_grp)));
texLine(fid,horzcat('clustering method = mkeans'));
texLine(fid,horzcat('cluster space explored  = ',num2str(clusterSpace(1)),...
        ' to ',num2str(clusterSpace(end))));

    %write sample cluster report

texFig(fid,'inferred_ConClust.png','Inferred Clusters');
texFig(fid,'observed_ConClust.png','Observed Clusters');
    
    %write the m-file used
thisFilePath = which('VarianceBasedMontiLymphomaAnalysis');
[path,name,ext] = fileparts(thisFilePath);
texLine(fid,'\clearpage');
texLine(fid,'\section{Code Used}');
texLine(fid,horzcat('\subsection{',name,ext,'}'));
texLine(fid,horzcat('\lstinputlisting{',thisFilePath,'}'));

    %close the document and compile it
fprintf(fid,'%s\n','\end{document}');
fclose(fid);
pdflatex(sprintf('%s/%s_report.tex',output_path,output_path),'cleanup',1);

%save a .csv file with all of the observed and inferred expressions
fid = fopen(sprintf('%s/clusterLabels.csv',output_path),'w');
fprintf(fid,'Sample description,Observed Cluster,Inferred Cluster\n');
for ii = 1:length(filteredObservedData.cid)
    fprintf(fid,sprintf('%s, %i, %i\n',filteredObservedData.cid{ii},observedConClust.T(ii),inferredConClust.T(ii)));
end
fclose(fid);