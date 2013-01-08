#! usr/bin/env python
"""
Utility functions related to handling gct files
"""
import sys
    
def gct_13_to_12(version13File,version12File):
    """
    gct_13_to_12 reverts a version 1.3 .gct file to a 1.2 .gct file compatible for use with utilities
    that are not updated for use with version 1.3 files.

    USAGE:
    gct_13_to_12(version13File,version12FileLocation)

    INPUT VARIABLES:
    version13File: the version 1.3 .gct file to convert
    version12File: the path to which the version 1.2 .gct file will be written

    Author: Corey Flynn, Broad institute, 2011
    """
    #parse the input arguments
    try:
        inputFilePath = version13File
        f= open(inputFilePath,'r')
        outputFilePath  = version12File
        f2 = open(outputFilePath, 'w')
    except IOError:
        print (__doc__)
        sys.exit(0)
        
    #read the input file header
    f.readline()
    dims = f.readline()

    #split the dims line 
    dimsList = dims.split('\t')

    #write the new header lines to the output file
    f2.write('#1.2\n')
    f2.write(dimsList[0] + '\t' +dimsList[1] +'\n')
    line = f.readline()
    lineList = line.split('\t')
    f2.write(lineList[0] + '\t' + lineList[1])
    for entry in lineList[int(dimsList[2])+1::]:
        f2.write('\t')
        f2.write(entry)
    

    #skip all annotation lines in the file
    for i in range(int(dimsList[3])): #@UnusedVariable
        f.readline()

    #finish writing the file with the 1.3 data
    lines = f.xreadlines()
    for line in lines:
        lineList = line.split('\t')
        f2.write(lineList[0] + '\t' + lineList[1])
        for entry in lineList[int(dimsList[2])+1::]:
            f2.write('\t')
            f2.write(entry)

    f.close()
    f2.close()
    
def update_to_parse_gct2(inputDirectory,outputDirectory):
    """
    Utility function to update matlab files containing references to parse_gct and its produced fields to files
    that use parse_gct2 and its produced fields.

     USAGE:
     update_to_parse_gct2(inputDirectory,outputDirectory)

     VARIABLE DEFINITIONS:
     inputFilePath: the path to the directory of .m files to be operated on
     outputFilePath: the path to directory to be written to
    """

    #imports
    import os

    #parse the input arguments
    try:
        files = os.listdir(inputDirectory)
    except IndexError:
        print (IndexError)
        print (__doc__)
        sys.exit(0)
    except IOError:
        print (IOError)
        print (__doc__)
        sys.exit(0)

    #for all files in the input directory, read the lines in the input file and replace it with the following
    #ge->mat
    #gn->rid
    #sid->cid
    for f in files:
        if '.m' in f:
            print ('updating '+ f)
            f = open(inputDirectory + f,'r')
            f2 = open(outputDirectory + f,'w')
            lines = f.xreadlines()
            for line in lines:
                line = line.replace('parse_gct','parse_gct2')
                line = line.replace('.ge','.mat')
                line = line.replace('.gn','.rid')
                line = line.replace('.sid','.cid')
                line = line.replace('mkgct','mkgct2')
                f2.write(line)
            f.close()
            f2.close()
def txt_to_gct_12(inputFilePath,outputFilePath):
    """
    txt_to_gct_12 converts a data file in txt format to one in gct version 1.2 format.  file formats can
    be viewed at (http://www.broadinstitute.org/cancer/software/genepattern/tutorial/gp_fileformats.html)

    USAGE:
    txt_to_gct_12 inputFile outputFile

    INPUT VARIABLES:
    inputFile: the .txt file to be converted
    outputFile: the .gct file tobe written

    NOTES:
    this script is a command line wrapper around gctUtils.txt_to_gct_12

    Author: Corey Flynn, Broad institute, 2011
    """
    #parse the input arguments
    try:
        f= open(inputFilePath,'r')
        f2 = open(outputFilePath, 'w')
    except IndexError:
        print (__doc__)
        sys.exit(0)
    except IOError:
        print (__doc__)
        sys.exit(0)
        
    #find out the number of columns and rows in the input file
    numRows = 0
    for line in open(inputFilePath):
        numRows += 1
    firstLine = f.readline()
    numColumns = len(firstLine.split('\t'))
    
    #write the output file header
    f2.write('#1.2\n')
    f2.write(str(numRows - 1) + '\t' + str(numColumns - 2) + '\n')
    
    #write the input file data to the output file
    f2.write(firstLine.rstrip('\n'))
    lines = f.xreadlines()
    for line in lines:
        f2.write(line.rstrip('\n'))
    
    #close the files
    f.close()
    f2.close()

if __name__ == "main":
    pass
    
    