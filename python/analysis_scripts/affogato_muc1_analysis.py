#!/usr/bin/env python -W ignore::DeprecationWarning
'''
affogato_muc1_analysis.py

combine MUC1 meta data with affogato meta data

AUTHOR: Corey Flynn, Broad Institute, 2012
'''

import cmap.util.progress as progress
import cmap.util.text as text
import cmap.util.tool_ops as tool_ops
import cmap.io.gct as gct
import numpy as np
import argparse
import shutil
import os

def build_parser():
    '''
    builds the command line parser to use with this tool
    '''
    parser = argparse.ArgumentParser(description = 'affogato_muc1_analysis')
    parser.add_argument('-o','--out', type = str,
                        default = os.getcwd(), 
                        help = 'The output file path')
    parser.add_argument('--alpha_path', type = str,
                        default = '/xchip/cogs/cflynn/Collab/MUC1/meta_data_join/alpha_tmp.txt', 
                        help = 'the path to the alpha meta data to use')
    parser.add_argument('--specificity_path', type = str,
                        default = '/xchip/cogs/cflynn/Collab/MUC1/meta_data_join/alpha_specificity.txt', 
                        help = 'the path to the alpha specificity data to use')
    parser.add_argument('--muc_path', type = str,
                        default = '/xchip/cogs/cflynn/Collab/MUC1/meta_data_join/muc_tmp.txt', 
                        help = 'the path to the cline database to use')
    parser.add_argument('-c','--cline_path', type = str,
                        default = '/xchip/cogs/stacks/STK029_CLINE/clinedb_v1/cline_n1515x22268.gctx', 
                        help = 'the path to the cline database to use')
    parser.add_argument('-a','--affagato_path', type = str,
                        default = '/xchip/cogs/data/build/alpha/alpha_compz_n143375x22268.gctx', 
                        help = 'the path to the cline database to use')
    parser.add_argument('-f','--file_name', type = str,
                        default = 'muc_affogato_alpha_with_meta.txt', 
                        help = 'the path to the cline database to use')
    parser.add_argument('-n','--no_folder',
                        action = 'store_false',
                        default = True, 
                        help = 'set to bypass analysis folder creation')
    return parser

