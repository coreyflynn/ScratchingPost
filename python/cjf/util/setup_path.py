'''
Created on Jan 6, 2012

@author: cflynn
'''
import os
import sys

def append_cjf():
    """
    check to see if the python sandbox path is on a mounted drive or on the local drive
    """
    if os.path.isdir('/Volumes/xchip_cogs/cflynn/sandboxCodeWorking/python'):
        sys.path.append('/Volumes/xchip_cogs/cflynn/sandboxCodeWorking/python')
    if os.path.isdir('/xchip/cogs/cflynn/sandboxCodeWorking/python'):
        sys.path.append('/xchip/cogs/cflynn/sandboxCodeWorking/python')

if __name__ == '__main__':
    append_cjf()