'''
 Construct an annotations .sdf file for use in instance generation for CMap database builds. The
 function operates on an input file that should have columns containing the following fields:
 "DRUG_NAME"
 "CELL_LINE"
 "CELL_FILE_NAME(INSTANCE)"
 "CELL_FILE_NAME(VEHICLE)"
 
 Other fields are acceptable and will be included in the output file as well.  This function will
 use the values in DRUG_NAME and CELL_LINE to generate unique instance names for each instance-vehicle
 control pair of the form DRUG_NAME_CELL_LINE_X 

 USAGE:
 python CMapBuildAnnotationsSdf inputFilePath outputFilePath

 VARIABLE DEFINITIONS:
 inputFilePath: the path to the file to be read
 outputFilePath: the path to file to be written to
'''
if __name__ == "main":
    #imports
    import sys
    
    #parse input
    try:
        f = open(sys.argv[1],'rU')
        f2 = open(sys.argv[2],'w')
    except IndexError:
        print (__doc__)
        sys.exit(0)
    except IOError:
        print (__doc__)
        sys.exit(0)    
        
    #read the column names in the input file and create a list containing them
    cNames = f.readline()
    cNames = cNames.split()
    
    #find the indexes of required fields
    DRUG_NAME_IND = cNames.index('DRUG_NAME')
    CELL_LINE_IND = cNames.index('CELL_LINE')
    TREATMENT_IND = cNames.index('CELL_FILE_NAME(INSTANCE)')
    VEHICLE_IND = cNames.index('CELL_FILE_NAME(VEHICLE)')
    
    #write the header column names to the output file
    for cName in cNames:
        f2.write(cName + '\t')
    f2.write('INSTANCE_NAME\t')
    f2.write('INSTANCE_METHOD\t')
    f2.write('TREATMENT\t')
    f2.write('VEHICLE\n')
    
    
    #for each data line, check to see if there is already a DRUG_NAME_CELL_LINE pair in a running 
    #dictionary.  If there is not, add the entry to the dictionary and give it a value of 1.  If there 
    #is an entry for it, increment the value strored in that entry key by 1.  Use this mapping to create
    #unique DRUG_NAME_CELL_LINE_X INSTANCE_NAMES, where X is the current value of the key. Once this is 
    #done, write the data for that line to file 
    INSTANCE_NAME_DICT = {}
    lines = f.xreadlines()
    for line in lines:
        fields = line.split()
        currentKey = fields[DRUG_NAME_IND] + '_' + fields[CELL_LINE_IND]
    
        #dictionary check
        if currentKey in INSTANCE_NAME_DICT:
            val = INSTANCE_NAME_DICT[currentKey]
            val += 1
            INSTANCE_NAME_DICT[currentKey] = val
        else:
            INSTANCE_NAME_DICT[currentKey] = 1
        
        #instance name generation
        currentInstanceName = currentKey + '_' + str(INSTANCE_NAME_DICT[currentKey])
        
        #write data to file
        for field in fields:
            f2.write(field + '\t')
        f2.write(currentInstanceName + '\t')
        f2.write('L1000\t')
        f2.write(fields[TREATMENT_IND] + '\t')
        f2.write(fields[VEHICLE_IND] + '\n')
    f.close()
    f2.close()