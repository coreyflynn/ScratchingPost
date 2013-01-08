function KD_compare(expNameList,symbolList)
%select input data folders
obsDir = uigetdir(pwd,'Select obs signature folder');
infDir = uigetdir(pwd,'Select inf signature folder');

%select ouput directory
outputDir = uigetdir(pwd,'Select output folder');
if ~isdir([outputDir '/KDreport'])
    mkdir([outputDir '/KDreport']);
end

outputDir = [outputDir '/KDreport'];

%get the contents of the obsserved directory and find those files that are .rnk files
obsDirFileList = dir(obsDir);
infDirFileList = dir(infDir);

indCell = cellfun(@(x)regexp(x,'.rnk'),{obsDirFileList(:).name},'UniformOutput',0);
notEmpties = ~cellfun(@isempty,indCell);
rnkInds = find(notEmpties==1);

%move to the ouput dir
startDir = pwd;
cd(obsDir);

load '/xchip/cogs/cflynn/InferenceEval/U133aGeneSymMap.mat';

fid = fopen(sprintf('%s/index.html',outputDir),'w');
fprintf(fid,'%s\n','<html>');
fprintf(fid,'%s\n','<body>');
fprintf(fid,'%s\n','<h1>Knockdown Comparison Report</h1>');

for ii = 1:length(rnkInds)
    currentFile = obsDirFileList(rnkInds(ii)).name;
    splitString = regexp(currentFile,'_','split');
    expName = regexprep(splitString{end},'.rnk','')
    fprintf(fid,'%s\n',['<h1 id="' expName '">' expName ' Results</h1>']);
    
    if ismember(expName,expNameList) 
        symbolInd = strmatch(expName,expNameList);
        probes = U133aGeneSymMap(symbolList{symbolInd});
    else
        probes = U133aGeneSymMap(expName);
    end
    
    if ~isempty(probes)
        disp('woot');
        cd(obsDir);
        [obsProbes,obsScores] = textread(currentFile,'%s %f');
        [obsScores,oi] = sort(obsScores,'descend');
        obsProbes = obsProbes(oi);

        cd(infDir);        
        [infProbes,infScores] = textread(currentFile,'%s %f');
        [infScores,ii] = sort(infScores,'descend');
        infProbes = infProbes(ii);
        
        %first header row
        fprintf(fid,'%s\n','<table border="1">');
        fprintf(fid,'%s\n','<tr style="background:#909090">');
        fprintf(fid,'%s\n','<td>Probe</td>');
        fprintf(fid,'%s\n','<td>Obs Rank</td>');
        fprintf(fid,'%s\n','<td>Inf Rank</td>');
        fprintf(fid,'%s\n','</tr>');

        for jj = 1:length(probes)
            fprintf(fid,'%s\n','<tr>');
            fprintf(fid,'%s\n',['<td>' probes{jj} '</td>']);
            probeInd = strmatch(probes(jj),obsProbes,'exact');
            fprintf(fid,'%s\n',['<td>' num2str((probeInd)) '</td>']);
            probeInd = strmatch(probes(jj),infProbes,'exact');
            fprintf(fid,'%s\n',['<td>' num2str((probeInd)) '</td>']);
            fprintf(fid,'%s\n','</tr>');
        end
        fprintf(fid,'%s\n','</table>');
        
        %add images
        [pathstr, currentImageName, ext] = fileparts(currentFile);
        currentImageName = [currentImageName '_100.png'];
        fprintf(fid,'%s\n',['<img src="obs' currentImageName '" height=600>']);
        fprintf(fid,'%s\n',['<img src="inf' currentImageName '" height=800>']);
        copyfile(sprintf('%s/%s',obsDir,currentImageName),sprintf('%s/obs%s',outputDir,currentImageName));
        copyfile(sprintf('%s/%s',infDir,currentImageName),sprintf('%s/inf%s',outputDir,currentImageName));
    end
end

%first check for the output directory and create it if it does not exist
if ~isdir(outputDir)
    mkdir(outputDir);
end

fprintf(fid,'%s\n','</body>');
fprintf(fid,'%s\n','</html>');
fclose(fid);

