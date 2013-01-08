#! /usr/bin/env python
'''
build_cmap_tools_ui.py

builds cmap.ui.cmap_tools from scratch. py2app is used to create the executable and then it
is bundled into a .dmg file

AUTHOR: Corey Flynn, Broad Institute, 2012
'''
import subprocess
import shutil
import os
import cmap.util.ftp as ftp

#open an SFTP object
sftp = ftp.SFTP()

#delete build and dist directories if they exist
if os.path.exists('/Users/cflynn/Documents/dmg/working/cmap_tools/dist'):	
	shutil.rmtree('/Users/cflynn/Documents/dmg/working/cmap_tools/dist')
	print ('removed' + '/Users/cflynn/Documents/dmg/working/cmap_tools/dist')

if os.path.exists('/Users/cflynn/Documents/dmg/working/cmap_tools/build'):	
	shutil.rmtree('/Users/cflynn/Documents/dmg/working/cmap_tools/build')
	print ('removed' + '/Users/cflynn/Documents/dmg/working/cmap_tools/build')

#run py2app
subprocess.call(['python','/Users/cflynn/Documents/dmg/working/cmap_tools/setup.py','py2app',
	'-b','/Users/cflynn/Documents/dmg/working/cmap_tools/build',
	'-d','/Users/cflynn/Documents/dmg/working/cmap_tools/dist'])

#make the dmg
subprocess.call(['/Users/cflynn/Documents/dmg/working/cmap_tools/make_cmap_tools_dmg.sh'])

#transfer to copper 
print('transferring to copper...')
sftp.put('/Users/cflynn/Documents/dmg/dist/CMapTools.dmg','/home/unix/cflynn/public_html/dmg/CMapTools.dmg')