function filteredStruct = filter_probes_var(unfilteredData,numToPass)
% FILTER_PROBES_VAR returns a gct stucture containing only those probes that are the most variable
%
% FILTER_PROBES_VAR takes as .gct file and number as input, filters the data in the gct file and 
% returns the filtered .gct data
% USAGE:
% inferredComparison(inputGCT,outputDir)
%
% INPUT VARIABLE DEFINITIONS
% unfilteredData: the data to be operated on, either from the workspace or a path to a .gct file
% numToPass: the number of Probes to pass through the filter.  Only the top numToPass Probes 
%            are retained
%
% OUTPUT VARIABLE DEFINITIONS
% filteredStruct = the filtered structure (gex)
%
% Author: Corey Flynn, Broad Institute 2011

%if unfilteredData is a structure, use it.  Otherwise, assume it is a file
if isstruct(unfilteredData) == 0
    unfilteredData = parse_gct(unfilteredData);
end

%compute the coeficient of variance of all probes 
dataMeans = mean(unfilteredData.mat,2);
dataStds = std(unfilteredData.mat,0,2);
dataCvs = dataStds./dataMeans;

%compute the cvs of all probes and sort them
sortedCvs = sort(dataCvs,'descend');
varianceThresh = sortedCvs(numToPass+1);

varFilteredProbeInds = find(dataCvs>=varianceThresh);
numVarFilteredProbes = length(varFilteredProbeInds);
varFilteredProbeNames = cell(length(varFilteredProbeInds),1);
for ii = 1:length(varFilteredProbeInds) %populate the names of the Probes to be used
    varFilteredProbeNames{ii} = unfilteredData.rid{varFilteredProbeInds(ii)};
end
                          
%find the probes common to the unfiltered data and the probesNames list
[commonSet, unfilteredDataInd, probeNamesInd] = intersect_ord(unfilteredData.rid,varFilteredProbeNames);

%construct the filteredStruct based on the size of commonSet fields in unfilteredData
filteredStruct.mat = zeros(length(commonSet),length(unfilteredData.cid));
filteredStruct.mat = unfilteredData.mat(unfilteredDataInd,:);
filteredStruct.rid = commonSet;
filteredStruct.gd = unfilteredData.gd;
filteredStruct.cid = unfilteredData.cid;
filteredStruct.version = unfilteredData.version;