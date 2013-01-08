#! /usr/bin/env python
"""
simple wrapper around gct_utils.gct_13_to_12 
Created on Mar 2, 2012
@author: Corey Flynn, Broad Institute
"""

if __name__ == '__main__':
    import os
    from optparse import OptionParser
    
    import cjf.cmap.util.gct_utils as gct_utils
    
    
    #parse input arguments
    usage = "usage: %prog [options]"
    parser = OptionParser(usage=usage)
    parser.set_defaults(output_dir=os.getcwd(),file_name=None)
    parser.add_option("-i","--input",dest="input_gct",
                      help="path to the gct file to be converted")
    parser.add_option("-o","--out",dest="output_dir",
                      help="write output to DIR [default=pwd]")
    parser.add_option("-f","--file-name",dest="file_name",
                      help="the name of the output file to generate (defaults to 'INPUT_GCT_v12'")

    (options, args) = parser.parse_args()
    
    #handle option errors
    if not options.input_gct:
        parser.error("INPUT_GCT must be specified")
    
    #detemine the output file name
    if options.file_name:
        file_name = options.file_name + '_v12.gct'
    else:
        file_name = os.path.basename(options.input_gct).split('.gct')[0] + '_v12.gct'
    
    #convert file
    gct_utils.gct_13_to_12(options.input_gct, file_name)
    
    