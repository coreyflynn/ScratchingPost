#! /usr/bin/env python
""" 
 function to look up the set of probes associated with a gene symbol in the mapping provided by a 
 given pickled dictionary file and additionally find the ranks of those probes in the provided .rnk
 file.

 USAGE:
 python probeLookup geneSymbol rnkFile [dictFile]

 VARIABLE DEFINITIONS:
 geneSymbol: the gene symbol key to use in the dictionary lookup
 rnkFile: the .rnk file to use for lookup
 dictFile: optional input location of the dictionary file to be used.  the default is the U133A chip mapping
"""
if __name__ == "main":
    #imports
    import sys
    import cPickle
    import re
    import operator
    
    #parse the input arguments
    if len(sys.argv) == 3:
        try:
            dictFile = '/xchip/cogs/cflynn/InferenceEval/U133AGeneSymbolMappingDictPickle.txt'
            f2 = open(dictFile,'r')
            f3 = open(sys.argv[2],'r')
        except IndexError:
            print (__doc__)
            sys.exit(0)
        except IOError:
            print (__doc__)
            sys.exit(0)
    
    if len(sys.argv) == 4:
        try:
            dictFile  = sys.argv[3]
            f2 = open(dictFile,'r')
            f3 = open(sys.argv[2],'r')
        except IndexError:
            print (__doc__)
            sys.exit(0)
        except IOError:
            print (__doc__)
            sys.exit(0)
            
    #un-pickle the dictionary file
    symbolDict = cPickle.load(f2)
    
    #build a regular expression pattern from the specified gene symbol
    rp = re.compile(sys.argv[1])
    
    #check for the specified gene symbol using the regular expression pattern
    symbols = filter(rp.search,symbolDict.keys())
    if len(symbols) == 0:
        print ('no symbols matching ' + sys.argv[1])
        sys.exit(0)
    
    #read in the values in the .rnk file and create a tuple out of them
    rnkLines = f3.xreadlines()
    rnkProbes = []
    rnks = []
    for rl in rnkLines:
        rlsplit = rl.split('\t')
        rnkProbes.append(rlsplit[0])
        rnks.append(float(rlsplit[1]))
    rnksTup = zip(rnkProbes,rnks)
    
    #sort the rank tuple by rank
    index1 = operator.itemgetter(1)
    rnksTup.sort(key = index1, reverse = True)
    rnkProbesSort, rnksSort = zip(*rnksTup)
    rnkProbesSort = list(rnkProbesSort)
    rnksSort = list(rnksSort)
    
    #for the specified gene symbol, display the mapped probes and their ranks
    for symbol in symbols:
        print('probe mapping and ranks for ' + symbol)
        for probe in symbolDict[symbol]:
            print('Probe: ' + probe +'\tRank: ' + str(rnkProbesSort.index(probe)) + '\tScore: ' + str(rnksSort[rnkProbesSort.index(probe)]))
    f2.close()
    f3.close()
