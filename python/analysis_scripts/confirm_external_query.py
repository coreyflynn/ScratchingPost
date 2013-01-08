#! /usr/bin/env python
'''
confirm_external_query.py

scrapes the output of a run of query_tool and confirms that the 

AUTHOR: Corey Flynn, Broad Institute, 2012
'''
import glob
import os
import cmap.util.mongo_utils as mu
import cmap.io.plategrp as grp

# folder_to_scrape = '/xchip/cogs/projects/MUC1/cf_work/cp_affogato_connections/nov12/my_analysis.query_tool.2012111220125791/'
# folder_to_scrape = '/xchip/cogs/projects/MUC1/cf_work/cp_affogato_connections/nov12/my_analysis.query_tool.2012111215302591/'
folder_to_scrape = '/xchip/cogs/projects/MUC1/cf_work/cp_affogato_connections/nov12/my_analysis.query_tool.2012111214400391/'
output_folder = '/xchip/cogs/projects/MUC1/cf_work/cp_affogato_connections'

# find the tail files in the folder
tail_files = glob.glob(os.path.join(folder_to_scrape,'tail*'))

# for each tail file, figure out if the appropriate pert_id/cell_id combo is in 
# the tail file.  If it is in the tail file, report its rank.
hits = []
cell_hits = []
not_in_mongo = []
top_dose = []
CM = mu.CMapMongo()
hit_tracker = 0
for tf in tail_files:
	file_cell_id = os.path.basename(tf).split('_')[3]
	file_pert_id = os.path.basename(tf).split('_')[5]
	file_dose = float(os.path.basename(tf).split('_')[6][0:-4])
	if file_dose > 5:
		top_dose.append(file_pert_id)
		mongo_ping = CM.find({'pert_id':file_pert_id},{'sig_id':True},limit=1)
		if mongo_ping:
			# file_cell_id = 'MCF7'
			# file_pert_id = 'BRD-K49587132-001-01-3'
			# with open('/xchip/cogs/projects/MUC1/cf_work/cp_affogato_connections/nov11/my_analysis.query_tool.2012111123212991/tail_ESLM_MUC.CP001_MCF7_6H_BRD-A19037878-001-02-3_10.00.txt','r') as f:
			with open(tf,'r') as f:
				headers = f.readline().split('\t')
				cell_id_ind = headers.index('cell_id')
				pert_id_ind = headers.index('pert_id')
				lines = f.readlines()
				for i,line in enumerate(lines):
					fields = line.split('\t')
					line_cell_id = fields[cell_id_ind]
					line_pert_id = fields[pert_id_ind]
					line_pert_id = '-'.join(line_pert_id.split('-')[0:2])
					if line_pert_id in file_pert_id:
						if hit_tracker == 0:
							hits.append(file_pert_id)
							hit_tracker = 1
						if file_cell_id == line_cell_id:
							cell_hits.append(file_pert_id)
							break
		else:
			not_in_mongo.append(file_pert_id)
	hit_tracker = 0
num_top_dose = len(set(top_dose))
num_hits = len(set(hits))
num_cell_hits = len(set(cell_hits))
num_no_mongo = len(set(not_in_mongo))
print('{0}/{1}({2:.2f}%) connect across all cell lines'.format(num_hits,num_top_dose - num_no_mongo,
									float(num_hits)/(num_top_dose - num_no_mongo)*100))
print('{0}/{1}({2:.2f}%) connect within cell line'.format(num_cell_hits,num_top_dose - num_no_mongo,
									float(num_cell_hits)/(num_top_dose - num_no_mongo)*100))
grp.write_grp(hits,os.path.join(output_folder,'hits.grp'))