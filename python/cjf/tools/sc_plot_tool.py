#! /usr/bin/env python
'''
Simplified command line interface for the construction of SC plots.  This module wraps 
cjf.cmap.analytics.sc in order to facilitate non-interactive use. 
Created on Apr 6, 2012
@author: Corey Flynn, Broad Institute
'''
if __name__ == '__main__':
    import sys
    import os
    from optparse import OptionParser
    import cjf.cmap.analytics.sc as sc
    
    #redirect stderr to catch the known 0.99 matplotlib DeprecationWarning "Use the new widget gtk.Tooltip"
    sys.stderr = open(os.devnull,"w")
    
    #parse input arguments
    usage = "usage: %prog [options]"
    parser = OptionParser(usage=usage)
    parser.set_defaults(brew=None,grp=None,s_thresh=6,c_thresh=0.25,out=None,xlabel='CC',
                        ylabel='SS',title=None, control=None, include=None, exclude=None)
    parser.add_option("--brew",dest="brew",
                      help="the name of a source brew folder to use for the plot")
    parser.add_option("--grp",dest="grp",
                      help="path to a grp file of brew folders to use for the plot")
    parser.add_option("--s_thresh",dest="s_thresh",
                      help="the sig strength cutoff to use")
    parser.add_option("--c_thresh",dest="c_thresh",
                      help="the correlation cutoff to use")
    parser.add_option("-o","--out",dest="out",
                      help="output file name for the plot, display on screen if not set")
    parser.add_option("--xlabel",dest="xlabel",
                      help="the x axis label for the graph")
    parser.add_option("--ylabel",dest="ylabel",
                      help="the y axis label for the graph")
    parser.add_option("--title",dest="title",
                      help="the title for the graph")
    parser.add_option("--control",dest="control",
                      help="a string to use as control id.")
    parser.add_option("--include",dest="include",
                      help="a string to use for included ids.")
    parser.add_option("--exclude",dest="exclude",
                      help="a string to use for excluded ids.")
    

    (options, args) = parser.parse_args()
    
    #make sure only one of brew and grp is specified
    if options.brew and options.grp:
        parser.error("please set --brew or --grp, but not both")
    if not options.brew and not options.grp:
        parser.error("please set --brew or --grp")
    
    #instantiate and SC instance and populate it with data
    SCObj = sc.SC()
    if options.brew:
        SCObj.add_sc_from_brew(options.brew)
    if options.grp:
        SCObj.add_sc_from_grp(options.grp)
    
    #make the sc plot
    SCObj.plot(s_thresh=options.s_thresh, c_thresh=options.c_thresh, out=options.out,
               xlabel=options.xlabel, ylabel=options.ylabel, title=options.title,
               control=options.control, include=options.include, exclude=options.exclude)