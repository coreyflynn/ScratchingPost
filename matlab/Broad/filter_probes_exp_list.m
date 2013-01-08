function expFilteredProbeNames = filter_probes_exp_list(unfilteredData,expThresh)
% FILTER_PROBES_EXP_LIST returns a list containing only those probes that are above the given cutoff
% for mean expression
%
% FILTER_PROBES_EXP_LIST takes as .gct file and number as input, filters the data in the gct file and 
% returns the list of probes used to filter the data
%
% USAGE:
% filter_probes_exp_list(unfilteredData,expThresh)
%
% INPUT VARIABLE DEFINITIONS
% unfilteredData: the data to be operated on, either from the workspace or a path to a .gct file
% expThresh: the expression levle of Probes to pass through the filter.
%
% OUTPUT VARIABLE DEFINITIONS
% expFilteredProbeNames = the filtered probe list
%
% Author: Corey Flynn, Broad Institute 2011

%if unfilteredData is a structure, use it.  Otherwise, assume it is a file
if isstruct(unfilteredData) == 0
    unfilteredData = parse_gct(unfilteredData);
end

dataMeans = mean(unfilteredData.mat,2);

expFilteredProbeInds = find(dataMeans>=expThresh);
expFilteredProbeNames = unfilteredData.rid(expFilteredProbeInds);