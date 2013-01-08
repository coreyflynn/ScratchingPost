function [gctStruct1,gctStruct2] = reorder_probes(gctStruct1,gctStruct2)
%reorder the comparisionStruct to match the probe order of gctStruct1

%find the probes common to the gctStruct1 and the gctStruct2 and reorder the rows in the .mat
%portion of the structure to be the same in each input structure
[commonSet, gctStruct1Ind, gctStruct2Ind] = intersect_ord(gctStruct1.rid...
                                                        ,gctStruct2.rid);
%reorder the matrix data
gctStruct1.mat = gctStruct1.mat(gctStruct1Ind,:);
gctStruct2.mat = gctStruct2.mat(gctStruct2Ind,:);

%reorder the row labels
gctStruct1.rid = gctStruct1.rid(gctStruct1Ind);
gctStruct2.rid = gctStruct2.rid(gctStruct2Ind);

