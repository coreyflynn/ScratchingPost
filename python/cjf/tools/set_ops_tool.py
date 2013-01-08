#! /usr/bin/env python
'''
basic set operations for comparing list data
Created on Mar 12, 2012
@author: Corey Flynn, Broad Institute
'''
import sys

class MultiItemError(Exception):
    '''
    custom error exception class for use in set_ops
    '''
    pass


def set_from_file(input_path):
    '''
    read the contents of a file and return a set containing one element per line.  Generate
    an error if there is more than one tab delimited entry per line. disregard lines
    starting with '#'
    '''
    with open(input_path) as f:
        lines = f.readlines()
    
    #check for multiple items per line
    set_list = []
    for line in lines:
        if line.startswith('#'):
            continue
        split_line = line.split('\t')
        try:
            if len(split_line) > 1:
                raise MultiItemError('too many inputs per line')
        except MultiItemError as X:
            sys.exit("MultiItemError: " + X.args[0])
        
        set_list.append(split_line[0].strip())
    
    #return the set
    return set(set_list)
        
        

if __name__ == '__main__':
    from optparse import OptionParser
    
    usage = "usage: %prog [options] file1 file2"
    parser = OptionParser(usage=usage)
    parser.set_defaults(intersect=False,union = False,diff=False,output=None)
    parser.add_option("-i","--intersect",dest="intersect",action="store_true",
                      help="set intersection")
    parser.add_option("-u","--union",dest="union",action="store_true",
                      help="set union")
    parser.add_option("-d","--diff",dest="diff",action="store_true",
                      help="set difference (file1 - file2)")
    parser.add_option("-o","--out",dest="out",
                      help="output file path")
    (options, args) = parser.parse_args()
    
    #make sure we have enough arguments
    if len(args) != 2:
        parser.error("exactly two arguments (file1 and file2) are required")
    
    #make sure one set operation is selected
    if not options.intersect and not options.union and not options.diff:
        sys.exit("-i, -u, or -d must be specified")
    
    #get sets
    set1 = set_from_file(args[0])
    set2 = set_from_file(args[1])
    
    #make sure we only do one set operation
    if options.intersect:
        set_result = set1 & set2
        options.diff = False
        options.union = False
    if options.union:
        set_result = set1 | set2
        options.diff = False
        options.intersect = False
    if options.diff:
        set_result = set1 - set2
        options.intersect = False
        options.union = False
    
    #print the result unless options.out is specified
    if options.out:
        with open(options.out,'w') as f:
            for item in set_result:
                print(item)
                f.write(item + '\n')
        print('list length = %i' %(len(set_result),))
        print('output written to %s' %(options.out,))
    else:
        for item in set_result:
            print(item)
        print('list length = %i' %(len(set_result),))   
    #