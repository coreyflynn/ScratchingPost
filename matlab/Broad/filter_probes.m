function filteredStruct = filter_probes(unfilteredData,probeNames)
% FILTER_PROBES returns a gct stucture containing only those probes that are in the nameCell
%
% FILTER_PROBES takes as .gct file and a .grp file as input.  filters the data in the gct file and 
% returns the filtered .gct data
% USAGE:
% filter_probes(unfilteredData,probeNames)
%
% INPUT VARIABLE DEFINITIONS
% unfilteredData: the data to be operated on, either from the workspace or a path to a .gct file
% probeNames: the list of probe names to filter on
%
% OUTPUT VARIABLE DEFINITIONS
% filteredStruct = the filtered structure
%
% Author: Corey Flynn, Broad Institute 2011

%if unfilteredData is a structure, use it.  Otherwise, assume it is a file
if isstruct(unfilteredData) == 0
    unfilteredData = parse_gct(unfilteredData);
end

%if probeNames is a cell array, use it.  Otherwise, assume it is a file
if iscell(probeNames) == 0
    probeNames = parse_grp(probeNames);
end
numProbes = length(probeNames);

                          
%find the probes common to the unfiltered data and the probesNames list
[commonSet, unfilteredDataInd, probeNamesInd] = intersect_ord(unfilteredData.rid,probeNames);

%construct the filteredStruct based on the size of commonSet fields in unfilteredData
filteredStruct = unfilteredData;
filteredStruct.mat = zeros(length(commonSet),length(unfilteredData.cid));
filteredStruct.mat = unfilteredData.mat(unfilteredDataInd,:);
filteredStruct.rid = unfilteredData.rid(unfilteredDataInd);
try
    filteredStruct.rdesc = unfilteredData.rdesc(unfilteredDataInd,:);
catch E
    
end