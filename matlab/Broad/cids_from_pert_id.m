function matched_inds = cids_from_pert_id(gct,name_to_match)
id_ind = gct.cdict('pert_id');
pert_ids = gct.cdesc(:,id_ind);

matched = cellfun(@(x)regexp(x,name_to_match),pert_ids,'UniformOutput',0);
notEmpties = ~cellfun(@isempty,matched);
matched_inds = find(notEmpties==1);