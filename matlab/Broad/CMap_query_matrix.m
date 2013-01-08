function [CES, lowerConfidence, upperConfidence] =  CMap_query_matrix(query_gct);
% look at the enrichment of connectivities in the specified drugclass across all queries in the given
% query gct file

%number of drug classes and qureies
drugClassInd = strmatch('drug_class',query_gct.rhd,'exact');
drugClasses = unique(query_gct.rdesc(:,drugClassInd));
numDrugClasses = length(drugClasses);
numQueries = length(query_gct.cid);

fprintf('finding significant Connectivities for %g drugs over %g queries\n', numDrugClasses, numQueries);

%holding arrays for NxM classXquery matrices of CES, lower confidence, upper confidence
CES = zeros(numDrugClasses,numQueries);
lowerConfidence = CES;
upperConfidence = CES;
labelsTemplate = zeros(size(query_gct.mat,1),1);

%open a matlab pool for use in the parfor loop below
if matlabpool('size') == 0
    matlabpool open;
end

tic;
for ii = 1:numDrugClasses
    currentDrugClass = drugClasses{ii};
    parfor jj = 1: numQueries
        classLabels = strmatch(currentDrugClass,query_gct.rdesc(:,drugClassInd));
        labels = labelsTemplate;
        labels(classLabels) = 1;
        [P,CES(ii,jj)] = CMap_enrichment_score(query_gct.mat(:,jj),labels);
        [lowerConfidence(ii,jj),upperConfidence(ii,jj)] = CMap_enrichment_score_confidence(...
                                                            query_gct.mat(:,jj),labels,...
                                                            'numPerm',100,...
                                                            'numClassMembers',sum(labels));
            %fprintf('finished running instance: %g, drug class: %s\n', jj, currentDrugClass);
    end
    fprintf('finished running drug class: %s\n', currentDrugClass);
    fprintf('time elapsed: %2.2f min\n', toc/60);
end

%close the matlabpool
matlabpool close;