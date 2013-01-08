#! /usr/bin/env python
""" concatentate input grp to a single gmx file 
    only tested so far on grp produced from bsig_gen
    USAGE:
    python grp2gmx inputgrp1 inputgrp2 outputgmx
"""
if __name__ == "main":
    #imports
    import sys
    
    #parse the input arguments
    try:
        f = open(sys.argv[1],'r')
        f2 = open(sys.argv[2],'r')
        f3 = open(sys.argv[3],'w')
    except IndexError:
        print (__doc__)
        sys.exit(0)
    except IOError:
        print (__doc__)
        sys.exit(0)
    #skip the first two lines in the grp files
    f.readline()
    f.readline()
    f2.readline()
    f2.readline()
    
    #for all lines in the input file, write them to the ouput file
    f3.write(sys.argv[4] + '\t' + sys.argv[5] + '\n')
    f3.write('na\tna\n')
    lines1 = f.xreadlines()
    lines2 = f2.xreadlines()
    for line1,line2 in zip(lines1,lines2):
        f3.write(line1.rstrip('\n') + '\t' + line2)
    
    #close all files
    f.close()
    f2.close()
    f3.close()