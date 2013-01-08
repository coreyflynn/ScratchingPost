
# utility script to build normalized gct files from a list of CEL files in BGED
# uses gse2gct and gex2norm
#
# USAGE:
# CEL2QNORM expList
#
# VARIABLE DEFINTIONS
# expList: the text file containing a list of CEL files for each experiment to be used
#
# output files are placed in the same directory as the expList

# generate the ouput directory name
outputDir=`dirname $1`
fileBase=`basename $1 _tag.xls`

echo $outputDir/$fileBase"_"gex.gct

# run gse2gct
/xchip/cogs/bin/gse2gct -t $1 -o $outputDir -c && /xchip/cogs/matlib/bin/rum -q local gex2norm -res $outputDir/$fileBase"_"gex.gct