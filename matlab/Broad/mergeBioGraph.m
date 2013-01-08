function [bgMerge, bgMergeHandle] = mergeBioGraph(graphs)
% MERGEBIOGRAPH takes a list of biographs and merges thme into one graph with no redundant nodes and
% all edges preserved from the input graphs
%
% USAGE:
% bgMerge = mergeBioGraph(graphs)
%
% INPUT VARIABLES:
% graphs: a cell array of input graphs
%
% OUTPUT VARIABLES: 
% bgMerge: the merged graph 
%
% Author: Corey Flynn, Broad Institute 2011

%make a list of the connectivity matrices for each graph
cms = {};
for ii = 1:length(graphs)
    cm = getmatrix(graphs{ii});
    cms = horzcat(cms,{cm});
end

%make a list of node groups for each graph
nodeGroups = {};
for ii =1:length(graphs);
    nodeGroup = getnodesbyid(graphs{ii});
    nodeGroups = horzcat(nodeGroups,{nodeGroup});
end

%make a list of node names in each nodeGroup
nodeNamesbyGroup = {};
for ii = 1:length(nodeGroups)
    nodeNames = getNodeNames(nodeGroups{ii});
    nodeNamesbyGroup = horzcat(nodeNamesbyGroup,{nodeNames});
end

% find the listof unique node names in the two lists.  Then look for edges in either graph between
% the unique names.  Use these connections to build the 
mergeNodeIDs = unique(horzcat(nodeNamesbyGroup{:}));
numNodes = length(mergeNodeIDs);
cmMerge = sparse([],[],true,numNodes,numNodes);
for ii = 1:numNodes
    for jj = 1:numNodes
        for kk = 1:length(graphs)
            cmMerge = findConnVal(ii,jj,cmMerge,cms{kk},mergeNodeIDs,nodeNamesbyGroup{kk});
        end
    end
end

%build the biograph
bgMerge = biograph(cmMerge,mergeNodeIDs,'LayoutType','equilibrium');

%maintain node colors
for ii = 1:length(graphs)
    bgMerge = matchColors(bgMerge,graphs{ii},nodeNamesbyGroup{ii});
end
    
%display the merged graph
g = biograph.bggui(bgMerge);
bgMergeHandle = get(g.biograph.hgAxes,'parent');


function nodeNames = getNodeNames(nodeGroup)
%creates a list of node names for the input nodeGroup structure usings it's ID field
nodeNames = {};
for ii = 1:length(nodeGroup)
    nodeNames = horzcat(nodeNames,nodeGroup(ii).ID);
end


function cmMerge = findConnVal(ii,jj,cmMerge,cm,mergeNodeIDs,nodesIDs)
%returns an updated version of the merged connection matrix with the connection value found in 
% the input connection matrix for the index specified by (ii,jj)
try 
    ind1 = strmatch(mergeNodeIDs(ii),nodesIDs,'exact');
    ind2 = strmatch(mergeNodeIDs(jj),nodesIDs,'exact');
    cmMerge(ii,jj) = cm(ind1,ind2);
catch E            
end

function bgMerge = matchColors(bgMerge,bg,nodeNames)
% updates the colors of the nodes in bgMerge to reflect those in the input biograph, bg
for ii = 1:length(nodeNames)
    hMerge = getnodesbyid(bgMerge,nodeNames(ii));
    h1 = getnodesbyid(bg,nodeNames(ii));
    set(hMerge,'Color',get(h1,'Color'));
end