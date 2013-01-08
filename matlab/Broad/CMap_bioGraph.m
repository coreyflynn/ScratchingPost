function [bg, bgHandle] = CMap_bioGraph(queryResult,cidNum,CESthresh)
% CMAP_BIOGRAPH plots a graph displaying the connectivities of a cmap query with instance classes
% in the CMap database used for the query
%
% CMAP_BIOGRAPH takes a queryResult structure as input along with a query number and a 
% connectivity enrichment cscore threshold.  CMAP_BIOGRAPH outputs both a biograph object and a 
% handle to that object
%
% USAGE:
% [bg, bgHandle] = CMap_bioGraph(queryResult,cidNum,CESthresh)
%
% INPUT VARIABLES:
% queryResult: the queryResult structure to be used for the generation of the graph.  Typically 
%               this structure is created using CMAP_QUERY_MATRIX or CMAP_BUILD_COMPARISON.
% cidNum: the query number (column identifier number) to be used in graph generation
% CESthresh: the connectivity enrichment score threshold to be used for graph generation.  All CES
%             falling above this value are taken to be connected edges in the graph
%
% OUTPUT VARIABLES:
% bg: the biograph created
% bgHandle: the handle to the created biograph
%
% Author: Corey Flynn, Broad Institute 2011

%find CES in the specified query that fall above CESthresh
sig = find(queryResult.CES(:,cidNum)>CESthresh);

%grab only those rids that are significant
rids = queryResult.rids(sig);

%build the node IDs 
id = queryResult.cids{cidNum};
id = vertcat(id,rids);
numNodes = length(id);

%build the connectivity matrix
cm = sparse(ones(1,numNodes),1:numNodes,true,numNodes,numNodes);
cm(diag(cm)) = 0;

%build the graph
bg = biograph(cm,id,'LayoutType','equilibrium');

%get the query node by its ID and color it green
queryHandle = getnodesbyid(bg,queryResult.cids{cidNum});
set(queryHandle,'Color',[0 1 0]);
g = biograph.bggui(bg);



bgHandle = get(g.biograph.hgAxes,'parent');
%export_fig(bgHandle,'test.png','-png');
