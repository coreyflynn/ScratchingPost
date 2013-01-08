function [H,I] = probe_rank_entropy(mat,col,sampling)
% compute the shannon entropy for each probeset rank in col based on the observed pmf of the columns
num_probes = size(mat,1);
H = zeros(1,num_probes);
I = zeros(1,num_probes);
for ii = 1:num_probes
    counts = histc(mat(ii,:),1:sampling:num_probes);
    pmf = counts/num_probes;
    p = pmf(ceil(mat(ii,col)/sampling));
    I(ii) = -log2(p);
    H(ii) = -p*log2(p);
end