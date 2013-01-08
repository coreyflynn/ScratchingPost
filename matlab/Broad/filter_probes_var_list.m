function varFilteredProbeNames = filter_probes_var_list(unfilteredData,numToPass)
% FILTER_PROBES_VAR_LIST returns a list containing only those probes that are the most variable
%
% FILTER_PROBES_VAR_LIST takes as .gct file and number as input, filters the data in the gct file and 
% returns the list of probes used to filter the data
%
% USAGE:
% inferredComparison(inputGCT,outputDir)
%
% INPUT VARIABLE DEFINITIONS
% unfilteredData: the data to be operated on, either from the workspace or a path to a .gct file
% numToPass: the number of Probes to pass through the filter.  Only the top numToPass Probes 
%            are retained
%
% OUTPUT VARIABLE DEFINITIONS
% varFilteredProbeNames = the filtered probe list
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
varFilteredProbeNames = unfilteredData.rid(varFilteredProbeInds);