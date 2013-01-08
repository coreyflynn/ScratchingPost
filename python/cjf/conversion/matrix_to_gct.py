#! /usr/bin/env python
'''
Script to convert GEO Series Matrix Files to gct format
Probe set expression values are unchanged; metadata is formatted differently
Created on May 25, 2012
@author: Ian Smith
'''
import sys
from optparse import OptionParser

def convert_matrix(inputfile,outputfile):
    '''
    convert the specified matrix file (inputfile) to the specified output gct (outputfile)
    '''
    try:
        f_in = open(inputfile, 'r')
        f_out = open(outputfile, 'w')
    except IOError:
        parser.print_help()
        sys.exit(0)


    linesInput = f_in.readlines()
    metaLines = []
    sampleDescCount = 0
    sampleCharCount = 0
    headerCount = 0

    # Read lines from input file, until line contains ID_REF
    for line in linesInput:
        headerCount += 1
        # Discard if line does not contain !Sample or ID_REF
        if line.find('!Sample_') != -1:
            sampleDescCount += line.count('!Sample_description')
            sampleCharCount += line.count('!Sample_characteristics_ch1') 
            line = line.replace('!Sample_characteristics_ch1', '!Sample_characteristics_ch1_' + str(sampleCharCount))
            line = line.replace('!Sample_description', '!Sample_description_' + str(sampleDescCount))
            metaLines.append(line)
        elif line.find('ID_REF') != -1:
            line = line.replace('ID_REF', 'Name')
            metaLines.append(line)
            break

    linesInput[0:headerCount] = []


    # Remove !series_matrix_table_end if last item
    if linesInput[-1] == '!series_matrix_table_end':
        linesInput.remove(-1)    

    # Get number of rows and columns in the data matrix
    numRows = len(linesInput)
    numCols = linesInput[1].count('\t') 
    metaRows = len(metaLines)
    rowColData = [numRows, numCols, 0, metaRows-1]

    f_out.write('#1.3\n')    # Gct version
    for elt in rowColData:
        f_out.write(str(elt)+'\t')
    f_out.write('\n')

    f_out.writelines(metaLines)
    f_out.writelines(linesInput)

    f_in.close
    f_out.close
    

if __name__ == '__main__':
    #parse input arguments
    usage = "usage: %prog [options]"
    parser = OptionParser(usage=usage)
    parser.add_option("-i","--input",dest="in_txt",
                      help="path to the GEO Series Matrix File to be converted")
    parser.add_option("-o","--out",dest="out_gct",
                      help="the output file to generate (defaults to 'GSExxx_series_out.gct)'")

    (options, args) = parser.parse_args()
    
    #handle option errors
    if not options.in_txt:
        parser.error("Path to input file must be specified.")
    
    #determine the output file name
    if not options.out_gct:
        options.out_gct = options.in_txt.replace('matrix', 'out').replace('.txt', '.gct')

    inputfile = options.in_txt
    outputfile = options.out_gct
    convert_matrix(inputfile,outputfile)