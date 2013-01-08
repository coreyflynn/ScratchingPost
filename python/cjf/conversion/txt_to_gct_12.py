"""
txt2gct12 converts a data file in txt format to one in gct version 1.2 format.  file formats can
be viewed at (http://www.broadinstitute.org/cancer/software/genepattern/tutorial/gp_fileformats.html)

USAGE:
txt2gct12 inputFile outputFile

INPUT VARIABLES:
inputFile: the .txt file to be converted
outputFile: the .gct file tobe written

NOTES:
this script is a command line wrapper around gctUtils.txt2gct12

Author: Corey Flynn, Broad institute, 2011
"""
if __name__ == "main":
    #imports 
    import sys
    import cjf.cmap.util.gct_utils as gctutils
    
    
    #parse the input arguments
    try:
        inputFilePath = sys.argv[1]
        outputFilePath  = sys.argv[2]
    except IndexError:
        print (__doc__)
        sys.exit(0)
    except IOError:
        print (__doc__)
        sys.exit(0)
    
    #call txt2gct12 from gctutils
    gctutils.txt_to_gct_12(inputFilePath,outputFilePath)

