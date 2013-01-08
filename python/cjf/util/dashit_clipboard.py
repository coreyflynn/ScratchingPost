'''
dahsit-clipboard takes the text on the clipboard and replaces all underscores with dashes

USAGE:
dashit-clipboard

INPUT VARIABLES:
there are no inputs to this script

Author: Corey Flynn, Broad institute, 2011
'''

if __name__ == "main":
    #imports
    import subprocess
    
    cmd = ['pbpaste | sed s/_/-/g']
    p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
    for line in p.stdout:
        print line
    p.wait()