function gene_list_strip(fullList_grp,stripList_grp,output_path)
% writes a list of all genes in fullList except those specified in
% stripList to output_path
fullList = parse_grp(fullList_grp);
stripList = parse_grp(stripList_grp);
for ii = 1: length(stripList)
    ind = strcmp(stripList{ii},fullList);
    if isempty(ind) == 0
        fullList{ind} = {};
    end
end
empties = cellfun(@isempty,fullList);
fullList(empties) = [];
mkgrp(output_path,fullList);