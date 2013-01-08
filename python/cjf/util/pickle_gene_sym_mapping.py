''' 
 function to create a pickled dictionary of gene symbol keys and probset values from a text file with 
 probe/symbol pairs created with ProbesetGeneSymbolPairsFromChip.py

 USAGE:
 python pickleGeneSymMapping inputFilePath outputFilePath

 VARIABLE DEFINITIONS:
 inputFilePath: the path to the .txt file to be operated on
 outputFilePath: the path to the file to be written to
'''

if __name__ == "main":
    #imports
    import sys
    import cPickle
    
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
    
    #create an empty dicitonary to populate with gene symbol keys and probeset values
    symbolDict = {}
    
    #move through the lines in the input file and build new keys in the dictionary for each new gene symbol
    #and add the current probe to that key as a value.  For those symbols that are already in the dictionary, 
    #add the current probe to the existing probes for that key
    for line in lines:
        splitLine = line.split('\t')
        probe = splitLine[0]    
        symbol = splitLine[1].rstrip('\n')
        if symbol not in symbolDict.keys():
            symbolDict[symbol] = [probe]
        else:
            symbolDict[symbol].append(probe)
        print symbolDict[symbol]
    
    #pickle the dictionary into the output file
    cPickle.dump(symbolDict,f2);
    
    #close files
    f.close()
    f2.close()