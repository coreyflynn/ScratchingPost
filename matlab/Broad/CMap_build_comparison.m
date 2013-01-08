function [query1Result,query2Result] =  CMap_build_comparison(varargin);

%looks at the query matrix from two CMap builds and finds instance classes that are significantly
%up or down regulated in either build and both builds

%TODO
%parameters output file
%report generation 
%header comments
%query level comparison

%parse inputs and select input files if there are none
if nargin == 0
    [gctFile,gctPath] = uigetfile([pwd '/*.gct'],'Select query1 gct file');
    query1 = [gctPath gctFile]
    [gctFile,gctPath] = uigetfile([pwd '/*.gct'],'Select query2 gct file');
    query2 = [gctPath gctFile]
    outputDir = uigetdir(pwd,'Select output folder');
elseif nargin == 3
    query1= varargin{1};
    query2= varargin{2};
    outputDir = varargin{3};
else
    fprintf('USAGE:\n');
    fprintf('CMap_build_comparison(query1,query2,outputDir)\n');
    fprintf('OR\n');
    fprintf('CMap_build_comparison\n');
    return;
end

%first check for the output directory and create it if it does not exist
if ~isdir(outputDir)
    mkdir(outputDir);
end

%check for data, figures, and report directories in the ouput directory. If they don't exist, crate
%them
if ~isdir([outputDir '/data'])
    mkdir([outputDir '/data']);
end
if ~isdir([outputDir '/figures'])
    mkdir([outputDir '/figures']);
end
if ~isdir([outputDir '/report'])
    mkdir([outputDir '/report']);
end
%define the base output name for all files in the analysis and grab a list of all files in the 
%output folder for later use,
baseName = getGCTBaseName(query1);
query1path = query1;
query2path = query2;
query1 = parse_gct(query1);
query2 = parse_gct(query2);
outputDirFileList = dir([outputDir '/data']);

% compute the score as well as the upper and lower confidence bounds for each query if it has not
% already been done
if ~isFilePiece(sprintf('%s_query1CES.mat',baseName),outputDirFileList)
    disp(sprintf('%s/data/%s_query1CES.mat not found, building it now...',outputDir,baseName));
    [query1Result.CES, query1Result.lowerConfidence, query1Result.upperConfidence] =  CMap_query_matrix(query1);
    drugClassInd = strmatch('drug_class',query1.rhd);
    query1Result.rids = unique(query1.rdesc(:,drugClassInd));
    query1Result.cids = query1.cid;
    save(sprintf('%s/data/%s_query1CES.mat',outputDir,baseName),'query1Result');
else
    disp(sprintf('%s/data/%s_query1CES.mat found, using it for further analysis...',outputDir,baseName));
    load(sprintf('%s/data/%s_query1CES.mat',outputDir,baseName));
end

if ~isFilePiece(sprintf('%s_query2CES.mat',baseName),outputDirFileList)
    disp(sprintf('%s/data/%s_query2CES.mat not found, building it now...',outputDir,baseName));
    [query2Result.CES, query2Result.lowerConfidence, query2Result.upperConfidence] =  CMap_query_matrix(query2);
    drugClassInd = strmatch('drug_class',query2.rhd);
    query2Result.rids = unique(query2.rdesc(:,drugClassInd));
    query2Result.cids = query2.cid;
    save(sprintf('%s/data/%s_query2CES.mat',outputDir,baseName),'query2Result');
else
    disp(sprintf('%s/data/%s_query2CES.mat found, using it for further analysis...',outputDir,baseName));
    load(sprintf('%s/data/%s_query2CES.mat',outputDir,baseName));
end

%find those CES that are significantly positive or negative
query1PosCES = find(query1Result.CES>query1Result.upperConfidence);
query1negCES = find(query1Result.CES<query1Result.lowerConfidence);

query2PosCES = find(query2Result.CES>query2Result.upperConfidence);
query2negCES = find(query2Result.CES<query2Result.lowerConfidence);

%remove whitespace from .cids fields
for ii = 1:length(query1Result.cids)
    s = query1Result.cids{ii};
    query1Result.cids{ii} = regexprep(s,'[^\w'']','');
    s = query2Result.cids{ii};
    query2Result.cids{ii} = regexprep(s,'[^\w'']','');
