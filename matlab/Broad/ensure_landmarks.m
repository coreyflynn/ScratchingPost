function ensure_landmarks(inputGCT)
% ENSURE_LANDMARKS makes sure that all of the landmarks in a gct data file are represented
%
% ENSURE_LANDMARKS takes a .gct file as input and checks it to make sure that all of the landmarks in
% our epsilon landmark set are represented in it.  For any landmarks that are not represented, they
% are added and zeros are entered for as data
%
% USAGE:
% ensure_landmarks(inputGCT)
%
% INPUT VARIABLE DEFINITIONS:
% inputGCT: the paht to the .gct file to check
%
% Author: Corey Flynn, Broad Institute, 2011

%first read in the gct file
inputGCTData = parse_gct(inputGCT);

% find the set of landmark probe names that do not appear in the data file
landmarks = parse_grp('/xchip/cogs/cflynn/InferenceEval/lm_epsilon_n978.grp');
inputGCTDataProbes = inputGCTData.rid;
[commonProbeList, landmarkProbeInds, inputGCTDataProbeInds] = intersect_ord(...
                                                landmarks,inputGCTDataProbes);
missingLandmarks = setdiff(landmarks,commonProbeList);

%rebuild the input data structure with the added landmark filler data
descriptions = inputGCTData.gd.values(inputGCTData.gd.keys);
descriptions = descriptions{:}
for ii = 1:length(missingLandmarks)
    inputGCTData.rid = vertcat(inputGCTData.rid,missingLandmarks{ii});
    descriptions = vertcat(descriptions,'added landmark data');
    inputGCTData.mat = vertcat(inputGCTData.mat,zeros(1,length(inputGCTData.cid)));
end
inputGCTData.gd('desc') = descriptions;
mkgct([inputGCT 'landmarkfilled'],inputGCTData);