#! /usr/bin/env python
'''
symbol_to_probe_tool.py

takes in a grp file of symbols and returns a grp file of probes

AUTHOR: Corey Flynn, Broad Institute, 2012
'''

import argparse
import os
import cmap.io.plategrp as grp
import cmap.util.symbol_map as sm
import cmap.util.tool_ops as tool_ops

def build_parser():
	'''
	builds the parser for symbol_to_probe_tool.py
	'''
	parser = argparse.ArgumentParser(description = '''takes in a grp file of symbols and returns a grp file of probes''')
	parser.add_argument('-i', '--input_grp', type=str,
	                    default=os.getcwd(),
	                    help='The grp of symbols to convert')
	parser.add_argument('-o', '--out', type=str,
	                    default=os.getcwd(),
	                    help='The output directory')
	parser.add_argument('-p', '--prefix', type=str,
	                    default=None,
	                    help='a prefix to append to the output directory')
	return parser

def main(args,args_from_ui=None,verbose=True):
	'''
	main entry point for symbol_to_probe_tool.py
	'''
	#register the tool with tool ops
	work_dir = tool_ops.register_tool('symbol_to_probe_tool', args, 
	                                  start_path = args.out,
	                                  args_from_ui = args_from_ui)
	# read in the grp file of symbols
	symbols = grp.read_grp(args.input_grp)

	#map the symbols into probes
	probes = []
	for symbol in symbols:
		probes.extend(sm.get_probes_for_symbol(symbol))

	#write the probes to file
	grp_base = os.path.basename(args.input_grp)
	grp.write_grp(symbols,os.path.join(work_dir,grp_base))
	grp.write_grp(probes,os.path.join(work_dir,grp_base.split('.grp')[0] + '_probes.grp'))


if __name__ == '__main__':
	parser = build_parser()
	args = parser.parse_args()
	main(args)