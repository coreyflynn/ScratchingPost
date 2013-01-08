#! /usr/bin/env python
'''
batch_gene_mod.py

generates standard figures and tables of perts regulating each gene in the input 
list

AUTHOR: Corey Flynn, Broad Institute, 2012
'''

import cmap.analytics.gene_mod as gene_mod
import cmap.io.gct as gct
import cmap.util.symbol_map as sm
import cmap.util.progress as progress
import cmap.util.mongo_utils as mu
import cmap.io.gmx as gmx
import cmap.io.plategrp as grp
import os


output_dir = '/xchip/cogs/projects/GeneMod/cfwork/systematic'
lm_symbols = gmx.read('/xchip/cogs/data/vdb/spaces/lm_symbols.gmx')
eps_symbols = lm_symbols['eps']['entry']
# symbols = ['HSF1','ERG','AKT1','ESR1','MUC1','HSPA1A','HSPA6','HDAC6',
# 		   'MYC','TP53','KRAS','SORT1','TRIB1','CD44','SMN2','SMN2']
# symbols = ['CDK2']
symbols = []
symbols.extend(eps_symbols)
symbols = set(symbols)

# only run symbols that have not been run previously
used_symbols = set(grp.read_grp(os.path.join(output_dir,'processed_symbols.grp')))
symbols.difference_update(used_symbols)
symbols = list(symbols)

# make a list of all the symbol,probes, and probe inds
tups = []
gct_dummy = gct.GCT()

print('processing {0} symbols'.format(len(symbols)))
prog = progress.DeterminateProgressBar('BatchGeneMod')
num_symbols = len(symbols)
for i,symbol in enumerate(symbols):
	prog.update('mapping symbol: {0}'.format(symbol),i,num_symbols)
	probes = sm.get_probes_for_symbol(symbol,exact=True)
	if type(probes) == str:
		probes = [probes]
	inds = gct_dummy.get_gctx_rid_inds('/xchip/cogs/data/build/affogato/affogato_r1_score_n398050x22268.gctx',
										match_list=probes,exact=True)
	for j,probe in enumerate(probes):
		tups.append((symbol,probe,inds[j]))
tups.sort(key=lambda x:x[2])
prog.clear()

prog.show_message('reading score matrix: {0} rows'.format(len(tups)))
gct_dummy.read_gctx_matrix('/xchip/cogs/data/build/affogato/affogato_r1_score_n398050x22268.gctx',
							row_inds=[x[2] for x in tups])
scores = gct_dummy.matrix

prog.show_message('reading rank matrix: {0} rows'.format(len(tups)))
gct_dummy.read_gctx_matrix('/xchip/cogs/data/build/affogato/affogato_r1_rank_n398050x22268.gctx',
							row_inds=[x[2] for x in tups])
ranks = gct_dummy.matrix
prog.clear()

GM = gene_mod.GeneMod()
GM.cid = gct_dummy.get_gctx_cid('/xchip/cogs/data/build/affogato/affogato_r1_rank_n398050x22268.gctx')
num_tups = len(tups)
for i,tup in enumerate(tups):
	probe_prefix = '_'.join([tup[0],tup[1]])
	prog.update('running {0}'.format(probe_prefix),i,num_tups)
	probe_dir = os.path.join(output_dir,probe_prefix)
	if not os.path.exists(probe_dir):
		os.mkdir(probe_dir)
		GM.z_score = scores[i,:].tolist()
		GM.rank = ranks[i,:].tolist()
		GM.ds_ind = range(scores.shape[1])
		GM.reg_ind = range(scores.shape[1])
		GM.specificity_filter(1,verbose=False)
		GM.scatter('z_score','rank',x_cutoffs=(-2,2),
					xlim=(-10,10),ylim=(0,22268),
					out=os.path.join(probe_dir,probe_prefix + '_pre_rank.png'))
		GM.scatter('z_score','specificity',x_cutoffs=(-2,2),
					xlim=(-10,10),ylim=(0,1),
					out=os.path.join(probe_dir,probe_prefix + '_pre_specificity.png'))
		GM.rank_filter(10634,abs=True,verbose=False)
		GM.z_score_filter(3,abs=True,verbose=False)
		GM.gold_filter(1,verbose=False)
		GM.specificity_filter(0.4,verbose=False)
		GM.scatter('z_score','rank',x_cutoffs=(-2,2),
					xlim=(-10,10),ylim=(0,22268),
					out=os.path.join(probe_dir,probe_prefix + '_post_rank.png'))
		GM.scatter('z_score','specificity',x_cutoffs=(-2,2),
					xlim=(-10,10),ylim=(0,1),
					out=os.path.join(probe_dir,probe_prefix + '_post_specificity.png'))
		mu.sig_info([GM.cid[x] for x in GM.reg_ind],
					out=os.path.join(probe_dir,probe_prefix + '_modulators.txt'),
					extra_fields=['z-score','rank','specificity'],
					extra_data=[[str(GM.z_score[x]),str(GM.rank[x]),str(GM.specificity[x])] 
								for x in GM.reg_ind])
prog.clear()


