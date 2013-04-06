#! /usr/bin/env python
'''
MUC1_KD_ES.py

inputs a query_tool result and an set of sig_ids to compute ES scores for.
mountain plots are generated for each column in the query_tool_result matrix.
a table of ES scores is generated

AUTHOR: Corey Flynn, Broad Institute, 2013
'''

import argparse
import cmap.util.tool_ops as tool_ops
import os
import cmap.io.plategrp as grp
import cmap.io.gct as gct
import cmap.analytics.gsea as gsea

def build_parser():
	'''
	builds the parser for MUC1_KD_ES.py
	'''
	parser = argparse.ArgumentParser(description = '''inputs a query_tool result and an set of sig_ids to compute ES scores for.
mountain plots are generated for each column in the query_tool_result matrix.
a table of ES scores is generated''')

	parser.add_argument('-r','--res', type = str,
	                    default = None, 
	                    help = 'the gctx result file to use')
	parser.add_argument('-g','--gene_set', type = str,
	                    default = None, 
	                    help = 'the grp gene set file to use')
	parser.add_argument('-s','--stub', type = str,
	                    default = None, 
	                    help = 'a naming stub to use for ES plots')

	# set the ouput directory
	parser.add_argument('-o','--out', type = str,
	                    default = os.getcwd(), 
	                    help = 'The output directory')
	parser.add_argument('-p','--prefix', type = str,
	                    default = None, 
	                    help = 'a prefix to append to the output directory')
	return parser

def main(args,args_from_ui=None,verbose=True):
	'''
	main entry point for MUC1_KD_ES.py
	'''
	#register the tool with tool ops
	work_dir = tool_ops.register_tool('MUC1_KD_ES', args, 
	                                  start_path = args.out,
	                                  analysis_name = args.prefix,
	                                  args_from_ui = args_from_ui)
	# read the data
	res = gct.GCT(args.res,read=True)

	# loop over the data in the result file and compute and ES for each column.
	# generate mountain plots for each and save them to disk
	ES_list = []
	for col in res.frame.columns:
		ES = gsea.preranked(args.gene_set,res.frame.sort(col,ascending=False).index,
							do_NES=False)
		ES_list.append(ES)
		gsea.preranked(args.gene_set,res.frame.sort(col,ascending=False).index,
					   linewidth=5,
					   savefig=os.path.join(work_dir,'{0}_ES'.format(col.split(':')[1])),
					   title='{0}:ES={1}'.format(col.split(':')[1],ES),
					   do_NES=False)


if __name__ == '__main__':
	parser = build_parser()
	args = parser.parse_args()
	main(args)
