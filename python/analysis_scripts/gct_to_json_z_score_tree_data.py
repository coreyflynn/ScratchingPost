"""
takes a gct(x) file and converts writes a json file that contains the number of features
outside of z-score cutoffs of +/- 1,2,3,4 for each sample in the gct file
Created on Jul 11, 2012
@author: Corey Flynn
"""

import cmap.io.gct as gct
import json
import numpy as np

source_gct = '/xchip/cogs/stacks/STK016_CPC006/CPC006_COMPZ.MODZ_SCORE_LM_n12655x978.gctx'
#source_gct = '/xchip/cogs/stacks/STK016_CPC006/cfwork/MDV3100/PC/MDV3100_LM_PC_n35x978.gctx'

#read in the gct file
data = gct.GCT(src=source_gct)

#for each column in the matrix, find the number of features beyond the cuttofs and place them in a dictionary 
json_array = []
cids = data.get_cids()
for i in range(1000):
    tmp_dic = {}
    tmp_dic.update({
                    'cid':cids[i],
                    '1up':np.where(data.matrix[:,i] > 1)[0].size,
                    '1dn':np.where(data.matrix[:,i] < -1)[0].size,
                    '2up':np.where(data.matrix[:,i] > 2)[0].size,
                    '2dn':np.where(data.matrix[:,i] < -2)[0].size,
                    '3up':np.where(data.matrix[:,i] > 3)[0].size,
                    '3dn':np.where(data.matrix[:,i] < -3)[0].size,
                    '4up':np.where(data.matrix[:,i] > 4)[0].size,
                    '4dn':np.where(data.matrix[:,i] < -4)[0].size
                    })
    json_array.append(tmp_dic)

json_string = json.dumps(json_array, indent=4)
with open('/xchip/cogs/cflynn/tmp/CPC006_z_data.json','w') as f:
    f.write(json_string)
