function filteredStruct = filter_samples(unfilteredData,sampleNames)
% FILTER_SAMPLES returns a gct stucture containing only those samples that are in the sampleNames list
%
% FILTER_SAMPLES takes a .gct file (gct structure) and a .grp file (or cell file list) as input,  
% filters the data in the gct file and returns a gct structure containing only those samples in 
% sampleNames.
%
% USAGE:
% filter_samples(unfilteredData,sampleNames)
%
% INPUT VARIABLE DEFINITIONS
% unfilteredData: the data to be operated on, either from the workspace or a path to a .gct file
% sampleNames: the list of samples to retain from the data set, either from the workspace or a path
%              to a .grp file
%
% OUTPUT VARIABLE DEFINITIONS
% filteredStruct = the filtered structure
%
% Author: Corey Flynn, Broad Institute 2011


%if unfilteredData is a structure, use it.  Otherwise, assume it is a file
if isstruct(unfilteredData) == 0
    unfilteredData = parse_gct(unfilteredData);
end

%if sampleNames is a cell array, use it.  Otherwise, assume it is a file
if iscell(sampleNames) == 0
    sampleNames = parse_grp(sampleNames);
end

                          
%find the samples common to the unfiltered data and the probesNames list
[commonSet, unfilteredDataInd, sampleNamesInd] = intersect_ord(unfilteredData.cid,sampleNames);

%construct the filteredStruct based on the size of commonSet fields in unfilteredData
filteredStruct = unfilteredData;
filteredStruct.mat = zeros(length(unfilteredData.rid),length(commonSet));
filteredStruct.mat = unfilteredData.mat(:,unfilteredDataInd);
filteredStruct.cid = commonSet;
if isempty(unfilteredData.cdesc) %handle cases where cdesc is numSamplesx0 empty cell
    filteredStruct.cdesc = cell(length(commonSet),0);
else
    filteredStruct.cdesc = unfilteredData.cdesc(unfilteredDataInd);
end