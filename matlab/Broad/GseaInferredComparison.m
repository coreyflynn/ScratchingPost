function GseaInferredComparison(observedGseaFolderFullPath,inferredGseaFolderFullPath,outputDir)
% GSEAINFERREDCOMPARISON compare gsea results for observed and inferred data
%
% GSEAINFERREDCOMPARISON takes two folders assumed to be the output folders from GSEA analysis
% on observed and inferred data, respectively.  The folders are seached for all .html files corresponding
% to the gene sets retrieved in the observed and inferred analyses and a list is built of each.  These 
% lists are then compared and common sets are reported.  Sets found in only one or the other are also
% reported
%
% USAGE:
% GseaInferredComparison(observedGseaFolderFullPath,inferredGseaFolderFullPath) runs the analysis on the given inputs
%
% GseaInferredComparison runs the analysis on the folders selected through a ui
%
% INPUT VARIABLE DEFINITIONS
% observedGseaFolderFullPath: the path to the observed data GSEA analysis
% inferredGseaFolderFullPath: the path to the inferred data GSEA analysis
% outputFolder: the path to the folder in which output will be written
%
% Author: Corey Flynn, Broad Institute 2011

%parse inputs and select files if there are no inputs
if nargin == 0
    observedGseaFolderFullPath = uigetdir(pwd,'Select observed data GSEA report analysis folder');
    inferredGseaFolderFullPath = uigetdir(pwd,'Select inferred data GSEA report analysis folder');
    outputDir = uigetdir(pwd,'Select output folder');
elseif nargin == 3
    observedGseaFolderFullPath = varargin{1};
    inferredGseaFolderFullPath = varargin{2};
    outputDir = varargin{3};
else
    fprintf('USAGE:\n');
    fprintf('GseaInferredComparison(observedGseaFolderFullPath,inferredGseaFolderFullPath)\n');
    fprintf('OR\n');
    fprintf('GseaInferredComparison');
    return;
end

%first check for the output directory and create it if it does not exist
if ~isdir(outputDir)
    mkdir(outputDir);
end

%pull the .html lists from each folder
startDir = pwd;
[path, observedGseaFolderPath, ext] = fileparts(observedGseaFolderFullPath);
observedGseaFolderPath = [observedGseaFolderPath ext];
[path, inferredGseaFolderPath, ext] = fileparts(inferredGseaFolderFullPath);
inferredGseaFolderPath = [inferredGseaFolderPath ext];

cd(observedGseaFolderFullPath);
observedFileList = dir('*.html')
observedFileList = getGeneSetHtmlList(observedFileList);
observedFileList = cellfun(@(x)regexprep(x,'.html',''),observedFileList,'UniformOutput',0);

cd(inferredGseaFolderFullPath);
inferredFileList = dir('*.html');
inferredFileList = getGeneSetHtmlList(inferredFileList);
inferredFileList = cellfun(@(x)regexprep(x,'.html',''),inferredFileList,'UniformOutput',0);

cd(startDir);

%find the .html files that are in both lists as well as those that are only in each set
[commonFileList, observedFileInds, inferredFileInds] = intersect_ord(observedFileList,inferredFileList);
observedOnlyFileList = setdiff(observedFileList,commonFileList);
inferredOnlyFileList = setdiff(inferredFileList,commonFileList);


%compute basic stats about the comparison
numCommonSets = length(commonFileList);
percentCommonSets = numCommonSets/length(observedFileList)*100;
numObserverdOnlySets = length(observedOnlyFileList);
numInferredOnlySets = length(inferredOnlyFileList);


%write a .tex and .pdf report of the analysis
    %write header
fid = fopen(sprintf('%s/Gsea_comparison_report.tex',outputDir),'w');
tex_Includes(fid);
spacedOutputDirString = dashAndSpaceIt(outputDir);
tex_title_author_date(fid,horzcat(spacedOutputDirString,' GSEA inference Comparison report}'),'CMap');

    %write parameters used
tex_line(fid,'\section{GSEA Inference Comparison Parameters}');
spacedObservedFolderPath = dashAndSpaceIt(observedGseaFolderFullPath);
spacedInferredFolderPath = dashAndSpaceIt(inferredGseaFolderFullPath);
tex_line(fid,horzcat('Observed data GSEA folder = ',spacedObservedFolderPath));
tex_line(fid,horzcat('Inferred data GSEA folder = ',spacedInferredFolderPath));

    %write the summary data
tex_line(fid,'\section{GSEA Gene Set Comparison Summary}');
tex_line(fid,horzcat('Top ',num2str(length(observedFileList)), ' genes sets considered from GSEA reports'));
tex_line(fid,horzcat('Number of gene sets in common = ', num2str(numCommonSets)));
tex_line(fid,horzcat('Percentage of gene sets in common = ', num2str(percentCommonSets)));
tex_line(fid,horzcat('Number of gene sets in observed data only = ', num2str(numObserverdOnlySets)));
tex_line(fid,horzcat('Number of gene sets in inferred data only = ', num2str(numInferredOnlySets)));

    %write the gene lists
tex_line(fid,'\section{Common Gene Sets}');
for ii =1:numCommonSets
    tex_line(fid,dashit(commonFileList{ii}));
end
tex_line(fid,'\clearpage');

tex_line(fid,'\section{Observed Only Gene Sets}');
for ii =1:numObserverdOnlySets
    tex_line(fid,[dashit(observedOnlyFileList{ii})]);
end
tex_line(fid,'\clearpage');

tex_line(fid,'\section{Infferred Only Gene Sets}');
for ii =1:numInferredOnlySets
    tex_line(fid,dashit(inferredOnlyFileList{ii}));
end
tex_line(fid,'\clearpage');
  
%{
    %write the m-file used
thisFilePath = which('GseaInferredComparison');
[path,name,ext] = fileparts(thisFilePath);
tex_line(fid,'\clearpage');
tex_line(fid,'\section{Code Used}');
tex_line(fid,horzcat('\subsection{',name,ext,'}'));
tex_line(fid,horzcat('\lstinputlisting{',thisFilePath,'}'));
%}
    
    %close the document and compile it
fprintf(fid,'%s\n','\end{document}');
fclose(fid);
pdflatex(sprintf('%s/Gsea_comparison_report.tex',outputDir),'cleanup',1);



function geneSetHtmlList = getGeneSetHtmlList(fileList)
%utility function used to pull all capitalized files out of the .html list provided.  This is used
%because all GSEA .html files corresponding to sets are capitalized and others are not.
indCell = cellfun(@(x)regexp(x,'^[A-Z]'),{fileList(:).name},'UniformOutput',0);
notEmpties = ~cellfun(@isempty,indCell);
geneSetHtmlList = {fileList(notEmpties).name};

function outputString = dashAndSpaceIt(inputString)
%utility function to dash and spce the given input string to avoind unblocken tex strings
dashedString = dashit(inputString);
outputString = regexprep(dashedString,'/','/ ');
