#! /usr/bin/env python
'''
converts erb files to .txt files reporting gene sets and NES scores
'''
import glob
import os
from xml.dom import minidom

# find all of the edb files in the current directory
edb_files = glob.glob('*.edb')

# loop over all of the files, parse them, and extract the NES scores for each
# gene set
for edb_file in edb_files:
 # parse the ebd file and grab all of the gene sets
 dom = minidom.parse(edb_file)
 genesets = dom.getElementsByTagName('DTG')

 # for each gene set, write its name and NES value to a tab delimited file
 base_name = os.path.splitext(edb_file)[0]
 with open(base_name + '.txt','w') as f:
  f.write('Gene Set\tNES\n')
  for geneset in genesets:
   name = geneset.getAttributeNode('GENESET').nodeValue
   name = name.split('#')[1]

   NES = geneset.getAttributeNode('NES').nodeValue

   f.write(name + '\t' + NES + '\n')