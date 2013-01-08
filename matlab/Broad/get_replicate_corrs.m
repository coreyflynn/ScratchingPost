function [replicate_corrs_list, replicate_corrs_dictionary, replicate_corrs_inds] = get_replicate_corrs(cm,labels)
%mine the replicate correlations out of a correlation matrix accordding to input annotations

%find the unique labels
unique_labels = unique(labels);
unique_labels = setdiff(unique_labels,'DMSO')

%pre-allocate a vector to hold replicates, make the vector the maximum possible length and strip
%it down later
replicate_corrs_list = (cm(:) *0) - 999;
replicate_corrs_inds = zeros(length(cm(:)),2) -999;

%construct a dictionary to hold correlations for labels
replicate_corrs_dictionary = containers.Map;

%loop through all of the labels and find their replicates.  Grab the cm entry for all possible 
%combinations of replicates
iter = 1;
label_iter = 1;
for ii = 1:length(unique_labels)
    matched_inds = get_rep_inds(labels,unique_labels(ii));
    try
        match_combos = combntns(matched_inds,2);
        tmp_corrs = zeros(1,size(match_combos,1));
        for jj = 1:size(match_combos,1)
            replicate_corrs_list(iter) = cm(match_combos(jj,1),match_combos(jj,2));
            replicate_corrs_inds(iter,1) = match_combos(jj,1);
            replicate_corrs_inds(iter,2) = match_combos(jj,2);
            tmp_corrs(jj) = cm(match_combos(jj,1),match_combos(jj,2));
            iter = iter + 1;
        end
        replicate_corrs_dictionary(unique_labels{ii}) = tmp_corrs;
    catch
        continue
    end
    label_iter = label_iter + 1;
end

%strip out extra array entries from replicate_corrs
replicate_corrs_list(find(replicate_corrs_list==-999)) = [];
empty_inds = find(replicate_corrs_inds(:,1)==-999);
replicate_corrs_inds(empty_inds,:) = [];


function matched_inds = get_rep_inds(labels,name_to_match)
matched = cellfun(@(x)strmatch(x,name_to_match,'exact'),labels,'UniformOutput',0);
notEmpties = ~cellfun(@isempty,matched);
matched_inds = find(notEmpties==1);