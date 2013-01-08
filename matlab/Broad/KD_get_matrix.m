function result = KD_get_matrix(gct,controlName,expName,symbol)
%build output structure
result.cid = {'Ratio','KD Rank','Z Score'};
result.probeid = {};
result.expid = {};
result.mat = [];
result.controlName = controlName;
result.expName = expName;
result.symbol = symbol;

%find the columns matching the input control and exp names
expInds = strmatch(expName,gct.cdesc(:,1));
result.expid = gct.cdesc(expInds,1);
controlInds = strmatch(controlName,gct.cdesc(:,1));

%get the mean of the control experiments
ctrlMean = mean(gct.mat(:,controlInds),2);
%compute the normalized .mat
matNorm = gct.mat;
for ii = 1:size(matNorm,2)
    matNorm(:,ii) = matNorm(:,ii)./ctrlMean;
end

%find the probes for the input symbol
load '/xchip/cogs/cflynn/InferenceEval/U133aGeneSymMap.mat';
probes = U133aGeneSymMap(symbol);
result.probeid = probes;

%build results.mat given the number of probes and experiments
result.mat = zeros(3,length(result.expid),length(result.probeid));

%for each experiment sort the data in the experiment based on the difference between control and 
%experimental expression values
for ii = 1:length(expInds)
    [s,i] = sort(matNorm(:,ii),'ascend');
    %for all probes, find the index of the probe in control and exp 
    for jj = 1:length(probes)
        probeInd = strmatch(probes{jj},gct.rid);
        expLevel = matNorm(probeInd,expInds(ii));
        [z,mu,sigma] = robust_zscore(matNorm(:,expInds(ii)));
        result.mat(1,ii,jj) = expLevel;
        result.mat(2,ii,jj) = i(probeInd);
        result.mat(3,ii,jj) = z(probeInd);
    end
end