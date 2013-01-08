function normgct = normalize_probes(gct)
% NORMALIZE_PROBES inputs gct data and normalizes all probes in the data to have a mean of 0 and
% standard deviation of 1
%
% USAGE:
% normgct = normalize_probes(gct)
%
% OUTPUT VARIABLE DEFINITIONS
% gct: the gct data to be normalized. A file path or gct structure are acceptable inputs
%
% OUTPUT VARIABLE DEFINITIONS
% normgct: the structure containing data from the normalized gct data.  This structure is returned
% to the workspace.
%
% Author: Corey Flynn, Broad Institute 2011

%check to see if the input gct file is a workspace structure variable.  If it is not, assume 
%that it is a file path and parse it.
if isstruct(gct) == 0
    gct = parse_gct(gct);
end

%for each probe in the gct file subtract the mean value and divide by the standard deviation to set
%the mean to 0 and the standard deviation to 1
for ii = 1:length(gct.rid)
    currentProbe = gct.mat(ii,:);
    currentProbeMean = mean(currentProbe);
    currentProbe = currentProbe - currentProbeMean;
    
    currentProbeStd = std(currentProbe);
    currentProbe = currentProbe/currentProbeStd;
    gct.mat(ii,:) = currentProbe;
end

normgct = gct;