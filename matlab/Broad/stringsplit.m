function outputcell = stringsplit(inputString,delimiter)
% returns a cell array of substrings that are the result of splitting the inputstring with the
% delimeter 
%
% Author: Corey Flynn, Broad Institute 2011

outputcell = {};
remain = inputString;
while true
    [str,remain] = strtok(remain,delimiter);
    if isempty(str)
        break
    end
    outputcell = horzcat(outputcell,str);
end