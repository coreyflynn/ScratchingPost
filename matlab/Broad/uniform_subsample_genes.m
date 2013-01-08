function subsampledStruct = uniform_subsample_genes(inputStruct,subsample_interval)

%basic structure setup
subsampledStruct.mat = zeros(floor(size(inputStruct.mat,1)/subsample_interval),size(inputStruct.mat,2));
subsampledStruct.rid = cell(floor(size(inputStruct.mat,1)/subsample_interval),1);
subsampledStruct.cid = inputStruct.cid;
subsampledStruct.gd = inputStruct.gd;

%move through the input structure and grab a uniformly spaced subset
iter=1;
for ii = 3:subsample_interval:size(inputStruct.mat)
    subsampledStruct.mat(iter,:) = inputStruct.mat(ii,:);
    subsampledStruct.rid{iter} = inputStruct.rid{ii};
    iter =iter+1;
end
