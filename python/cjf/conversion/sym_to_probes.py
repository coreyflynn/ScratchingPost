#!/usr/bin/env python
"""
script to convert a list of gene symbols to a list of probes associated with those genes

STAND ALONE USAGE:
sym2probes symbol_list_path probe_list_path

REQUIRED ARGUMENT DEFINITIONS:
symbol_list_path: the file containing the list of symbols to convert
probe_list_path: the file ot be written containing the probes list
"""
__author__ = 'Corey Flynn, Broad Institute'
__date__ = '12/7/11'

if __name__ == "main":
    import sys
    
    import cjf.cmap.util.symbol_map as symbol_map
    
    #parse the input arguments
    try:
        symbol_list_path = sys.argv[1]
        symbol_file = open(symbol_list_path,'r')
        probes_list_path = sys.argv[2]
        probes_file = open(probes_list_path,'w')
    except IOError:
        print(__doc__)
        sys.exit(0)
    except IndexError:
        print(__doc__)
        sys.exit(0)
    
    #read the symbols from the input file
    symbol_lines = symbol_file.xreadlines()
    
    #for each symbol, get the mapping in the form of a symbol:probes dictionary and dictionary of all symbols
    full_dict = {}
    for symbol_line in symbol_lines:
        symbol = symbol_line.rstrip('\n')
        symbol_dict = symbol_map.get_probes_for_symbol(symbol)
        full_dict.update(symbol_dict)
    
    #write the probes of the full dictionary to a file in probe_list_path
    symbol_map.write_probe_list(full_dict, probes_list_path)
    
    #close the opened files
    symbol_file.close()
    probes_file.close()