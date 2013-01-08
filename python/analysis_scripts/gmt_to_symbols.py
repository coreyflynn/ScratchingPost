#! /usr/bin/env python
'''
gmt_to_symbols.py

script to read a gmt file with probes as the entries for the the signatures and write out a gmt file
with gene symbols as the entries instead

AUTHOR: Corey Flynn, Broad Institute, 2012
'''
import cmap.util.symbol_map as symbol_map
import cmap.io.gmt as gmt
import cmap.util.progress as progress
import cmap.util.tool_ops as tool_ops
import argparse
import os


def build_parser():
    '''
    builds the command line parser to use with this tool
    '''
    parser = argparse.ArgumentParser(description = 'gmt_to_symbols')
    parser.add_argument('res', type = str, help = 'the gmt file to convert')
    parser.add_argument('-o','--out', type = str,
                        default = os.getcwd(), 
                        help = 'The output file path')
    parser.add_argument('-f','--file_name', type = str,
                        default = None, 
                        help = 'the name of the file to output')
    parser.add_argument('-n','--no_folder',
                        action = 'store_false',
                        default = True, 
                        help = 'set to bypass analysis folder creation')
    return parser


def translate_signature(sig):
	'''
	translates the signature of probes into a signature of gene symbols
	'''
	new_sig = []
	probe_dict = symbol_map.get_default_probe_dict()
	new_sig = map(lambda x:probe_dict[x],sig)

	# for s in sig:
	# 	symbol = symbol_map.match_probe(s,probe_dict=probe_dict)
	# 	if symbol not in new_sig:
	# 		new_sig.append(symbol)
	return new_sig



def main(args):
	'''
	main entry point for gmt_to_symbols.py
	'''
	#progress meter
	prog = progress.DeterminateProgressBar('GMT')

	#register the tool with tool_ops
	if args.no_folder:
		print('mk_folder')
	work_dir = tool_ops.register_tool('gmt_to_symbols',args,start_path=args.out,
		mk_folder=args.no_folder)

	sigs = gmt.read(args.res)
	num_sigs = len(sigs)
	for i,sig in enumerate(sigs):
		prog.update('Translating ' + sig['id'],i,num_sigs)
		new_sig = translate_signature(sig['sig'])
		sig['sig'] = new_sig
	
		prog.clear()

	if not args.file_name:
		args.file_name = os.path.basename(args.res).split('.gmt')[0] + '_gene_symbols.gmt'

	gmt.write(sigs,os.path.join(work_dir,args.file_name))


if __name__ == '__main__':
	parser = build_parser()
	args = parser.parse_args()
	main(args)
