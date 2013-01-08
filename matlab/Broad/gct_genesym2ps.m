function gct_genesym2ps(inputGCT,outputGCT)
% GCT_GENESYM2PS converts a .gct file with gene symbols as the gene names to one with probe names
% as the gene names
%
% GCT_GENESYM2PS takes a path to a gct file as input and converts that input file from one with the
% the gene names as gene symbols to one with probesets as gene names.  This funciton assumes that
% probeset is taken from Affymetrix U133A chip. Once the function is finished, it writes a the
% new .gct file to outputGCT 
%
% USAGE:
% gct_genesym2ps(inputGCT,outputGCT)
%
% INPUT VARIABLE DEFINITIONS
% inputGCT: the path to the .gct file to be operated on
% outputGCT: the path to the .gct file to write
%
% Author: Corey Flynn, Broad Institute 2011

%first load the .gct file and pull the list of gene symbols that appear in it
inputGCTdata = parse_gct(inputGCT);
inputGeneSymbols = inputGCTdata.rid;

%form a container to hold the gene symbols as a keys and the observed data as values 
fprintf('building gene symbol to expression mapping...\n');
geneSymbolKeyToExpressionMapping = containers.Map();
for ii = 1:length(inputGeneSymbols)
    geneSymbolKeyToExpressionMapping(inputGeneSymbols{ii}) = inputGCTdata.mat(ii,:);
end

%load U133A gene symbol to probe set mapping container
load('/xchip/cogs/cflynn/InferenceEval/U133AGeneSymKeyToProbeMapping.mat');

%form a container to hold the probe sets as keys and the observed gene symbol data as values.  For
%repeat gene symbols, take the average of the probe data for all occurances of the gene symbol

fprintf('building probe set to expression mapping...\n');
probeKeyToExpressionMapping = containers.Map();
descriptionList = {};
geneSymbolFoundCount = 0;
geneSymbolNotFoundCount = 0;
descriptioniter = 1;
originalDescriptionList = inputGCTdata.gd.values(inputGCTdata.gd.keys);
originalDescriptionList = originalDescriptionList{:};
for ii = 1:length(inputGeneSymbols)
    try
        currentExpression = values(geneSymbolKeyToExpressionMapping,inputGeneSymbols(ii));
        currentProbes = values(U133AGeneSymKeyToProbeMapping,inputGeneSymbols(ii));
        currentProbes = currentProbes{:};
        if iscell(currentProbes)
            for jj = 1:length(currentProbes)
                probeKeyToExpressionMapping(currentProbes{jj}) = currentExpression{:};
                descriptionList = vertcat(descriptionList,originalDescriptionList{descriptioniter});
            end
            descriptioniter = descriptioniter + 1;
        else
            probeKeyToExpressionMapping(currentProbes) = currentExpression{:};
            descriptionList = vertcat(descriptionList,originalDescriptionList{descriptioniter});
            descriptioniter = descriptioniter + 1;
        end
        geneSymbolFoundCount = geneSymbolFoundCount + 1;
    catch E
        geneSymbolNotFoundCount = geneSymbolNotFoundCount + 1;
    end
end

%display mapping information
fprintf(['found ' num2str(probeKeyToExpressionMapping.Count) ' probes from '...
            num2str(geneSymbolFoundCount) ' gene symbols\n']);
fprintf(['failed to find mappings for ' num2str(geneSymbolNotFoundCount) ' gene symbols\n']);

%format the gct file and write it to disk
probes = keys(probeKeyToExpressionMapping);
outputGCTdata = inputGCTdata;
outputGCTdata.rid = probes;
outputGCTdata.gd = containers.Map();
outputGCTdata.gd('desc') = descriptionList;
outputGCTdata.mat = zeros(length(probes),length(outputGCTdata.cid));
for ii = 1:length(probes)
    currentExpression = values(probeKeyToExpressionMapping,{probes{ii}});
    outputGCTdata.mat(ii,:) = currentExpression{:};
end
mkgct(outputGCT,outputGCTdata);
    

