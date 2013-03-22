#! /usr/bin/env python
import cmap.io.gmt as gmt
import collections
import cmap.util.progress as progress

# instantiate a progress bar
prog = progress.DeterminateProgressBar('msigDB analysis')

# find all msigDB signatures that include the gene target of interest
target = 'AKT1'
msigDB = gmt.read('/xchip/cogs/cflynn/tmp/c2.all.v3.1.symbols.gmt')
target_sigs = []
for sig in msigDB:
	if target in sig['sig']:
		target_sigs.append(sig)

#build a dictionary of pert_descs and their best scores
# res_path = '/xchip/cogs/cflynn/tmp/feb01/graph_query_tool.1359702354139/AKT1_walk_results.txt'
res_path = '/xchip/cogs/cflynn/tmp/feb01/graph_query_tool.1359732183004/AKT1_walk_results.txt'
desc_dict = collections.defaultdict(float)
with open(res_path,'r') as f:
	headers = f.readline().strip().split('\t')
	pert_desc_ind = headers.index('pert_desc')
	norm_ind = headers.index('normalized walk count')
	lines = f.readlines()
	for line in lines:
		line = line.split('\t')
		if desc_dict[line[pert_desc_ind]]:
			if desc_dict[line[pert_desc_ind]] > float(line[norm_ind]):
				desc_dict[line[pert_desc_ind]] = float(line[norm_ind])
		else:
			desc_dict[line[pert_desc_ind]] = float(line[norm_ind])
node_set = set(desc_dict.keys())
# for each pathway in msigDB, find the number of members with a score greater than 1
# in the normalized random walk count
results = []
for i,target_sig in enumerate(target_sigs):
	prog.update('{0} of {1}'.format(i,len(target_sigs)),i,len(target_sigs))
	genes = target_sig['sig']
	found_genes = [x for x in genes if desc_dict[x] > 1]
	results.append('{0}\t{1}'.format(target_sig['id'],len(found_genes)/float(len(node_set.intersection(genes)))))
prog.clear()
# write the results to file
out = '/xchip/cogs/cflynn/tmp/graph_query_msigDB_{0}_AKT1_sig_graph.txt'.format(target)
with open(out,'w') as f:
	for result in results:
		f.write(result + '\n')