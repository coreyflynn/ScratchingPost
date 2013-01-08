function matched_inds = get_cell_inds(cell_array,name_to_match)

matched = cellfun(@(x)regexp(x,name_to_match),cell_array,'UniformOutput',0);
notEmpties = ~cellfun(@isempty,matched);
matched_inds = find(notEmpties==1);