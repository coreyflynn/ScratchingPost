#! /usr/bin/env python
"""
generates an html based heatmap given a dataset, tag_file, phenotype, and rnk file
Created on Feb 3, 2012
@author: Corey Flynn, Broad Institute
"""
import os
import csv
import json

import BeautifulSoup

import cjf.cmap.io.gct as cjf_gct
import cjf.cmap.util.text as cjf_text
import cjf.cmap.util.url as cjf_url

def get_heatmap_data(gct_file,tag_file,rnk_file,phenotype_name):
    '''
    extract the samples specified under phenotype_name in tag_file from gct_file.  Use
    rnk_file to grab the top and bottom 50 probes and return them in a JSON object for
    use in building a html heatmap.  Additionally, return the order in which to display
    the samples in the data set.
    '''
    #read in gct data
    gct_data = cjf_gct.parse_gct_dict(gct_file)
    
    
    #read in the tag file and make a dictionary with of the phenotypes members as keys and the 
    #samples in those phenotypes as the values
    control_classes = ['EMPTY','DMSO']
    phenotypes = {}
    reader = csv.DictReader(open(tag_file,'rU'), delimiter='\t')
    for row in reader:
        for col,val in row.iteritems():
            if 'Sample_id' not in col:
                if phenotype_name in col:
                    if val and phenotype_name in val:
                        if "Exp" not in phenotypes.keys():
                            phenotypes["Exp"] = [row['Sample_id']]
                        else:
                            phenotypes["Exp"].append(row['Sample_id'])
                    if val and val in control_classes:
                        if "Control" not in phenotypes.keys():
                            phenotypes["Control"] = [row['Sample_id']]
                        else:
                            phenotypes["Control"].append(row['Sample_id'])
    
    #grab the probe order from the rnk file
    num_lines = cjf_text.line_count(rnk_file)
    probe_order = []
    with open(rnk_file) as f:
        for i,line in enumerate(f):
            if i < 49:
                probe_order.append(line.split('\t')[0])
            if i >= num_lines - 50:
                probe_order.append(line.split('\t')[0])

    #make a list of dictionaries each containing a probeName, and entries for each 
    #sample:value pair
    probe_dictionary_list= []
    for probe in probe_order:
        probe_dict = {"probeName":probe}
        for exp in phenotypes["Exp"]:
            probe_dict.update({exp.replace(':','_'):str(gct_data['SAMPLES'][exp][probe])})
        for control in phenotypes["Control"]:
            probe_dict.update({control.replace(':','_'):str(gct_data['SAMPLES'][control][probe])})
        probe_dictionary_list.append(probe_dict)
    
    #make sure that the experimental samples are returned first
    sample_order_list = ["probeName"]
    for exp in phenotypes["Exp"]:
        sample_order_list.append(exp.replace(':','_'))
    for control in phenotypes["Control"]:
        sample_order_list.append(control.replace(':','_'))
    
    #make JSON data and return it 
    probe_json = json.dumps(probe_dictionary_list,sort_keys=False)
    sample_order_json = json.dumps(sample_order_list,sort_keys=False)
    return (probe_json,sample_order_json)

def make_heatmap_html(probe_json, sample_order_json, out_dir, **kwargs):
    """
    construct the heatmap html file from a template html file, probe_json, and sample_order_json
    """
    #parse kwargs
    if "file_name" in kwargs.keys():
        file_name = kwargs["file_name"]
    else:
        file_name = "index"
    
    #open the template file from the cogs server
    heatmap_template = cjf_url.cogs_open('http://www.broadinstitute.org/cogs/cfwork/html_templates/heatmap_template.html')
    
    #place data into the template html heatmap file
    soup = BeautifulSoup.BeautifulSoup(heatmap_template.read())
    scripts = soup.findAll('script')
    for script in scripts:
        if "//place heatmap JSON data here" in script.text:
            script.setString("var data = " + probe_json +
                             ";\n var sort_order = " + sample_order_json +  
                             ";\n var sorted_data = [];\n" + 
                             "for (var i in data){\ntmp_obj = new Object();\n" + 
                             "for (var j in sort_order){\ntmp_obj[sort_order[j]] = data[i][sort_order[j]];}\n" + 
                             "sorted_data.push(tmp_obj);};\n" + 
                             "draw_heatmap(sorted_data);\n")

    with open(os.path.join(out_dir,file_name + ".html"), 'w') as f_out:
        f_out.write(soup.prettify())
                     
