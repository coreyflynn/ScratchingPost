#! /usr/bin/env python
'''
example_rnai_graph_analysis.py

example of an rnai graph based analysis using cmap.analytics.graph which in 
turn uses networkx

AUTHOR: Corey Flynn, Broad Institute, 2012
'''
import cmap.io.gct as gct
import cmap.analytics.query as query
import cmap.analytics.graph as graph
import numpy as np


# grab data from just the EGFR hairpins
data_path = '/xchip/cogs/projects/rnai_analysis/DER/data/DER001_PC3_96H/by_pert_id/DER001_PC3_96H_COMPZ.MODZ_SCORE_LM_n355x978.gctx'
data = gct.GCT(data_path)
data.read()
data_cids = data.get_cids()
data_cdesc = data.get_chd()
EGFR_inds = [i for i,x in enumerate(data.get_column_meta('pert_desc')) if x =='EGFR']
EGFR_matrix = data.matrix[:,EGFR_inds]
EGFR_cid = [data_cids[x].split(':')[1] for x in EGFR_inds] # grab EGFR hairpin EGFR_ids

# populate a query object and run a spearman query across the whole set of EGFR 
# hairpins generating a square matrix of correlations inside of the query result
q = query.Query(queries=EGFR_matrix,database=EGFR_matrix,database_cid=EGFR_cid)
q.spearman_query()
result = q.results[0]

# use the result to add to a graph using the correlations > .2 as the edges in an
# adjacency matrix
adj = result.data
adj[np.where(adj == 1)] = 0
adj[np.where(adj <= .2)] = 0
adj[np.where(adj > .2)] = 1
G = graph.CMapGraph()
G.add_nodes_and_edges_from_adjacency_matrix(adj,ids=EGFR_cid)

#display the graph
G.show_connected_graph(with_labels=True)

# get the page rank of the nodes in the graph
print('Page Rank:')
for x in G.get_pagerank():
	print(x)


# get the random walk results
print('Random Walk:')
for x in G.walk_connections():
	print(x)
