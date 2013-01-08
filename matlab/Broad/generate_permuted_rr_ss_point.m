function [rrlist,sslist,perm_mat] = generate_permuted_rr_ss_point(zs,num_k,num_perm)
num_inds = size(zs,2);
corr_inds = nchoosek(1:num_k,2);
corrs = zeros(1,size(corr_inds,1));
perm_mat = zeros(num_perm,978);
ssn = 50;
for ii = 1:num_perm
    perm = randperm(num_inds);
    perm_inds = perm(1:num_k);
    perm_data = zs(:,perm_inds);
    for jj = 1:size(corr_inds,1)
        corrs(jj) = fastcorr(perm_data(:,corr_inds(jj,1)),perm_data(:,corr_inds(jj,2)));
    end
    rrlist(ii) = mean(corrs);
    perm_zs = modzs(perm_data,1:978);
    perm_mat(ii,:) = perm_zs;
    perm_zs = sort(perm_zs,'descend');
    top = mean(perm_zs(1:ssn));
    bottom = mean(perm_zs(end-ssn+1:end));
    sslist(ii) = top-bottom;
end

