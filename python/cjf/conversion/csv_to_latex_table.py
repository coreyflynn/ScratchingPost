"""
csvToLatexTable takes a csv file as input and prints out a latex formatted table 

USAGE:
python csvToLatexTable inputCSV

INPUT VARIABLES:
inputCSV: the path to the file to be read and formatted

Author: Corey Flynn, Broad institute, 2011
"""
if __name__ == "main":
    #imports
    import sys
    import csv
    
    #parse the input arguments
    try:
        csvReader = csv.reader(open(sys.argv[1],'rb'))# open the csv file for reading
    except IndexError:
        print (__doc__)
        sys.exit(0)
    except IOError:
        print (__doc__)
        sys.exit(0)
    
    #read in data from the input argument and print it to the prompt
    for row in csvReader:
        print '&'.join(row) + '\\' + '\\'