%{

%start building the report
fid = fopen(sprintf('index.html',outputDir),'w');
fprintf(fid,'%s\n','<html>');
fprintf(fid,'%s\n','<body>');
fprintf(fid,'%s\n','<h1>Knockdown Comparison Report</h1>');
fprintf(fid,'%s\n','<ul>');
fprintf(fid,'%s\n','<li><a href="#IP">Input Parameters</a></li>');
fprintf(fid,'%s\n','<li><a href="#CE">Control Experiments</a></li>');
for ii = 1:length(expNameList);
        fprintf(fid,'%s\n',['<li><a href="#' expNameList{ii} '">' expNameList{ii} '</a></li>']);
end
fprintf(fid,'%s\n','</ul>');
fprintf(fid,'%s\n','<h1 id="IP">Input Parameters</h1>');
fprintf(fid,'%s%s%s\n','<p><b>observed file: </b>',obspath,'</p>');
fprintf(fid,'%s%s%s\n','<p><b>inferred file: </b>',infpath,'</p>');
fprintf(fid,'%s%s%s\n','<p><b>Output Location: </b>',outputDir,'</p>');
fprintf(fid,'%s%s%s\n','<p><b>Control Param: </b>',controlName,'</p>');
fprintf(fid,'%s%s%s\n','<p><b>Experiment Param: </b>',sprintf('%s\t',expNameList{:}),'</p>');
fprintf(fid,'%s%s%s\n','<p><b>Symbol Param: </b>',sprintf('%s\t',symbolList{:}),'</p>');
fprintf(fid,'%s\n','<h1 id="CE">Control Experiments</h1>');
controlInds = strmatch(controlName,obs.cdesc(:,1));
controlExps = obs.cdesc(controlInds,1);
fprintf(fid,'%s%s%s\n','<p>',sprintf('%s\t',controlExps{:}),'</p>');

%for each name in expNameList, get the kdmatrix and print it to the html report
for ii = 1:length(expNameList)
    fprintf(fid,'%s\n',['<h1 id="' expNameList{ii} '">' expNameList{ii} ' Results</h1>']);
    obs_res = KD_get_matrix(obs,controlName,expNameList{ii},symbolList{ii});
    inf_res = KD_get_matrix(inf,controlName,expNameList{ii},symbolList{ii});
    for jj = 1:length(obs_res.expid)
        fprintf(fid,'%s\n',['<h2>' obs_res.expid{jj} '</h2>']);
        %first header row
        fprintf(fid,'%s\n','<table border="1">');
        fprintf(fid,'%s\n','<tr style="background:#909090">');
        fprintf(fid,'%s\n','<td>Probe</td>');
        fprintf(fid,'%s\n','<td>Ratio</td>');
        fprintf(fid,'%s\n','<td></td>');
        fprintf(fid,'%s\n','<td>KD Rank</td>');
        fprintf(fid,'%s\n','<td></td>');
        fprintf(fid,'%s\n','<td>Z Score</td>');
        fprintf(fid,'%s\n','<td></td>');
        fprintf(fid,'%s\n','</tr>');
        %second header row
        fprintf(fid,'%s\n','<tr style="background:#C0C0C0">');
        fprintf(fid,'%s\n','<td></td>');
        fprintf(fid,'%s\n','<td>Observed</td>');
        fprintf(fid,'%s\n','<td>Inferred</td>');
        fprintf(fid,'%s\n','<td>Observed</td>');
        fprintf(fid,'%s\n','<td>Inferred</td>');
        fprintf(fid,'%s\n','<td>Observed</td>');
        fprintf(fid,'%s\n','<td>Inferred</td>');
        fprintf(fid,'%s\n','</tr>');
        %data rows
        for kk = 1:length(obs_res.probeid)
            if mod(kk,2)
                fprintf(fid,'%s\n','<tr>');
            else
                fprintf(fid,'%s\n','<tr style="background:#F0F0F0">');
            end
            fprintf(fid,'%s\n',['<td>' obs_res.probeid{kk} '</td>']);
            fprintf(fid,'%s\n',['<td>' num2str(obs_res.mat(1,jj,kk)) '</td>']);
            fprintf(fid,'%s\n',['<td>' num2str(inf_res.mat(1,jj,kk)) '</td>']);
            fprintf(fid,'%s\n',['<td>' num2str(obs_res.mat(2,jj,kk)) '</td>']);
            fprintf(fid,'%s\n',['<td>' num2str(inf_res.mat(2,jj,kk)) '</td>']);
            if obs_res.mat(3,jj,kk) < -1.64
                fprintf(fid,'%s\n',['<td style="background:green">' num2str(obs_res.mat(3,jj,kk)) '</td>']);
            else
                fprintf(fid,'%s\n',['<td>' num2str(obs_res.mat(3,jj,kk)) '</td>']);
            end
            if inf_res.mat(3,jj,kk) < -1.64
                fprintf(fid,'%s\n',['<td style="background:green">' num2str(inf_res.mat(3,jj,kk)) '</td>']);
            else
                fprintf(fid,'%s\n',['<td>' num2str(inf_res.mat(3,jj,kk)) '</td>']);
            end
            fprintf(fid,'%s\n','</tr>');
        end
        fprintf(fid,'%s\n','</table>');
    end
end

fprintf(fid,'%s\n','</body>');
fprintf(fid,'%s\n','</html>');
fclose(fid);

%}
%move back to the startining dir
cd(startDir)
fprintf('output written to %s/index.html\n',outputDir);
