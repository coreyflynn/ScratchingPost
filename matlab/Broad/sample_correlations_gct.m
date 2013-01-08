function [fullCorrs, pairedCorrs] = sample_correlations_gct(first_gct_path,second_gct_path)
% USAGE:
% [fullCorrs, pairedCorrs] = sample_correlations_ObsVsInf(first_gct_path,second_gct_path)
% 
% DESCRIPTION:
% This function reports the sample-wise correlations of two input gct files.  The function
% returns both the full correlation matrix of all samples and the pair-wise correlations of 
% each sample across the two input .gct files.  Note that the two input .gct files are assumed
% to contain the same samples in the same order.
%
% INPUTS:
% first_gct_path: the path to the first gct file for use in the function
% second_gct_path: the path to the second gct file for use in the function
%
% OUTPUTS:
% fullCorrs: NxN matrix containing the full correlation matrix where N is the number of samples
% pairedCorrs: 1xN matrix containing the paired correlations of each sample across the two input
%              gct files where N is the number of samples.

% read in the data from the two input .gct files
first_gct_data = parse_gct(first_gct_path);
second_gct_data = parse_gct(second_gct_path);

% calculate the correlation matrix between the two datasets
fprintf('computing sample correlation matrix...\n');
fullCorrs = corr(first_gct_data.mat,second_gct_data.mat);

% build and populate the 1xN matrix of the paired correlations
num_samples = size(fullCorrs,1);
pairedCorrs = zeros(1,num_samples);
for ii = 1:num_samples
    pairedCorrs(ii) = fullCorrs(ii,ii);
end

% plot the histogram of the correlations computed 
figure;
[n,xout] = hist(reshape(fullCorrs,1,[]),[0:.01:1]);
plot(xout,n);

[n,xout] = hist(pairedCorrs,[0:.01:1]);
hold on;
plot(xout,n,'r');