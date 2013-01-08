function reorderedStruct = reorder_genes(referenceStruct,comparisionStruct)
%reorder the comparisionStruct to match the gene order of referenceStruct

num_genes = length(referenceStruct.rid);
%basic structure setup
reorderedStruct.mat = zeros(size(referenceStruct.mat,1),size(referenceStruct.mat,2));
reorderedStruct.rid = cell(length(referenceStruct.rid),1);
reorderedStruct.cid = referenceStruct.cid;
reorderedStruct.gd = referenceStruct.gd;

dispCounter = 0;    %//counter to iterate for progress display
dispFlag    = 1000;
fprintf('reordering %i genes...\n',num_genes);
tic;
for ii = 1:num_genes
ind = strmatch(referenceStruct.rid{ii},comparisionStruct.rid);
    reorderedStruct.mat(ii,:) = comparisionStruct.mat(ind,:);
    reorderedStruct.rid{ii} = comparisionStruct.rid{ind};
    if dispCounter == dispFlag
        fprintf('reordered %i of %i genes',dispFlag,num_genes);
        fprintf(', time elapsed: %6.2f\n',toc);
        dispFlag = dispFlag+1000;
    end
dispCounter = dispCounter+1;
end