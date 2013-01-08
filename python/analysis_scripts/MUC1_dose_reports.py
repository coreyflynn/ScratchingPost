#! /usr/bin/env python
import os
import shutil
import cmap.util.text as text

base_path = '/xchip/cogs/cflynn/tmp/Nov09/dose_analysis_tool.1352506461456/'
out_path = '/xchip/cogs/cflynn/tmp/Nov09/dose_analysis_tool.1352506461456/MCF7_cp'
text.demacify(os.path.join(base_path,'MCF7_cps.txt'))
with open(os.path.join(base_path,'MCF7_cps.txt'),'r') as f:
	f.readline()
	lines = f.readlines()
	for line in lines:
		fields = line.split('\t')
		image_base = ':'.join(fields[0:2])
		im_path = os.path.join(base_path,image_base + '_207847_s_at_dose_curve.png').replace(':','_')
		shutil.copyfile(im_path,os.path.join(out_path,image_base + '_207847_s_at_dose_curve.png').replace(':','_'))

base_path = '/xchip/cogs/cflynn/tmp/Nov09/dose_analysis_tool.1352506461456/'
out_path = '/xchip/cogs/cflynn/tmp/Nov09/dose_analysis_tool.1352506461456/NKDBA_cp'
text.demacify(os.path.join(base_path,'NKDBA_cps.txt'))
with open(os.path.join(base_path,'NKDBA_cps.txt'),'r') as f:
	f.readline()
	lines = f.readlines()
	for line in lines:
		fields = line.split('\t')
		image_base = ':'.join(fields[0:2])
		im_path = os.path.join(base_path,image_base + '_207847_s_at_dose_curve.png').replace(':','_')
		shutil.copyfile(im_path,os.path.join(out_path,image_base + '_207847_s_at_dose_curve.png').replace(':','_'))