end
    

%begin constructing and output report
fid = fopen(sprintf('%s/report/index.html',outputDir),'w');
fprintf(fid,'%s\n','<html>');
fprintf(fid,'%s\n','<body>');
fprintf(fid,'%s\n','<h1>Query Comparison Report</h1>');
fprintf(fid,'%s\n','<ul>');
fprintf(fid,'%s\n','<li><a href="#IP">Input Parameters</a></li>');
fprintf(fid,'%s\n','<li><a href="#HMS">Heat Map Summary</a></li>');
for ii = 1:length(query1Result.cids);
        fprintf(fid,'%s\n',['<li><a href="#' query1Result.cids{ii} '">' query1Result.cids{ii} '</a></li>']);
end
fprintf(fid,'%s\n','</ul>');
fprintf(fid,'%s\n','<h1 id="IP">Input Parameters</h1>');
fprintf(fid,'%s%s%s\n','<p><b>Query 1 File: </b>',query1path,'</p>');
fprintf(fid,'%s%s%s\n','<p><b>Query 2 File: </b>',query2path,'</p>');
fprintf(fid,'%s%s%s\n','<p><b>Output Location: </b>',outputDir,'</p>');

%create heatmaps for the queries
drugClassInd = strmatch('drug_class',query1.rhd);
query1HeatMap = HeatMap(query1Result.CES);
set(query1HeatMap,'RowLabels',unique(query1.rdesc(:,drugClassInd)));
set(query1HeatMap,'ColumnLabels',query1.cid);
addTitle(query1HeatMap,'Query 1 Heat Map');

drugClassInd = strmatch('drug_class',query2.rhd);
query2HeatMap = HeatMap(query2Result.CES);
set(query2HeatMap,'RowLabels',unique(query2.rdesc(:,drugClassInd)));
set(query2HeatMap,'ColumnLabels',query2.cid);
addTitle(query2HeatMap,'Query 2 Heat Map');

fig = figure;
plot(query1HeatMap,fig);
set(gcf,'Color','w');
export_fig(sprintf('%s/figures/%s_query1HeatMap.png',outputDir,baseName),'-png');
close(fig);

fig = figure;
plot(query2HeatMap,fig);
set(gcf,'Color','w');
export_fig(sprintf('%s/figures/%s_query2HeatMap.png',outputDir,baseName),'-png');
close(fig);

close all hidden;

%create content for the heat maps in the html report
fprintf(fid,'%s\n','<h1 id="HMS">Heat Map Summary</h1>');
figureFile = sprintf('../figures/%s_query1HeatMap.png',baseName);
fprintf(fid,'%s\n',['<img src="' figureFile '" width="500" height="500" />']);
figureFile = sprintf('../figures/%s_query2HeatMap.png',baseName);
fprintf(fid,'%s\n',['<img src="' figureFile '" width="500" height="500" />']);
fprintf(fid,'%s\n','</body>');
fprintf(fid,'%s\n','</html>');


%create paired bar plots for all instance classes

f = figure('Position',[0 0 200 500]);
for ii = 1:length(query1Result.cids);
    for jj = 1:length(query1Result.rids);
    labels = zeros(1,length(query1.mat(:,ii)));
    classMembers = strmatch(query1Result.rids{jj},query1.rdesc(:,drugClassInd));
    labels(classMembers) = 1;
    subplot(1,2,1); CMap_bar_plot(query1.mat(:,ii),labels); 

    
    labels = zeros(1,length(query1.mat(:,ii)));
    classMembers = strmatch(query2Result.rids{jj},query2.rdesc(:,drugClassInd));
    labels(classMembers) = 1;
    subplot(1,2,2); CMap_bar_plot(query2.mat(:,ii),labels); 

    
    drawnow;
    export_fig(sprintf('%s/figures/%s_%s_%s.png',outputDir,baseName,...
                        query1Result.cids{ii},query1Result.rids{jj}),'-png');
    end
end
close(f);

