function matched_inds = cids_from_cdesc(gct,name_to_match)
desc_ind = gct.cdict('pert_desc');
pert_descs = gct.cdesc(:,desc_ind);

matched = cellfun(@(x)regexp(x,name_to_match),pert_descs,'UniformOutput',0);
notEmpties = ~cellfun(@isempty,matched);
matched_inds = find(notEmpties==1);