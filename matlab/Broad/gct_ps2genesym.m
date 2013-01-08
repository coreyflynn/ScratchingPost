function gct_ps2genesym(inputGCT,outputGCT)
% GCT_GENESYM2PS converts a .gct file with probe names as the gene names to one with gene symbols
% as the gene names
%
% GCT_GENESYM2PS takes a path to a gct file as input and converts that input file from one with the
% the gene names as probe names to one with gene symbols as gene names.  This funciton assumes that
% probeset is taken from Affymetrix U133A chip.  
%
% USAGE:
% gct_genesym2ps(inputGCT,outputGCT)
%
% INPUT VARIABLE DEFINITIONS
% inputGCT: the path to the .gct file to be operated on
% outputGCT: the path to the .gct file to be written
%
% Author: Corey Flynn, Broad Institute 2011

%first load the .gct file and pull the list of gene symbols that appear in it
inputGCTdata = parse_gct(inputGCT);
inputProbeSets = inputGCTdata.rid;

%form a container to hold the probe sets as a keys and the observed probe data as values 
fprintf('building probe set to expression mapping...\n');
probeKeyToExpressionMapping = containers.Map();
for ii = 1:length(inputProbeSets)
    probeKeyToExpressionMapping(inputProbeSets{ii}) = inputGCTdata.mat(ii,:);
end

%load U133A probe to gene symbol mapping container
load('/xchip/cogs/cflynn/InferenceEval/U133AProbeKeyToGeneSymMapping.mat');

%form a container to hold the gene sets as keys and the observed probe data as values.  For
%repeat gene symbols, take the average of the probe data for all occurances of the gene symbol
fprintf('building gene symbol to expression mapping...\n');
geneSymKeyToExpressionMapping = containers.Map();
probeFoundCount = 0;
probeNotFoundCount = 0;
for ii = 1:length(inputProbeSets)
    try
        currentExpression = values(probeKeyToExpressionMapping,{inputProbeSets{ii}});
        currentGeneSymbol = values(U133AProbeKeyToGeneSymMapping,{inputProbeSets{ii}});
        if isKey(geneSymKeyToExpressionMapping,currentGeneSymbol)
            currentGeneSymbolValue = values(geneSymKeyToExpressionMapping,currentGeneSymbol);
            currentExpression{1} = mean([currentExpression{:};currentGeneSymbolValue{:}]);
        end
        geneSymKeyToExpressionMapping(currentGeneSymbol{:}) = currentExpression{:};
        probeFoundCount = probeFoundCount + 1;
    catch E
        %disp(E)
        probeNotFoundCount = probeNotFoundCount + 1;
    end
end

%display mapping information
fprintf(['found ' num2str(geneSymKeyToExpressionMapping.Count) ' gene symbols from '...
            num2str(probeFoundCount) ' probes\n']);
fprintf(['failed to find mappings for ' num2str(probeNotFoundCount) ' probes\n']);

%format the gct file and write it to disk
geneSyms = keys(geneSymKeyToExpressionMapping);
outputGCTdata = inputGCTdata;
outputGCTdata.rid = geneSyms;
outputGCTdata.mat = zeros(length(geneSyms),length(outputGCTdata.cid));
for ii = 1:length(geneSyms)
    currentExpression = values(geneSymKeyToExpressionMapping,{geneSyms{ii}});
    outputGCTdata.mat(ii,:) = currentExpression{:};
end

mkgct(outputGCT,outputGCTdata);
    