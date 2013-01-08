function inds = regexp_list_inds(L,exp)
% use regexp to find the index of matching items in L

indCell = cellfun(@(x)regexpi(x,exp),L,'UniformOutput',0);
notEmpties = ~cellfun(@isempty,indCell);
inds = find(notEmpties==1);