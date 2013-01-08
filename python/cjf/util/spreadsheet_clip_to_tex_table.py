#! usr/bin/env python
'''
dahsit-clipboard takes the text on the clipboard and replaces all underscores with dashes

USAGE:
dashit-clipboard

INPUT VARIABLES:
there are no inputs to this script

Author: Corey Flynn, Broad institute, 2011
'''


#imports
import subprocess


#print the required latex table setup
print '\\begin{table}[htbp]'
print '\\centering'
print '\\topcaption{} % requires the topcapt package'
print '\\begin{tabular}{@{} ccccccccccc @{}} % Column formatting, @{} suppresses leading/trailing space'
print '\\toprule'



cmd = ["pbpaste | sed 's/_/-/g' | tr -s '\011' '&' | sed 's/$/\\\\/' | sed 's/$/\\\\/'"]
p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
for line in p.stdout:
	print line
p.wait()

#print the required latex table closing
print '\\bottomrule'
print '\\end{tabular}'
print '\\label{}'
print '\\end{table}'