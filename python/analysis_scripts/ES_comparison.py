#! /usr/bin/env python

import cmap.io.gct as gct
import matplotlib.pyplot as plt
import numpy as np

# import datasets
# py_es = '/xchip/cogs/cflynn/tmp/mar26/es_preranked_tool.1364356307767/ES_matrix_n5x10.gctx'
# mat_es = '/xchip/cogs/cflynn/tmp/mar26/my_analysis.query_tool.2013032623002149/result_ES.UP_n5x10.gctx'
# py_es_gct = gct.GCT(py_es,read=True)
# mat_es_gct = gct.GCT(mat_es,read=True)

py_wtes = '/xchip/cogs/cflynn/tmp/mar28/DOS_es_preranked_tool.1364478813411/result_ES_n372x294.gctx'
mat_wtes = '/xchip/cogs/projects/bioactivity/hogstrom/DOS_to_credentialed_query/mar14/my_analysis.query_tool.2013031414355091/result_WTES.UP_n372x294.gctx'
py_wtes_gct = gct.GCT(py_wtes,read=True)
mat_wtes_gct = gct.GCT(mat_wtes,read=True)

# reorder py_* to match the order of mat_*
# py_es_frame = py_es_gct.frame
# mat_es_frame = mat_es_gct.frame
# mat_es_frame = mat_es_frame.reindex(py_es_frame.index)

py_wtes_frame = py_wtes_gct.frame
mat_wtes_frame = mat_wtes_gct.frame
mat_wtes_frame = mat_wtes_frame.reindex(py_wtes_frame.index)

# plot a histogram of differences
# plt.hist(np.ravel(py_es_frame.values - mat_es_frame.values),50,range=[-1,1])
# plt.title('es differences')
# plt.show()

plt.hist(np.ravel(py_wtes_frame.values - mat_wtes_frame.values),500,range=[-.01,.01])
plt.title('wtes differences')
plt.show()
