#! /usr/bin/env python
'''
collect_gmt.py

scrapes a top level folder containing brew folders and collects all of the gmt files in
those folders.  These files are copied to the output location and concatenated in a new
gmt file

AUTHOR: Corey Flynn, Broad Institute, 2012
'''
import os
import shutil
import glob

top_dir = '/xchip/obelix/pod/brew/vc/'
brew_match_string = 'MUC.*' #the name stub to match. grab all brew folders containing this
collapse_type = 'by_pert_id_pert_dose'
output_dir = os.getcwd()

# # get a all of the folder required folders, find the gmt files in them and move them to the
# # output directory
# grabbed_folders = glob.glob(os.path.join(top_dir,brew_match_string))
# for folder in grabbed_folders:
# 	gmts = glob.glob(os.path.join(folder,collapse_type,'*.gmt'))
# 	for gmt in gmts:
		# shutil.copy(gmt,output_dir)

# # combine into DN, DN_LM, UP, and UP_LM files
# dn_files = glob.glob(os.path.join(output_dir,'*DN_n*'))
# dn_files.sort()
# up_files = glob.glob(os.path.join(output_dir,'*UP_n*'))
# up_files.sort()
# dn_lm_files = glob.glob(os.path.join(output_dir,'*DN_LM_n*'))
# dn_lm_files.sort()
# up_lm_files = glob.glob(os.path.join(output_dir,'*UP_LM_n*'))
# up_lm_files.sort()


# with open(os.path.join(output_dir,'DN.gmt'),'w') as f:
# 	for dn_file in dn_files:
# 		with open(dn_file,'r') as f2:
# 			lines = f2.readlines()
# 			for line in lines:
# 				f.write(line)
# with open(os.path.join(output_dir,'DN_LM.gmt'),'w') as f:
# 	for dn_lm_file in dn_lm_files:
# 		with open(dn_lm_file,'r') as f2:
# 			lines = f2.readlines()
# 			for line in lines:
# 				f.write(line)
# with open(os.path.join(output_dir,'UP.gmt'),'w') as f:
# 	for up_file in up_files:
# 		with open(up_file,'r') as f2:
# 			lines = f2.readlines()
# 			for line in lines:
# 				f.write(line)
# with open(os.path.join(output_dir,'UP_LM.gmt'),'w') as f:
# 	for up_lm_file in up_lm_files:
# 		with open(up_lm_file,'r') as f2:
# 			lines = f2.readlines()
# 			for line in lines:
				# f.write(line)

# find only those signatures that are the top dose
for cell in ['MCF7','NKDBA']:
	for timepoint in ['6H','24H']:
		for direction in ['DN','UP','DN_LM','UP_LM']:
			with open(os.path.join(output_dir,direction + '.gmt'),'r') as f:
				dose_dict = {}
				lines = f.readlines()
				for line in lines:
					fields = line.split('\t')
					sig_name = ':'.join(fields[0].split(':')[0:2])
					dose = float(fields[0].split(':')[2].split('_')[0])
					try:
						top_dose = dose_dict[sig_name][0]
						if dose > top_dose:
							dose_dict[sig_name] = (dose,fields[0])
					except KeyError:
						dose_dict[sig_name] = (dose,fields[0])
				with open(os.path.join(output_dir,'_'.join([direction,cell,timepoint,'top_dose.gmt'])),'w') as f2:
					for line in lines:
						fields = line.split('\t')
						sig_name = ':'.join(fields[0].split(':')[0:2])
						if dose_dict[sig_name][1] == fields[0]:
							if '_'.join([cell,timepoint]) in fields[0]:
								f2.write(line)