def main(args):
    work_dir = tool_ops.register_tool('affogato_muc1_analysis',args,start_path=args.out,
        mk_folder=args.no_folder)

    prog = progress.DeterminateProgressBar('MUC1')

    out_file = os.path.join(work_dir,args.file_name)

    #merge meta data from alpha.map
    with open(args.muc_path,'r') as f_muc:
        with open(args.alpha_path,'r') as f_alpha:
            with open(out_file,'w') as f_out:
                
                #read in muc and alpha data
                prog.show_message('reading alpha...')
                alpha_lines = list(f_alpha)
                prog.clear()
                prog.show_message('reading muc...')
                muc_lines = list(f_muc)
                prog.clear()
                
                #get the alpha headers needed for analysis
                alpha_headers = alpha_lines.pop(0).rstrip().split('\t')
                cell_id_ind = alpha_headers.index('cell_id')
                pert_desc_ind = alpha_headers.index('pert_desc')
                pert_type_ind = alpha_headers.index('pert_type')
                pert_time_ind = alpha_headers.index('pert_time')
                pert_ss_ind = alpha_headers.index('distil_ss')
                pert_cc_ind = alpha_headers.index('distil_cc_q75')
                
                #write headers to file
                headers = muc_lines.pop(0).rstrip().split('\t')
                headers.extend(['probe average',
                    'cell_id',
                    'pert_desc',
                    'pert_type',
                    'pert_time',
                    'distil_ss',
                    'distil_cc_q75'])
                f_out.write('\t'.join(headers) + '\n')
                
                #loop through the lines and put together an output table
                cell_lines = []
                plate_names = []
                affagato_dict = {}
                num_lines = text.line_count(args.muc_path)
                for i,muc_line in enumerate(muc_lines):
                    prog.update('building output table',i,num_lines)
                    
                    #alpha data
                    alpha_desc = alpha_lines[i].rstrip().split('\t')[pert_desc_ind]
                    alpha_ss = alpha_lines[i].rstrip().split('\t')[pert_ss_ind]
                    alpha_cc = alpha_lines[i].rstrip().split('\t')[pert_cc_ind]
                    alpha_cell = alpha_lines[i].rstrip().split('\t')[cell_id_ind]
                    alpha_type = alpha_lines[i].rstrip().split('\t')[pert_type_ind]
                    alpha_time = alpha_lines[i].rstrip().split('\t')[pert_time_ind]
                    
                    #add cell line if we have not seen it yet
                    if alpha_cell not in cell_lines and alpha_cell != 'cell_id':
                        cell_lines.append(alpha_cell)

                    #add plate_name if we haven't seen it yet
                    muc_line = muc_line.rstrip().split('\t')
                    plate_name = muc_line[0].split(':')[0]
                    if plate_name not in plate_names and plate_name != 'id':
                        plate_names.append(plate_name)
                        affagato_dict.update({plate_name:[]})

                    #update the affagato dictionary with average expressions
                    if plate_name != 'id':
                        mean_reg = np.mean([float(muc_line[1]),
                                            float(muc_line[2]),
                                            float(muc_line[3])])
                        affagato_dict[plate_name].append(mean_reg)

                    #joined data
                    muc_line.extend([str(mean_reg),
                        alpha_cell,
                        alpha_desc,
                        alpha_type,
                        alpha_time,
                        alpha_ss,
                        alpha_cc,])
                    f_out.write('\t'.join(muc_line) + '\n')
                for k,v in affagato_dict.iteritems():
                    affagato_dict[k] = [np.mean(v),
                                        np.take(v,np.where(np.array(v) < -2)).size,
                                        [str(x) for x in v]]
                prog.clear()

    #make a dictionary of cell_lines and their base cline expression
    cline_data = gct.GCT()
    prog.show_message('finding muc cline inds...')
    cline_muc_rinds = cline_data.get_gctx_rid_inds(args.cline_path,match_list=['207847_s_at',
                                                                                '211695_x_at',
                                                                                '213693_s_at'])
    prog.clear()
    cline_dict = {}
    for i,cell_line in enumerate(cell_lines):
        prog.update('building cline dict',i,len(cell_lines))
        cline_cell_cinds = cline_data.get_gctx_cid_inds(args.cline_path,match_list=cell_line)
        cline_data.read_gctx_matrix(args.cline_path,col_inds=cline_cell_cinds,
                                                    row_inds=cline_muc_rinds)
        try:
            cline_dict[cell_line] = np.mean(cline_data.matrix)
        except TypeError:
            cline_dict[cell_line] = 'N/A'
    prog.clear()

    #add entries to table
    with open(out_file,'r') as f:
        with open(args.specificity_path,'r') as f_spec:
            with open(out_file + 'tmp','w') as f_out:
                #read in muc and alpha data
                prog.show_message('reading data table...')
                lines = list(f)
                prog.clear()

                prog.show_message('reading specificity data table...')
                spec_lines = list(f_spec)
                prog.clear()

                #grab the cell line appropriate cline expression and plate appropriate affagato 
                #regulation for each line and write it to file
                headers = lines.pop(0).rstrip().split('\t')
                cell_ind = headers.index('cell_id')
                headers.extend(['cline_expression','average plate regulation',
                    'number of MUC1 regulators on plate','pert_specificity'])
                f_out.write('\t'.join(headers) + '\n')
                for i,line in enumerate(lines):
                    line = line.rstrip()
                    spec_line = spec_lines[i].rstrip()
                    prog.update('building output table',i,num_lines)
                    line = line.split('\t')
                    spec_line = spec_line.split('\t')
                    muc_exp = [float(line[1]),float(line[2]),float(line[3])]
                    muc_exp = np.mean(muc_exp)
                    cline_exp = cline_dict[line[cell_ind]]
                    line.append(str(cline_exp))
                    affagato_reg = affagato_dict[line[0].split(':')[0]][0]
                    affagato_specificity = affagato_dict[line[0].split(':')[0]][1]
                    line.append(str(affagato_reg))
                    line.append(str(affagato_specificity))
                    line.append(spec_line[1])
                    f_out.write('\t'.join(line) + '\n')

                prog.clear()
    shutil.move(out_file + 'tmp', out_file)

if __name__ == '__main__':
    parser = build_parser()
    args = parser.parse_args()
    main(args)