#! /usr/bin/env python
'''
Utility function to update matlab files containing references to parse_gct and its produced fields to files
that use parse_gct2 and its produced fields. 

 USAGE:
 python updateCodeBase inputDirectory outputDirectory

 VARIABLE DEFINITIONS:
 inputFilePath: the path to the directory of .m files to be operated on
 outputFilePath: the path to directory to be written to
'''

if __name__ == "main":
    #imports
    import sys
    import os
    
    #parse the input arguments
    try:
        inputDirectory = sys.argv[1]
        files = os.listdir(inputDirectory)
        outputDirectory  = sys.argv[2]
    except IndexError:
        print (IndexError)
        print (__doc__)
        sys.exit(0)
    except IOError:
        print (IOError)
        print (__doc__)
        sys.exit(0)
    
    #for all files in the input directory, read the lines in the input file and replace it with the following
    #parse_gct2 -> parse_gct.  
    #mkgct2 -> mkgct
    #getargs2 -> parse_args
    #print_tool_params2 -> print_args
    for file in files:
        if '.m' in file:
            print ('updating '+ file)
            f = open(inputDirectory + file,'r')
            f2 = open(outputDirectory + file,'w')
            lines = f.xreadlines()
            for line in lines:
                line = line.replace('parse_gct2','parse_gct')
                line = line.replace('mkgct2','mkgct')
                line = line.replace('getargs2','parse_args')
                line = line.replace('print_tool_params2','print_args')
                f2.write(line)
            f.close()
            f2.close()