%{
%create biographs for each query
bgs = {}
for ii = 1:length(query1Result.cids);
    try
        eval(sprintf('[bg%i, bgHandle] = CMap_bioGraph(query1Result,%i,.4);',ii,ii));
        eval(sprintf('bgs = horzcat(bgs,{bg%i});',ii));
        fileString = sprintf('%s/figures/%s_%s_graph.png',outputDir,query1Result.cids{ii},'query1');
        export_fig(bgHandle,fileString,'-png');
        close(bgHandle);
    catch E
        close all hidden;
        disp(E.message);
    end
end
[bg, bgHandle] = mergeBioGraph(bgs);
fileString = sprintf('%s/figures/%s_graphMerge.png',outputDir,'query1');
export_fig(bgHandle,fileString,'-png');
close(bgHandle);

bgs = {}
for ii = 1:length(query2Result.cids);
    try
        eval(sprintf('[bg%i, bgHandle] = CMap_bioGraph(query2Result,%i,.4);',ii,ii));
        eval(sprintf('bgs = horzcat(bgs,{bg%i});',ii));
        fileString = sprintf('%s/figures/%s_%s_graph.png',outputDir,query2Result.cids{ii},'query2');
        export_fig(bgHandle,fileString,'-png');
        close(bgHandle);
    catch E
        close all hidden;
        disp(E.message);
    end
end
[bg, bgHandle] = mergeBioGraph(bgs);
fileString = sprintf('%s/figures/%s_graphMerge.png',outputDir,'query2');
export_fig(bgHandle,fileString,'-png');
close(bgHandle);
%}

%write biographs to frames in the report
%create content for the heat maps in the html report
fprintf(fid,'%s\n','<h1>Connectivity Graphs</h1>');
for ii = 1:length(query2Result.cids);
    fprintf(fid,'%s\n',['<p id="' query1Result.cids{ii} '"><b>' query1Result.cids{ii} '</b></p>']);
    fprintf(fid,'%s\n','<table border="1">');
    fprintf(fid,'%s\n','<tr style="background:gray">');
    fprintf(fid,'%s\n','<td>Query 1 Instance Class</td>');
    fprintf(fid,'%s\n','<td>Query 1 CES</td>');
    fprintf(fid,'%s\n','<td style="background:gray"> </td>');
    fprintf(fid,'%s\n','<td>Query 2 Instance Class</td>');
    fprintf(fid,'%s\n','<td>Query 2 CES</td>');
    fprintf(fid,'%s\n','</tr>');
    [s1,ind1] = sort(query1Result.CES(:,ii),'descend');
    [s2,ind2] = sort(query2Result.CES(:,ii),'descend');
    for jj = 1:length(query1Result.rids)
        fprintf(fid,'%s\n','<tr>');
        if query1Result.CES(ind1(jj),ii) > query1Result.upperConfidence(ind1(jj),ii)
            fprintf(fid,'%s\n',['<td style="background:green">' query1Result.rids{ind1(jj)} '</td>']);
            fprintf(fid,'%s\n',['<td style="background:green">'  num2str(query1Result.CES(ind1(jj),ii)) '</td>']);
        elseif query1Result.CES(ind1(jj),ii) < query1Result.lowerConfidence(ind1(jj),ii)
            fprintf(fid,'%s\n',['<td style="background:red">' query1Result.rids{ind1(jj)} '</td>']);
            fprintf(fid,'%s\n',['<td style="background:red">'  num2str(query1Result.CES(ind1(jj),ii)) '</td>']);
        else
            fprintf(fid,'%s\n',['<td>' query1Result.rids{ind1(jj)} '</td>']);
            fprintf(fid,'%s\n',['<td>'  num2str(query1Result.CES(ind1(jj),ii)) '</td>']);
        end
        fprintf(fid,'%s\n','<td style="background:gray"> </td>');
        if query2Result.CES(ind2(jj),ii) > query2Result.upperConfidence(ind2(jj),ii)
            fprintf(fid,'%s\n',['<td style="background:green">' query1Result.rids{ind2(jj)} '</td>']);
            fprintf(fid,'%s\n',['<td style="background:green">'  num2str(query2Result.CES(ind2(jj),ii)) '</td>']);
        elseif query2Result.CES(ind2(jj),ii) < query2Result.lowerConfidence(ind2(jj),ii)
            fprintf(fid,'%s\n',['<td style="background:red">' query1Result.rids{ind2(jj)} '</td>']);
            fprintf(fid,'%s\n',['<td style="background:red">'  num2str(query2Result.CES(ind2(jj),ii)) '</td>']);
        else
            fprintf(fid,'%s\n',['<td>' query1Result.rids{ind2(jj)} '</td>']);
            fprintf(fid,'%s\n',['<td>'  num2str(query2Result.CES(ind2(jj),ii)) '</td>']);
        end
        fprintf(fid,'%s\n','</tr>');
    end
    fprintf(fid,'%s\n','</table>');
    
    fprintf(fid,'%s\n','<table border="1">');
    fprintf(fid,'%s\n','<tr style="background:gray">');
    for jj = 1:length(query1Result.rids)
        fprintf(fid,'%s\n',['<td>' query1Result.rids{jj} '</td>']);
    end
    fprintf(fid,'%s\n','</tr>');
    fprintf(fid,'%s\n','<tr>');
    for jj = 1:length(query1Result.rids)
        figureFile = sprintf('../figures/%s_%s_%s.png',baseName,...
                        query1Result.cids{ii},query1Result.rids{jj});
        
        fprintf(fid,'%s\n',['<td><img src="' figureFile '"/></td>']);
    end
    fprintf(fid,'%s\n','</tr>');
    fprintf(fid,'%s\n','</table>');
    
    %{
    figureFile1 = sprintf('../figures/%s_%s_graph.png',query1Result.cids{ii},'query1');
    figureFile2 = sprintf('../figures/%s_%s_graph.png',query1Result.cids{ii},'query2');
    if exist(sprintf('%s/figures/%s_%s_graph.png',outputDir,query1Result.cids{ii},'query1')) == 2 &&...
        exist(sprintf('%s/figures/%s_%s_graph.png',outputDir,query2Result.cids{ii},'query2')) == 2
            fprintf(fid,'%s\n',['<img src="' figureFile1 '"/>']);
            fprintf(fid,'%s\n',['<img src="' figureFile2 '"/>']);
    end
    %}
