function outputGCT = combine_samples(gct1,gct2)
% COMBINE_SAMPLES returns a gct sructure containing the samples from both input gct files
%
% COMBINE_SAMPLES takes two .gct files (gct structure) as input, concatenates the samples from the
% first with those from the second and returns the resulting gct structure
%
% USAGE:
% COMBINE_SAMPLES(gct1,gct2)
%
% INPUT VARIABLE DEFINITIONS
% gct1: the first .gct file or structure to be used as the base of the output .gct structure
% gct2: the second .gct file to be concatenated onto the first .gct file structure 
%
% OUTPUT VARIABLE DEFINITIONS
% outputGCT = the concatenated .gct structure
%
% Author: Corey Flynn, Broad Institute 2011


%if gct1 is a structure, use it.  Otherwise, assume it is a file
if isstruct(gct1) == 0
    gct1 = parse_gct(gct1);
end

%if gct2 is a structure, use it.  Otherwise, assume it is a file
if isstruct(gct2) == 0
    gct2 = parse_gct(gct2);
end

%find the common probes in the two gct files and strip each set to just those probes
commonProbes = intersect(gct1.rid,gct2.rid);
gct1 = filter_probes(gct1,commonProbes);
gct2 = filter_probes(gct2,commonProbes);

%make sure that the probes are in the same order in both data sets
[gct1,gct2] = reorder_probes(gct1,gct2);

%append the data in the second gct file to that of the first
outputGCT = gct1;
outputGCT.mat = horzcat(gct1.mat,gct2.mat);
outputGCT.cid = vertcat(gct1.cid,gct2.cid);
outputGCT.cdesc = vertcat(gct1.cdesc,gct2.cdesc);