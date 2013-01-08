function CMap_instance_test(rankGct,varargin)
%parse input arguments
pnames = {'queryName','instanceName','exp'};
dflts = {'','',''};
args = parse_args(pnames,dflts,varargin{:});

%if no flags are set, return an error
if strcmp(args.queryName,'') && strcmp(args.instanceName,'') && strcmp(args.exp,'')
    e = MException('CMap_instance_test:NoArguments','Please specify either an exp or queryName and instanceName');
    disp(e.identifier);
    disp(e.message);
    return
elseif ~strcmp(args.queryName,'') && strcmp(args.instanceName,'')
    e = MException('CMap_instance_test:NoInstance','Please specify an instanceName');
    disp(e.identifier);
    disp(e.message);
    return
elseif strcmp(args.queryName,'') && ~strcmp(args.instanceName,'')
    e = MException('CMap_instance_test:NoQuery','Please specify a queryName');
    disp(e.identifier);
    disp(e.message);
    return
end

%make a working folder for output and open an output file
outputDir = mkworkfolder(pwd,'CMap_instance_test');
f = fopen(sprintf('%s/CMap_instance_test_log.txt',outputDir),'w');
f2 = fopen(sprintf('%s/CMap_instance_test_report.txt',outputDir),'w');
fprintf(f,'INPUT PARAMETERS:\n');
fprintf(f,'GCT: %s\n',rankGct.src);
fprintf(f,'queryName: %s\n',args.queryName);
fprintf(f,'instanceName: %s\n',args.instanceName);
fprintf(f,'exp: %s\n',args.exp);

%use the provided exp if present, if not, use the query name and instance name provided
if ~strcmp(args.exp,'')
    fprintf(f,'Using exp: %s\n\n',args.exp);
    [queries, instances] = exp2list(args.exp);
else
    fprintf(f,'Using queryName: %s\n\n',args.queryName);
    fprintf(f,'Using instanceName: %s\n\n',args.instanceName);
    queries = {args.queryName};
    instances = {args.instanceName};
end

%permutation data directory
permDir = '/xchip/cogs/cflynn/InferenceEval/CMap/Build02/';


%if permutedKS exists on the givne permDir, load it.  If not, create it
permPath = [permDir 'permutedKS.mat'];
if exist(permPath) == 2
    fprintf(f,'Using %s/permutedKS.mat for permuted significance estimates\n\n',permDir);
    load(permPath);
else
    permutedKS = zeros(2,500);
end

%start a matlab pool to compute confidence bounds in parallel
if matlabpool('size') == 0
    matlabpool open;
end

%for all query:instance pairs, determine if they are significant
for ii = 1:length(queries)
    %get the current query and instance names
    queryName = queries{ii};
    instanceName = instances{ii};

    % get rank data for the input queryName
    queryInd = strmatch(queryName,rankGct.cid,'exact');
    if isempty(queryInd)
        fprintf('%s::%s No query matching the name "%s" found\n\n',queryName,instanceName, queryName);
        fprintf(f,'%s::%s No query matching the name "%s" found\n\n',queryName,instanceName, queryName);
        continue
    end
    ranks = rankGct.mat(:,queryInd);

    %strip out 'neg=' if it is present in the instance name and trim out leading and trailing whitespace
    instanceNameOrig = instanceName;
    instanceName = regexprep(instanceName,'neg=','');
    instanceName = strtrim(instanceName);
    
    %collapse all occurances of instanceName into one boolean list of entries
    instanceName = regexprep(instanceName,'#','.+');
    indCell = cellfun(@(x)regexpi(x,instanceName),rankGct.rid,'UniformOutput',0);
    notEmpties = ~cellfun(@isempty,indCell);
    instanceInds = find(notEmpties==1);
    if isempty(instanceInds)
        fprintf('%s::%s No instances matching the name "%s" found\n\n',queryName,instanceName, instanceName);
        fprintf(f,'%s::%s No instances matching the name "%s" found\n\n',queryName,instanceName, instanceName);
        continue
    end
    instanceName = instanceNameOrig;

    %compute the CES of the ranked list and the collapsed instanceName list
    classMembers = ranks*0;
    classMembers(instanceInds) = 1;
    [P,score] = CMap_enrichment_score(ranks,classMembers,'rank','true');
    
    %check to see if there is an example permuted score for bound for the size of
    %the current instance list.  If not generate it
    classSize = sum(classMembers);
    if permutedKS(1,classSize) ~= 0
        fprintf(f,'Using precomputed significance bounds\n');
    else 
        fprintf('Computing significance bounds for class size = %i\n',classSize);
        fprintf(f,'Computing significance bounds for class size = %i\n',classSize);
        [lower, upper, scores] = CMap_enrichment_score_confidence(ranks,...
                                                                    'numClassMembers',classSize,...
                                                                    'parclose','false');
        sortedScores = sort(scores);
        permutedLower = sortedScores(50);
        permutedUpper = sortedScores(end-50);
        permutedKS(1,classSize) = permutedLower;
        permutedKS(2,classSize) = permutedUpper;
        save(sprintf('%spermutedKS.mat',permDir),'permutedKS');
        fprintf(f,'Saved updated significance estimates to %s/permutedKS.mat\n',permDir);
    end

    %determine if the instance list CES is significant or not. 
    if score < permutedKS(1,classSize)
        fprintf('%s::%s - SIGNIFICANT NEGATIVE CONNECTION\n\n',queryName,instanceName);
        
        fprintf(f,'%s::%s CES: %g\n',queryName,instanceName, score);
        fprintf(f,'%s::%s Significance Bounds: %g, %g\n',queryName,instanceName,...
                permutedKS(1,classSize),permutedKS(2,classSize));
        fprintf(f,'%s::%s - SIGNIFICANT NEGATIVE CONNECTION\n\n',queryName,instanceName);

        fprintf(f2,'%s::%s\t-1\n',queryName,instanceName);
        
    elseif score > permutedKS(2,classSize)
        fprintf('%s::%s - SIGNIFICANT POSITIVE CONNECTION\n\n',queryName,instanceName);
        
        fprintf(f,'%s::%s CES: %g\n',queryName,instanceName, score);
        fprintf(f,'%s::%s Significance Bounds: %g, %g\n',queryName,instanceName,...
                permutedKS(1,classSize),permutedKS(2,classSize));
        fprintf(f,'%s::%s - SIGNIFICANT POSITIVE CONNECTION\n\n',queryName,instanceName);
        fprintf(f2,'%s::%s\t1\n',queryName,instanceName);
        
    else
        fprintf('%s::%s - NO SIGNIFICANT CONNECTION\n\n',queryName,instanceName);
        
        fprintf(f,'%s::%s CES: %g\n',queryName,instanceName, score);
        fprintf(f,'%s::%s Significance Bounds: %g, %g\n',queryName,instanceName,...
                permutedKS(1,classSize),permutedKS(2,classSize));
        fprintf(f,'%s::%s - NO SIGNIFICANT CONNECTION\n\n',queryName,instanceName);
        fprintf(f2,'%s::%s\t0\n',queryName,instanceName);
        
    end
end

%close the matlab pool
matlabpool close;

%close the output file
fclose(f);
fclose(f2);
