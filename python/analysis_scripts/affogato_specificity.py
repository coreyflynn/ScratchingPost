#!/usr/bin/env python
import cmap.io.gct as gct
import tables
import numpy as np
import cmap.util.progress as progress
import multiprocessing
import time
import collections

def get_specificity(tup):
     '''
     (matrix_data,index)
     '''
     #grab the row of data
     col = tup[0]
     num_reg_dn = np.take(col,np.where(col < -2)).size
     num_reg_up = np.take(col,np.where(col > 2)).size
     specificity = float(num_reg_dn + num_reg_up)/col.size

     return specificity

# affogato_path = '/xchip/cogs/data/brew/pc/CPC006_MCF7_6H/by_rna_well/CPC006_MCF7_6H_COMPZ.MODZ_SCORE_LM_n380x978.gctx'
affogato_path = '/xchip/cogs/data/build/affogato/affogato_r1_score_n398050x22268.gctx'
affogato_gct = gct.GCT()
cids = affogato_gct.get_gctx_cid(affogato_path)

#open the data table for reading
affogato_hdf = tables.openFile(affogato_path)
matrix_data = affogato_hdf.getNode("/0/DATA/0","matrix")

#create a pool of workers to calculate the specificity
chunk_size = 500
prog = progress.DeterminateProgressBar('Specificity')
specificities = collections.deque()
tic = time.time()
pool = multiprocessing.Pool()
chunk_starts = range(0,len(cids),chunk_size)

tups = [(matrix_data[i,:],i) for i in range(len(cids)-50,len(cids))]
res = pool.map(get_specificity,tups)
specificities.extend(res)

# for i in chunk_starts:
#      try:
#           prog.update('',i,len(cids))
#           tups = [(matrix_data[i,:],i) for i in range(i,i+chunk_size)]
#           res = pool.map(get_specificity,tups)
#           specificities.extend(res)
#      except IndexError:
#           tups = [(matrix_data[i,:],i) for i in range(chunk_starts[-1]+chunk_size+1,len(cids))]
#           res = pool.map(get_specificity,tups)
#           specificities.extend(res)
# toc = time.time()
# print('time elapsed = {0}'.format(toc-tic))

#close the hdf5 file file
affogato_hdf.close()
specificities = list(specificities)

with open('/xchip/cogs/data/build/affogato/affogato_r1_specificity2.txt','w') as f:
     for i,cid in enumerate(cids[-50:]):
          f.write('\t'.join([cid,str(specificities[i])]) + '\n')
