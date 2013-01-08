#! /usr/bin/env python
'''
affogato_modulated_features.py

calculates the number of modulated features for all probes in affogato and breaks
the modulated features into types

AUTHOR: Corey Flynn, Broad Institute, 2012
'''
import cmap.util.mongo_utils as mu
import collections
import cmap.io.gct as gct
import numpy as np
import cmap.util.progress as progress

# get the type data for later use
CM = mu.CMapMongo()
types = CM.find({},{'pert_type':True})
prog = progress.DeterminateProgressBar('AFM')

# read the data in one chunk (1000 rows) at a time and compute the number of
# modulated features and their types
up_all = collections.deque()
dn_all = collections.deque()
up_cp = collections.deque()
dn_cp = collections.deque()
up_sh = collections.deque()
dn_sh = collections.deque()
up_oe = collections.deque()
dn_oe = collections.deque()
GCTObj = gct.GCT()
src = '/xchip/cogs/data/build/affogato/affogato_r1_score_n398050x22268.gctx'
chunk_size = 1000
for i in range(0,22268,chunk_size):
	prog.update('chunk_start = {0}'.format(i),i,22268)
	chunk_start = i
	chunk_end = i+1000
	if chunk_end > 22268:
		chunk_end = 22268
	GCTObj.read_gctx_matrix(src,row_inds=range(chunk_start,chunk_end))
	row_data = GCTObj.matrix
	for j in range(row_data.shape[0]):
		up_mod = np.where(row_data[j,:] > 2)[0].tolist()
		dn_mod = np.where(row_data[j,:] < -2)[0].tolist()
		
		up_all.append(len(up_mod))
		dn_all.append(len(dn_mod))

		up_cp.append(len([x for x in up_mod if types[x] == 'trt_cp']))
		dn_cp.append(len([x for x in dn_mod if types[x] == 'trt_cp']))

		up_sh.append(len([x for x in up_mod if types[x] == 'trt_sh']))
		dn_sh.append(len([x for x in dn_mod if types[x] == 'trt_sh']))

		up_oe.append(len([x for x in up_mod if types[x] == 'trt_oe']))
		dn_oe.append(len([x for x in dn_mod if types[x] == 'trt_oe']))

