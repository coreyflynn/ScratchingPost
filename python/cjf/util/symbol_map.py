#! /usr/bin/env python
"""
 Look up the set of probes associated with a gene symbol in the mapping provided by a
 given pickled dictionary file.  If there is no dictionary file specified, a default file for the
 Affymetrix U133A chip is used.

 COMMAND LINE USAGE:
 probeLookup geneSymbol dictFile

 REQUIRED ARGUMENT DEFINITIONS:
 geneSymbol: the gene symbol key to use in the dictionary lookup

 OPTIONAL ARGUMENT DEFINITIONS:
 dictFile: optional input location of the dictionary file to be used.  the default is the U133A chip mapping
"""

#imports
import sys
import cPickle
import re

def get_default_symbol_dict():
    """load the default Affymetrix U133A mapping dictionary"""
    #un-pickle the default dictionary file
    dict_file_path = '/xchip/cogs/cflynn/InferenceEval/U133AGeneSymbolMappingDictPickle.txt'
    dict_file = open(dict_file_path,'r')
    symbol_dict = cPickle.load(dict_file)
    dict_file.close()
    return symbol_dict

def get_user_symbol_dict(dict_file_path):
    """load a user specified mapping dictionary"""
    dict_file = open(dict_file_path,'r')
    symbol_dict = cPickle.load(dict_file)
    dict_file.close()
    return symbol_dict
    

def match_symbol(symbol_dict,query):
    """
    match a partial or full symbol name query to all keys in the specified symbol dictionary
    and return the full name of all matching symbols in a list
    """
    #build a regular expression pattern from the specified gene symbol
    rp = re.compile(query)

    #check for the specified gene symbol using the regular expression pattern
    symbols = filter(rp.search,symbol_dict.keys())
    
    return symbols

def match_probe(symbol_dict,query):
    """
    match a partial or full probe name query to all values in the specified symbol dictionary
    and return the full name of all matching probess in a list
    """
    #build a regular expression pattern from the specified probe set query
    rp = re.compile(query)

    #check for the specified probe set using the regular expression pattern
    matched_probes = []
    for symbol in symbol_dict.keys():
        probes = filter(rp.search,symbol_dict[symbol])
        if len(probes) > 0:
            matched_probes.append(probes)

    return matched_probes

def probes_to_symbols(symbol_dict,probes):
    """
    given a set of probes, map them back to the symbols that they correspond to
    """
    #map the found probe sets onto their gene symbols
    matched_symbols = []
    for probe in probes:
        symbols = [item[0] for item in symbol_dict.items() if item[1] == probe]
        if len(symbols) > 0:
            matched_symbols.append(symbols)

    return matched_symbols



def write_probe_list(symbol_dict, out_file):
    """
    write a grp file containing only the probes in the passed symbol dictionary to out_file
    """
    f = open(out_file,'w')
    for key in symbol_dict.keys():
        probe_list = symbol_dict[key]
        for probe in probe_list:
            f.write(probe + '\n')
    f.close()

def write_symbol_list(symbol_dict, out_file):
    """
    write a grp file containing only the symbols in the passed symbol dictionary to out_file
    """
    f = open(out_file,'w')
    for key in symbol_dict.keys():
        f.write(key + '\n')
    f.close()

def write_symbol_probe_list(symbol_dict, out_file):
    """
    write a text file containing two columns, the first for gene symbols and the second for probe sets.
    All probes in the given dictionary are written to the file with their associated probes
    """
    f= open(out_file,'w')
    for key in symbol_dict.keys():
        probes = symbol_dict[key]
        for probe in probes:
            f.write(key + '\t' + probe + '\n')
    f.close()

def get_probes_for_symbol(symbol,**kwargs):
    """get all of the probes for a matching partial of full symbol name and return them in a dictionary
    containing a list of probes for each matching symbol.  The keys in the returned dictionary are
    the names of the matched symbols and the values are the associated probe lists"""
    #load the symbol dictionary
    if 'dict' in kwargs.keys():
        dict_file_path = kwargs['dict']
        symbol_dict = get_user_symbol_dict(dict_file_path)
    else:
        symbol_dict = get_default_symbol_dict()
    
    #perform symbol matching in the symbol dictionary keys
    symbols = match_symbol(symbol_dict, symbol)
    
    #return the result of the search in a new dictionary
    filtered_dict = {}
    if not len(symbols):
        pass
    else:
        for symbol in symbols:
            for item in symbol_dict.iteritems():
                if item[0] == symbol:
                    filtered_dict[item[0]] = item[1]
    return filtered_dict

if __name__ == '__main__':
    import optparse
    #parse the input arguments
    usage = 'usage: %prog [options] symbol'
    parser = optparse.OptionParser(usage=usage)
    parser.set_defaults(probe=False)
    parser.add_option("-p","--probe",action="store_true",dest="probe",
                      help="process symbol as a probeset")
    parser.add_option("-d","--dict",dest="dict",
                      metavar="DICT",
                      help="use DICT for probe lookup")
    (options, args) = parser.parse_args()

    if options.dict:
        symbol_dict = get_user_symbol_dict(options.dict)
    else:
        symbol_dict = get_default_symbol_dict()
    
    query = args[0]

    if options.probe:
        #query the loaded symbol dictionary with the given query
        probes = match_probe(symbol_dict, query)
        symbols = probes_to_symbols(symbol_dict, probes)

        if len(symbols) > 0:
            print('symbol matching probeset ' + query)
            for ii in range(len(symbols)):
                print symbols[ii]  + probes[ii]
        else:
            print('no matching symbols for ' + query)


    else:
        #query the loaded symbol dictionary with the given query
        symbols = match_symbol(symbol_dict, query)

        if not len(symbols):
            print ('no symbols matching ' + sys.argv[1])
            sys.exit(0)

        #for the specified gene symbol, display the mapped probes
        for symbol in symbols:
            print('probe mapping for ' + symbol)
            for probe in symbol_dict[symbol]:
                print(probe)