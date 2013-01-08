#! /usr/bin/env python
"""
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
"""
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
    SM_NAME_IND = cNames.index('sm:name')
    SM_DESC_IND = cNames.index('sm:desc')
    SM_VEHICLE_IND = cNames.index('sm:vehicle_name')
    
    #write the header column names to the output file
    f2.write('INSTANCE_NAME\t')
    f2.write('INSTANCE_METHOD\t')
    f2.write('TREATMENT\t')
    f2.write('VEHICLE\t')
    for cName in cNames:
        f2.write(cName + '\t')
    f2.write('\n')
    
    #for each line, write the four requred sdf fields and then append the original .sin file collumns.
    #for cases where there are more than one control, prepend the sample treatment cel file name to the
    #control cases
    lines = f.xreadlines()
    for line in lines:
        fields = line.split('\t')
        f2.write(fields[SM_DESC_IND] + '\t')
        f2.write('L1000\t')
        f2.write(fields[SM_NAME_IND] + '\t')
        baseName = fields[SM_NAME_IND].split('.')[0].split('-')[0]
        controls = fields[SM_VEHICLE_IND].split('.')
        if len(controls) > 1:
            f2.write(baseName + '.' + controls[1])
            for ii in range(2,len(controls)):
                f2.write(',' + baseName + '.' + controls[ii])
        else:
            f2.write(controls[0])
        f2.write('\t')
        f2.write(line)
    
    f.close()
    f2.close()