#! /usr/bin/env python
'''
Tool used to compare signatures of the same treatments across different contexts (cell lines
or other). The tool assumes that there exists a tag file for each dataset to be analyzed
with a matching name in the same directory 
Created on Jan 17, 2012

@author: cflynn
'''
import os

def find_tags(search_root):
    '''
    Collect all of the .tag files in the specified folder and return their full paths in
    a list.  
    '''
    walk_result = os.walk(search_root)
    file_list = []
    for res in walk_result:
        root = res[0]
        for file_name in res[2]:
            file_list.append(root + '/' + file_name)
    tag_list = filter(is_tag,file_list)
    return tag_list

def is_tag(s):
    '''
    Function for filtering lists to contain '.rnk'
    '''
    if s.find("_tag") == -1:
        return False
    else:
        return True

 
if __name__ == '__main__':
    from optparse import OptionParser
    import sys
    
    import cjf.cmap.analytics.signature_strength as sc
    
    #parse input arguments
    usage = "usage: %prog [options] input_dir"
    parser = OptionParser(usage=usage)
    parser.set_defaults(json=True,summary=True,rnk=True,html=True,table=True,output=os.getcwd())
    parser.add_option("-i","--input_dir",dest="input_dir",
                      help="the top level directory to be analyzed")
    parser.add_option("-o","--out",dest="out",
                      help="write output to DIR [default=pwd]")
    parser.add_option("--nojson",dest="json",action="store_false",
                      help="suppress json file creation")
    parser.add_option("--nohtml",dest="html",action="store_false",
                      help="suppress html file creation")
    parser.add_option("--nosummary",dest="summary",action="store_false",
                      help="suppress summary file creation")
    parser.add_option("--notable",dest="table",action="store_false",
                      help="suppress summary table file creation")
    parser.add_option("--nornk",dest="rnk",action="store_false",
                      help="suppress .rnk file creation")
    (options, args) = parser.parse_args()
    
    #if the user has supplied an input directory proceed, if not print help
    if options.input_dir:
        #create .rnk files unless suppressed
        if options.rnk:
            #find all tag files under the input directory
            tag_files = find_tags(options.input_dir)
            
            #for each tag file, make .rnk files for all phenotypes
            for tag_file in tag_files:
                tag_dir = os.path.dirname(tag_file)
                tag_name_base = os.path.basename(tag_file).split('_tag')[0]
                tag_dir_files = os.listdir(tag_dir)
                
                print('making .rnk files for ' + tag_file)
                
                #if there is no 'rnk' folder, create it
                if 'rnk' not in tag_dir_files:
                    os.mkdir(os.path.join(tag_dir,'rnk'))
                
                #make .rnk files
                for tag_dir_file in tag_dir_files:
                    if tag_name_base and '.gct' in tag_dir_file:
                        sc.make_rnks_from_tag(os.path.join(tag_dir,tag_dir_file), 
                                              tag_file, 
                                              os.path.join(tag_dir,'rnk'),
                                              do_median=True)
        
        if options.summary:
            print('building summary file')
            sc.sig_strength_summary_from_rnk(options.input_dir, 
                                    os.path.join(options.out,
                                                 'signature_strength_summary.txt'))
        if options.table:
            print('building summary table file')
            sc.sig_strength_summary_to_table(os.path.join(options.out,
                                                   'signature_strength_summary.txt'),
                                             os.path.join(options.out,
                                                   'signature_strength_summary_table.txt'))
        if options.json:
            print('building JSON file')
            sc.sig_strength_summary_to_json(os.path.join(options.out,
                                            'signature_strength_summary.txt'), 
                                            json_file=os.path.join(options.out,
                                            'signature_strength.json'))
        if options.html:
            print('building HTML file')
            sc.make_sig_strength_html(os.path.join(options.out,
                                                   'signature_strength_summary.txt'),
                                      options.out,
                                      file_name='context_comparison')
            
    else:
        print "INPUT_DIR must be specified"
        parser.print_help()
        sys.exit(0)