function subsampledStruct = uniform_subsample_genes(inputStruct,subsample_begin,subsample_end)

%basic structure setup
subsampledStruct.mat = zeros(length(subsample_begin:subsample_end),size(inputStruct.mat,2));
subsampledStruct.rid = cell(length(subsample_begin:subsample_end));
subsampledStruct.cid = inputStruct.cid;
subsampledStruct.gd = inputStruct.gd;

%move through the input structure and grab the specified subset
iter=1;
for ii = subsample_begin:subsample_end
    subsampledStruct.mat(iter,:) = inputStruct.mat(ii,:);
    subsampledStruct.rid{iter} = inputStruct.rid{ii};
    iter =iter+1;
end
