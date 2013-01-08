'''
Created on Jan 9, 2012

@author: cflynn
utility modules for text processing
'''

def line_count(input_file):
    """
    Return the number of lines in input_file 
    """
    i = -1
    with open(input_file) as f:
        for i, line in enumerate(f): #@UnusedVariable
            pass
    
    return i + 1


if __name__ == '__main__':
    lc = line_count('text.py')
    print lc