function shuffledT = cluster_label_shuffle(T)
%find the largest cluster in the given cluster labels and call that cluster
%1. find all others in decreasing size order and label them sequentially
numClusters = max(T);
clusterSize = zeros(numClusters,1);
for ii = 1:numClusters
    clusterSize(ii) = length(find(T == ii));
end

%assign lables in decereasing size order
[sortedClusterSize,sortedClusterInd] = sort(clusterSize,'descend');

shuffledT = T;
for ii = 1:numClusters
    shuffledT(find(T == sortedClusterInd(ii))) = ii;
end