end

fprintf(fid,'%s\n','</body>');
fprintf(fid,'%s\n','</html>');
fclose(fid);



%BEGIN UTILITY FUNCITONS
function gctName = getGCTBaseName(pathToGCT)
%utility function to strip off the _nXXXxXXX.gct file ending as well as any the path leading up
%to the file name of a given .gct file
extenstionInd = regexp(pathToGCT,'_n\d\d');
baseString = pathToGCT(1:extenstionInd-1);
[gctPath,gctName,gctExt] = fileparts(baseString);

function pieceFlag = isFilePiece(filePieceString,fileList)
%utility funciton to determine the existance of a file from a piece of its name in the given file list
indCell = cellfun(@(x)regexp(x,filePieceString),{fileList(:).name},'UniformOutput',0);
if isempty(cell2mat(indCell))
    pieceFlag = 0;
else
    pieceFlag = 1;
end

function fileString = fullFileFromPiece(filePieceString,fileList)
%utility funciton to return a full file name from a piece of its name in the given file list
indCell = cellfun(@(x)regexp(x,filePieceString),{fileList(:).name},'UniformOutput',0);
notEmpties = ~cellfun(@isempty,indCell);
fileInd = find(notEmpties==1,1);
fileString = fileList(fileInd).name;

function twoFigureFrame(fid,title,figureFile1,figureFile2,size)
fprintf(fid,'%s\n',horzcat('\begin{frame}{',title,'}'));
fprintf(fid,'%s\n','\begin{center}');
fprintf(fid,'%s\n',horzcat('\includegraphics[width=',size,'\textwidth]{',figureFile1, '}'));
fprintf(fid,'%s\n',horzcat('\includegraphics[width=',size,'\textwidth]{',figureFile2, '}'));
fprintf(fid,'%s\n','\end{center}');
fprintf(fid,'%s\n','\end{frame}');