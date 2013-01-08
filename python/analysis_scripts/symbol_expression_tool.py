#!/usr/bin/env python
'''
takes the input of a symbol and looks up the expression of that symbol in the given gctx file
the resulting expression is written out into a table at the specified path
'''
import os
import sys
from optparse import OptionParser
import cmap.util.symbol_map as symbol_map
import cmap.io.gct as gct
import cmap.util.progress as progress

if __name__ == '__main__':
    
    #parse input arguments
    usage = "usage: %prog [options]"
    parser = OptionParser(usage=usage)
    parser.set_defaults(symbol=None, res=None,out=os.getcwd())
    parser.add_option("-s","--symbol",dest="symbol",
                      help="the symbol to search on")
    parser.add_option("-r","--res",dest="res",
                      help="the gctx file in which to look for expression")
    parser.add_option("-o","--out",dest="out",
                      help="the file in which to write output")
    (options, args) = parser.parse_args()
    
    if not options.symbol:
        print('symbol must be specified')
        sys.exit(1)
    
    if not options.res:
        print('res must be specified')
        sys.exit(1)
    
    if not options.out:
        print('out must be specified')
        sys.exit(1)
    
    #instantiate an progress update object
    prog = progress.DeterminateProgressBar('Symbol Expression Tool') 
    
    #find the probes matching the symbol specified
    prog.show_message('finding symbol to probe mappings')
    probes = symbol_map.get_probes_for_symbol(args.symbol, exact=True)
    
    #load the GCT file and find the indices matching the probes for the symbol 
    GCTObj = gct.GCT()
    prog.show_message('finding probe_indices')
    rid_inds = GCTObj.get_gctx_rid_inds(args.dataset, match_list=probes)
    
    #grab the cid and rid from the data
    prog.show_message('reading metadata headers')
    cids = GCTObj.get_gctx_cid(args.dataset)
    rids = GCTObj.get_gctx_rid(args.dataset)
    
    #grab the data for just those rows
    prog.show_message('slicing matrix data (%i rows, %i columns)' % (len(rid_inds),len(cids)))
    GCTObj.read_gctx_matrix(args.dataset, row_inds=rid_inds)
    
    
    #write a table to the ouput file
    num_cids = len(cids)
    with open(options.out,'w') as f:
        for rid_ind in rid_inds:
            f.write('\t' + rids[rid_ind])
        f.write('\n')
        for i,cid in enumerate(cids):
            prog.update('Writing data table', i, num_cids)
            f.write(cid)
            for j in range(GCTObj.matrix.shape[0]):
                f.write('\t%f' % (GCTObj.matrix[j,i]))
            f.write('\n')
    #clear the progress update
    prog.clear()