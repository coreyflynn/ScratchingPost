'''
 utility function to add a constant string to the both the beginning and the end of each string on 
 the lines of the input text file

 USAGE:
 python preAndPostPendName inputFilePath preString postString outputFilePath

 VARIABLE DEFINITIONS:
 inputFilePath: the path to the file of strings (one per line) to be operated on
 preString: the string to add to the begining of each line in the input file
 postString: the string to add to the end of each line in the input file
 outputFilePath: the path to the file to be written as output
'''
if __name__ == "main":
#imports
    import sys
    
    #parse the input arguments
    try:
        inputFilePath = sys.argv[1]
        f = open(inputFilePath,'r')
        
        preString = sys.argv[2]
        postString = sys.argv[3]
        
        outputFilePath = sys.argv[4]
        f2 = open(outputFilePath,'w')
    except IndexError:
        print (__doc__)
        sys.exit(0)
    except IOError:
        print (__doc__)
        sys.exit(0)
    
    
    #ppend strings to all rows in the file
    for line in f:
        line = line.strip('\n')
        f2.write(preString+line+postString+'\n')
    
    f.close()
    f2.close()