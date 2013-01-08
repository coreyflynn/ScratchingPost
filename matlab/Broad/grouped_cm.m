function [ordered_cm,ordered_labels] = grouped_cm(input_matrix,labels)
%GROUPED_CM inputs a matrix of data and takes the correlation of all rows in the 
%data to produce a correlation matrix.  This matrix is then ordered according to 
%agglomerative clustering on the row values in the matrix

%generate the correlation matrix
cm = fastcorr(input_matrix,'type','Spearman');

map = zeros(64,3);
map(1:32,1) = 0:1/31:1;
map(1:32,2) = 0:1/31:1;
map(1:32,3) = 1;
map(33:64,1) = 1;
map(33:64,2) = 1:-1/31:0;
map(33:64,3) = 1:-1/31:0;
    
T = clusterdata(cm,1);
[Ts, Ti] = sort(T);
ordered_cm = cm(Ti,Ti);
imagesc(ordered_cm);
colormap(map);

ordered_labels = labels(Ti);