function [queryList, instanceList] = exp2list(expFile);

%read in the exp file with parse_gmx
exp = parse_gmx(expFile);

%empty cell arrays for the query and instance lists
queryList = {};
instanceList = {};

%for each column in the file, add the query name to the list and parse the fields in the instances
for ii = 1:length(exp)
    query = exp(ii).head;
    for jj = 1:exp(ii).len
        instanceLine = exp(ii).entry{jj};
        instanceLineSplit = str_split(instanceLine,'|');
        for kk = 1:length(instanceLineSplit)
            queryList = horzcat(queryList,query);
            instanceList = horzcat(instanceList,instanceLineSplit{kk});
        end
    end
end
