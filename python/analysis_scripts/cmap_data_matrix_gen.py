#! /usr/bin/env python
'''
generate a current snapshot table of all lines and experiment types in the cmap 
database
'''

import cmap.util.mongo_utils as mu

CM = mu.CMapMongo()

# get a list of the cell lines in the database
cell_lines = CM.find({},{'cell_id':1})
cell_lines = list(set(cell_lines))

# for each cell line generate a line in a table detailing the experiments done
with open('cmap_data_matrix.txt','w') as f:
	f.write('\t'.join(['cell line', '# CP', '# KD','# OE', 'total\n']))
	for cell_line in cell_lines:
		CP = CM.find({'cell_id':cell_line,'pert_type':'trt_cp'},count=True)
		KD = CM.find({'cell_id':cell_line,'pert_type':'trt_sh'},count=True)
		OE = CM.find({'cell_id':cell_line,'pert_type':'trt_oe'},count=True)
		total = CP + KD + OE
		f.write('\t'.join([cell_line, str(CP), str(KD), str(OE), str(total) + '\n']))