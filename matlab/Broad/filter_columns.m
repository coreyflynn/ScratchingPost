function filteredgct = filter_columns(gct,headers,values)
% FILTER_COLUMNS inputs gct data along with a listof column headers and values.  The data returned
% the set of rows in the data that match the specified header/value pairs
%
% USAGE:
% filteredgct = filter_columns(gct,headers,values)
%
% INPUT VARIABLE DEFINITIONS
% gct: the gct data to be filtered. A file path or gct structure are acceptable inputs
% headers: a cell array of column header names to be opperated on
% values: a cell array of values to be operated on for each header.  When multiple headers are 
%         specfied, this takes the form of a cell array of cell arrays, with each su-array specifying
%         the values for a header
%
% OUTPUT VARIABLE DEFINITIONS
% filteredgct: a gct formated structure containing only those rows that meet the header/values pairs
% specified
%
% Author: Corey Flynn, Broad Institute 2011

%check to see if the input gct file is a workspace structure variable.  If it is not, assume 
%that it is a file path and parse it.
if isstruct(gct) == 0
    gct = parse_gct(gct);
end

%for each header specificed, find the rows matching the name listed in the paired values
rowInds = []
for ii = 1:length(headers)
    currentHeaderInd = strmatch(headers(currentHeaderInd),gct.chd);
    if iscell values{ii} %handle multiple headers
        for jj = 1:length(values{ii})
            currentRowInds = strmatch(values{ii}(jj),gct.cdesc(:,currentHeaderInd))
            rowInds = vertcat(rowInds,currentRowInds);
        end
    else %handle single header
        for jj = 1:length(values{ii})
            currentRowInds = strmatch(values(jj),gct.cdesc(:,currentHeaderInd))
            rowInds = vertcat(rowInds,currentRowInds);
        end
    end
end

%generate a list of probes to filer out