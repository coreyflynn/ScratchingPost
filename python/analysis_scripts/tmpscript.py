#! /usr/bin/env python
import scipy.stats as stats
import random
import math
import numpy as np
import matplotlib.pyplot as plt
import cmap.util.queue as queue

def _get_row(input,ouput):
    '''
    compute a single row of the rrho matrix
    '''
    for tup in iter(input.get, 'STOP'):
        set1 = tup[0]
        res = np.zeros([1,978])
        size = tup[2]
        ranked_list_2 = tup[1]
        for ii in range(len(ranked_list_2)):
            set2 = set(ranked_list_2[0:ii])
            overlap = len(set1.intersection(set2))
            rrho = stats.hypergeom.cdf(overlap,978,size,ii)
            #normalize to expected and log transform
            expected_overlap = float(size)*(ii/978)
            if overlap > expected_overlap:
                rrho = 1-rrho
                if rrho == 0:
                    rrho = 1
                rrho_log = +abs(math.log10(rrho))
            else:
                rrho_log = -abs(math.log10(rrho))
            
            res[0][ii] = rrho_log
        ouput.put(res)


ranked_list_1 = range(978)
random.shuffle(ranked_list_1)
ranked_list_2 = range(978)
random.shuffle(ranked_list_2)



input_list = []
for ii in range(len(ranked_list_1)):
    # for jj in range(len(ranked_list_2)):
    #     set1 = set(ranked_list_1[0:ii])
    #     set2 = set(ranked_list_2[0:jj])
    #     overlap = len(set1.intersection(set2))
    #     rrho = stats.hypergeom.cdf(overlap,978,ii,jj)
    #     #normalize to expected and log transform
    #     expected_overlap = float(ii)*(jj/978)
    #     if overlap > expected_overlap:
    #         rrho = 1-rrho
    #         if rrho == 0:
    #             rrho = 1
    #         rrho_log = +abs(math.log10(rrho))
    #     else:
    #         rrho_log = -abs(math.log10(rrho))
        
    #     res[ii,jj] = rrho_log
    set1 = set(ranked_list_1[0:ii])
    input_list.append((set1,ranked_list_2,ii))

res = queue.q_runner(input_list,_get_row)
mat = np.zeros([978,978])
for ii in range(len(res)):
    mat[ii,:] = res[ii]
plt.matshow(mat)
plt.colorbar()
plt.show()
