#! /usr/bin/env python

import argparse
import cmap.util.mongo_utils as mu

parser = argparse.ArgumentParser(description = 'Bioactivity Tool')
parser.add_argument('res', type = str, help = 'the file to process')
args = parser.parse_args()
CM = mu.CMapMongo()
with open(args.res,'r') as f_in:
	with open(args.res.split('.')[0] + '.txt','w') as f_out:
		lines = f_in.readlines()
		for line in lines:
			desc = CM.find({'pert_id':line.rstrip()},{'pert_desc':True},limit=1)
			if not desc:
				desc = ['Not in Affogato']
			f_out.write('\t'.join([line.rstrip(),desc[0] + '\n']))