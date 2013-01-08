#! /usr/bin/env python

#funciton to compute the confusion matrix of two files in .clu format.
'''
USAGE:
python confusionMatrix input1FilePath input2FilePath
'''

if __name__ == "main":
    #imports
    import sys
    
    #function definitions
    def build_class_dict(f):
        '''
        utility funciton to build a class label dictionary from an input list in the provided
        .clu file
        '''
        #initialize a dictionary to hold sample name keys and class values
        classDict = {}
        #read in the file and all of the line in the file
        lines = f.xreadlines()
        for line in lines:
            if '1:' in line:
                classID = 1
            if '2:' in line:
                classID = 2
            if '3:' in line:
                classID = 3
            classDict[line] = classID
        return classDict
        
    def find_optimal_class(input1Class,input1ClassDict,input2ClassDict):
        '''
        Utility function to find the optimal class labeling match for all of the class labels in the
        first input file.  This is used to fix cases where the class label mapping is not direct. For
        example if class 1 is labeled as class 2 in the second data set.
        '''
        classSums = [0,0,0]
        for key in input1ClassDict.keys():
            if input1ClassDict[key] == input1Class:
                classSums[input2ClassDict[key]-1] +=1
        return classSums.index(max(classSums))+1
    
    #main 
    #parse the input arguments
    try:
        input1FilePath = sys.argv[1]
        f = open(input1FilePath,'r')
        input2FilePath  = sys.argv[2]
        f2 = open(input2FilePath,'r')
    except IndexError:
        print (__doc__)
        sys.exit(0)
    except IOError:
        print (__doc__)
        sys.exit(0)
    
    #build a class mapping dictionary for each input file
    input1ClassDict = build_class_dict(f)
    input2ClassDict = build_class_dict(f2)
    
    #build a 3x3 list to hold the entries in the confusion matrix
    confusionMatrix = [[0,0,0],[0,0,0],[0,0,0]]
    
    #find the optimal class alignment for each of the 3 classes
    class1mapping = find_optimal_class(1,input1ClassDict,input2ClassDict)
    class2mapping = find_optimal_class(2,input1ClassDict,input2ClassDict)
    class3mapping = find_optimal_class(3,input1ClassDict,input2ClassDict)
    
    #fix any mapping discrepencies between cluster labels
    for key in input2ClassDict.keys():
        val = input2ClassDict[key]
        if val == 1:
            input2ClassDict[key] = class1mapping
        if val == 2:
            input2ClassDict[key] = class2mapping
        if val == 3:
            input2ClassDict[key] = class3mapping
    
    #for all of the keys in the first input, find the class value for it in each dictionary and update
    #the confusion matrix
    for key in input1ClassDict.keys():
        confusionMatrix[input1ClassDict[key]-1][input2ClassDict[key]-1] += 1
        
    percentCorrect = float(confusionMatrix[0][0]+confusionMatrix[1][1]+confusionMatrix[2][2])/len(input1ClassDict.keys())
    
    #print confusion matrix summary
    print "Confusion Matrix:"
    print "\tC1\tC2\tC3"
    print "C1\t%i\t%i\t%i" % (confusionMatrix[0][0], confusionMatrix[0][1], confusionMatrix[0][2])
    print "C2\t%i\t%i\t%i" % (confusionMatrix[1][0], confusionMatrix[1][1], confusionMatrix[1][2])
    print "C3\t%i\t%i\t%i" % (confusionMatrix[2][0], confusionMatrix[2][1], confusionMatrix[2][2])
    print "Percent Correct = %2.2f" % (round(percentCorrect,2))



    