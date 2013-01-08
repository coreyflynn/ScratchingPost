function dists = eudist(test_vector,compare_matrix)
%computes the euclidian distance betwen the test_vector and each column in compare_matrix.  A 1xN
%vector of distances is returned, where N is the number of columns in compare_matrix

%make sure that test vector is a column vectro and compare matrix contains the right number of rows
if size(test_vector,1) == 1 && size(test_vector,2) ~= 1
    test_vector = transpose(test_vector);
elseif size(test_vector,1) ~= 1 && size(test_vector,2) ~= 1
    disp('test_vector must be a vector');
    return
end

%build a matrix of repeated test_vector of the appropriate size to subtract from compare_matrix
test_matrix = repmat(test_vector,[1,size(compare_matrix,2)]);

%compute the euclidean distance for each column
diffs = test_matrix - compare_matrix;
square_diffs = diffs.^2;
square_sums = sum(square_diffs,1);
dists = sqrt(square_sums);