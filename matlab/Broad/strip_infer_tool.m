function strip_infer_tool(varargin)


%parse optional arguments
pnames = {'res','o','model'};
dflts = {'','','subset_models/mlr10k_00_epsilon_978.mat'};
args = parse_args(pnames,dflts,varargin{:});

%select files if there are no inputs
if strcmp(args.res,'') == 1
    [gctFile,gctPath] = uigetfile([pwd '/*.gct'],'Select observed data gct file');
    inputGCT = [gctPath gctFile];
else
    inputGCT = args.res;
end
if strcmp(args.o,'') == 1 
    outputDir = uigetdir(pwd,'Select output folder');
else
    outputDir = args.o;
end
%set default figure visability to 'off'
set(0, 'DefaultFigureVisible', 'off');

%define the base inference path
inferencePath = '/xchip/cogs/data/models/';

%first check for the output directory and create it if it does not exist
if ~isdir(outputDir)
    mkdir(outputDir);
end

%check for a data directory in the ouput directory. If it doesn't exist, create
%it
if ~isdir([outputDir '/data'])
    mkdir([outputDir '/data']);
end


%define the base output name for all files in the analysis and grab a list of all files in the 
%output folder for later use,
baseName = getGCTBaseName(inputGCT);
outputDirFileList = dir([outputDir '/data']);

%check to see if the input has already been stripped down to the appropriate probes set space
%for our inference model.  If not, create the stripped down .gct file
if ~isFilePiece(sprintf('%s_A',baseName),outputDirFileList)
    disp(sprintf('%s/data/%s_A* not found, building it now...',outputDir,baseName));
    filteredStruct = filter_probes(inputGCT,[inferencePath 'probe_lists/U133A.grp']);
    mkgct(sprintf('%s/data/%s_A',outputDir,baseName),filteredStruct);
else
    disp(sprintf('%s/data/%s_A* found, using it for further analysis...',outputDir,baseName));
end


%check to see if the input had already been filtered down to the L probes.  If it has not,
%create the L .gct file. 
outputDirFileList = dir([outputDir '/data']); % update the output directory file list
if ~isFilePiece(sprintf('%s_L',baseName),outputDirFileList)
    disp(sprintf('%s/data/%s_L* not found, building it now...',outputDir,baseName));
    filteredStruct = filter_probes(inputGCT,[inferencePath 'probe_lists/lm_epsilon5253_978.grp']);
    %filteredStruct = filter_probes(inputGCT,[inferencePath 'ilumina_Ls_probes_n921.grp']);
    mkgct(sprintf('%s/data/%s_L',outputDir,baseName),filteredStruct);
else
    disp(sprintf('%s/data/%s_L* found, using it for further analysis...',outputDir,baseName));
end

%check to see if the inference model has been run on the L data.  If it has not, run the
%inference and create the resulting inference .gct file.
outputDirFileList = dir([outputDir '/data']); % update the output directory file list
if ~isFilePiece(sprintf('%s_L_INF_',baseName),outputDirFileList)
    disp(sprintf('%s/data/%s_L_INF_* not found, building it now...',outputDir,baseName));
    resFileName = fullFileFromPiece(sprintf('%s_L_n',baseName),outputDirFileList)
    infer_tool ('res', sprintf('%s/data/%s',outputDir,resFileName)...
                , 'model', [inferencePath args.model]...
                , 'out', sprintf('%s',['' outputDir '/data' '']));
    %infer_tool ('res', sprintf('%s/data/%s',outputDir,resFileName)...
    %            , 'model', [inferencePath 'mlr12k_ilmn_921/mlr12k_ilmn_921.mat']...
    %            , 'out', sprintf('%s',['' outputDir '/data' '']));                
else
    disp(sprintf('%s/data/%s_L_INF* found, using it for further analysis...',outputDir,baseName));
    resFileName = fullFileFromPiece(sprintf('%s_L_n',baseName),outputDirFileList);
end

%BEGIN UTILITY FUNCTIONS

function gctName = getGCTBaseName(pathToGCT)
%utility function to strip off the _nXXXxXXX.gct file ending as well as any the path leading up
%to the file name of a given .gct file
extenstionInd = regexp(pathToGCT,'_n');
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
