function reordered_M = reorder_M(M,T)
%reorders the consensus matrix in M by cluter ids supplied in T
[sortedT,sortedTorder] = sort(T);
reordered_M = M*0;
for ii = 1:length(T)
    for jj = 1:length(T)
        reordered_M(ii,jj) = M(sortedTorder(ii),sortedTorder(jj));
    end
end