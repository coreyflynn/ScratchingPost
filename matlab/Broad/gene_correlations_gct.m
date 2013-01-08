function [fullCorrs, pairedCorrs] = gene_correlations_gct(first_gct_path,second_gct_path)
% USAGE:
% [fullCorrs, pairedCorrs] = gene_correlations_ObsVsInf(first_gct_path,second_gct_path)
% 
% DESCRIPTION:
% This function reports the gene-wise correlations of two input gct files.  The function
% returns both the full correlation matrix of all genes and the pair-wise correlations of 
% each gene across the two input .gct files.  Note that the two input .gct files are assumed
% to contain the same genes in the same order.
%
% INPUTS:
% first_gct_path: the path to the first gct file for use in the function
% second_gct_path: the path to the second gct file for use in the function
%
% OUTPUTS:
% fullCorrs: NxN matrix containing the full correlation matrix where N is the number of genes
% pairedCorrs: 1xN matrix containing the paired correlations of each gene across the two input
%              gct files where N is the number of genes.

% read in the data from the two input .gct files
first_gct_data = parse_gct(first_gct_path);
second_gct_data = parse_gct(second_gct_path);

% calculate the correlation matrix between the two datasets
fprintf('computing correlation matrix...\n');
fullCorrs = corr(transpose(first_gct_data.mat),transpose(second_gct_data.mat));

% build and populate the 1xN matrix of the paired correlations
num_genes = size(fullCorrs,1);
pairedCorrs = zeros(1,num_genes);
for ii = 1:num_genes
    pairedCorrs(ii) = fullCorrs(ii,ii);
end

% plot the histogram of the correlations computed 
figure;
[n,xout] = hist(reshape(fullCorrs,1,[]),100);
bar(xout,n);

[n,xout] = hist(pairedCorrs,100);
hold on;
bar(xout,n,'r');