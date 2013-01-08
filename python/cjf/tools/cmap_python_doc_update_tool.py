#!/usr/bin/env python
'''
updates the documentation for cmap python modules (BPTK)   
Created on Aug 13, 2012
@author: Corey Flynn
'''
import subprocess
import glob
import os
import cmap.util.doc as doc
import cmap.util.ftp as ftp

def get_files(input_dir):
    '''
    grab all of the files in a directory
    '''
    files = glob.glob(os.path.join(input_dir,'*.*'))
    return files

def transfer_directory(sftp,local_path,remote_path):
    '''
    transfers all of the non-directory components of the local_path to the remote_path
    '''
    files = get_files(local_path)
    for f in files:
        remote = os.path.join(remote_path,os.path.basename(f.replace('/Users/cflynn/Broad/CMap/bptk_doc/build/','')))
        print('transferring %s to %s' %(f,remote))
        sftp.put(f,remote)
                 

#open an SFTP object
sftp = ftp.SFTP()

#first build the .rst files needed
(roots,source_files) = doc.get_source_files()
for sf in source_files:
    doc.make_source_rst(sf, '/Users/cflynn/Broad/CMap/bptk_doc/source')
doc.make_dir_rst(roots, '/Users/cflynn/Broad/CMap/bptk_doc/source')

#next build the docs using sphinx
subprocess.call(['make','-C','/Users/cflynn/Broad/CMap/bptk_doc','html'])

#last, place the doc on the web
dir_list = [x[0] for x in os.walk('/Users/cflynn/Broad/CMap/bptk_doc/build/html')]
for d in dir_list:
    transfer_directory(sftp, d, d.replace('/Users/cflynn/Broad/CMap/bptk_doc/build/html',
                                          '/home/unix/cflynn/public_html/bptk_doc/'))
sftp.close()