def heatmap_from_full_gct(input_gct,file_name):
    ''''
    makes a heatmap from the full input gct file and places it in output_html
    '''
    #read file and put it into a JSON object array
    with open(input_gct,'r') as f:
        f.readline()
        [probe_num, sample_num, rhd_num, chd_num] = f.readline().rstrip().split('\t') #@UnusedVariable
        cid = f.readline().rstrip().split('\t')[1+int(rhd_num):]
        for i in range(int(chd_num)): #@UnusedVariable
            f.readline()
        lines = f.xreadlines()
        data_list = []
        for line in lines:
            split_line = line.rstrip().split('\t')
            tmp_dict = {'probeName':split_line[0]}
            for i,entry in enumerate(split_line[1:]):
                tmp_dict[cid[i]] = entry
            data_list.append(tmp_dict)
    probe_json = json.dumps(data_list,sort_keys=False)
    cid.append("probeName")
    sample_order_json = json.dumps(cid,sort_keys=False)
        
    #open the template file from the cogs server
    heatmap_template = cjf_url.cogs_open('http://www.broadinstitute.org/cogs/cfwork/html_templates/heatmap_template.html')
    
    #place data into the template html heatmap file
    soup = BeautifulSoup.BeautifulSoup(heatmap_template.read())
    scripts = soup.findAll('script')
    for script in scripts:
        if "//place heatmap JSON data here" in script.text:
            script.setString("var data = " + probe_json +
                             ";\n var sort_order = " + sample_order_json +  
                             ";\n var sorted_data = [];\n" + 
                             "for (var i in data){\ntmp_obj = new Object();\n" + 
                             "for (var j in sort_order){\ntmp_obj[sort_order[j]] = data[i][sort_order[j]];}\n" + 
                             "sorted_data.push(tmp_obj);};\n" + 
                             "draw_heatmap(sorted_data);\n")

    with open(file_name + ".html", 'w') as f_out:
        f_out.write(soup.prettify())

if __name__ == '__main__':
    from optparse import OptionParser
    
    #parse input arguments
    usage = "usage: %prog [options]"
    parser = OptionParser(usage=usage)
    parser.set_defaults(file_name="index",output_dir=os.getcwd())
    parser.add_option("-i","--input",dest="input_gct",
                      help="path to the gct file to be used")
    parser.add_option("-t","--tag-file",dest="tag_file",
                      help="path to the tag file to be used")
    parser.add_option("-r","--rnk-file",dest="rnk_file",
                      help="path to the rnk file to be used")
    parser.add_option("-p","--phenotype",dest="phenotype",
                      help="the name of the phenotype to generate a heatmap for")
    parser.add_option("-o","--out",dest="output_dir",
                      help="write output to DIR [default=pwd]")
    parser.add_option("-f","--file-name",dest="file_name",
                      help="the name of the html file to generate (.html is added automatically)")

    (options, args) = parser.parse_args()
    
    #handle option errors
    if not options.input_gct:
        parser.error("INPUT_GCT must be specified")
    if not options.tag_file:
        parser.error("TAG_FILE must be specified")
    if not options.rnk_file:
        parser.error("RNK_FILE must be specified")
    if not options.phenotype:
        parser.error("PHENOTYPE must be specified")
    
    #make heatmap
    probe_json, sample_order_json = get_heatmap_data(options.input_gct,
                                                     options.tag_file,
                                                     options.rnk_file,
                                                     options.phenotype)
    make_heatmap_html(probe_json, sample_order_json,
                      options.output_dir,file_name=options.file_name)
    