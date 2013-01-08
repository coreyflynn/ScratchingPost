''' 
 function to extract probe set and gene symbol pairs from .chip files and write those pairs to 
 a user specified file

 USAGE:
 python ProbesetGeneSymbolPairsFromChip inputFilePath outputFilePath

 VARIABLE DEFINITIONS:
 inputFilePath: the path to the .chip file to be operated on
 outputFilePath: the path to the file to be written to
'''
if __name__ == "main":
    #imports
    import sys
    
    #parse the input arguments
    try:
        inputFilePath = sys.argv[1]
        f = open(inputFilePath,'r')
        
        outputFilePath  = sys.argv[2]
        f2 = open(outputFilePath,'w')
    except IndexError:
        print (__doc__)
        sys.exit(0)
    except IOError:
        print (__doc__)
        sys.exit(0)
        
    #read in the file and all of the line in the file
    lines = f.xreadlines()
    
    
    #write the probe set and gene symbols to the output file
    for line in lines:
        splitLine = line.split('\t')
        probeSetID = splitLine[0]
        geneSymbol = splitLine[2]
        f2.write(probeSetID+'\t'+geneSymbol+'\n')
    
    #close files
    f.close()
    f2.close()