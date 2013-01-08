function [eig_inst,eig_val,proj] = get_eigen_instances(z_scores_mat,eig_val_num)
%computes eig_val_num eigen_instances and their eigen values from the given z-scores matrix using 
%eigen value decomposition of the covariance matrix of the z-scores matrix.  The rows of the input
%matrix are used as the basis for decomposition

%calculate the covariance matrix of the input matrix rows
cov_mat = cov(transpose(z_scores_mat));

%get the largest eig_val_num eigen values and eigen_vectors of the covariance matrix
[eig_inst,eig_val] = eigs(double(cov_mat),eig_val_num);
eig_val = diag(eig_val);


%get the projection coeficients of each z-scores_mat column onto the selected eigen instances
proj = transpose(z_scores_mat)*eig_inst;
proj = transpose(proj);
