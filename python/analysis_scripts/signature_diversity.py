#! /usr/bin/env python
import cmap.util.mongo_utils as mu
import cmap.analytics.cluster as cluster
import cmap.util.queue as queue
import os
import glob
import pandas as pd
import jinja2
import cmap

def _worker1(input, output):
    '''run the clustering for all descs in parrallel'''
    for desc in iter(input.get, 'STOP'):
		sigs = CM.find({'pert_desc':desc,'is_gold':1,'sig_id':{'$regex':'CPC006'},'pert_time':6},{'sig_id':1});
		hclust_name = desc.replace('.','_')
		hclust_name = desc.replace('.','_')
		path = '/xchip/cogs/projects/SigDiv/cfwork/html/' + desc + '/'
		if not os.path.exists(path):
			os.mkdir(path)
		
			if sigs != 0:
				hclust = cluster.HClust(sigs)
				hclust.cluster()
				hclust.name = hclust_name
				hclust.name = hclust_name
				hclust.get_labels_from_mongo('cell_id')
				hclust.save_clustered_distance_matrix(path)
				hclust.save_label_matrix(path)
				hclust.write_signature_annotations_table(path=path,mode='lineage')
				hclust.write_cluster_annotations_table(path=path)
				with open(os.path.join(path,desc + '_summary.txt'),'w') as f:
					f.write('\t'.join(['compound','# input signatures','# signature classes','signature diversity']) + '\n')
					f.write('\t'.join([desc,str(len(sigs)),str(hclust.num_clusters),str(hclust.sig_diversity)]) + '\n')
				for i in range(hclust.num_clusters):
					hclust.save_heatmap_for_cluster(i+1,path)
				print('finished {0}'.format(desc))

				# build an index page
				cmap_base_dir = '/'.join(os.path.dirname(cmap.__file__).split('/')[0:-1])
				env = jinja2.Environment(loader=jinja2.FileSystemLoader(cmap_base_dir + '/templates'))
				template = env.get_template('Sig_Diversity_Detail_Template.html')

				heatmap_tuples = []
				heatmaps = glob.glob(os.path.join(path,'*_cluster*_heatmap.png'))
				heatmaps.sort()
				for i,heatmap in enumerate(heatmaps):
					heatmap_tuples.append((os.path.basename(heatmap),'Cluster{0}'.format(i+1)))
				with open(os.path.join(path,'index.html'),'w') as f:
					f.write(template.render(distance_image=hclust_name + '_distance_matrix.png',
											label_image=hclust_name+'_label_matrix.png',
											heatmap_tuples=heatmap_tuples,
											title=hclust.name,
											annot_path=hclust.name + '_cell_lineage_annotations.txt',
											cluster_data_path=hclust.name + '_cluster_annotations.txt'))



				output.put(desc)
			else:
				print('no sigs for {0}'.format(desc))
				output.put(desc)
		else:
				print('already computed {0}'.format(desc))
				output.put(desc)

# CM = mu.CMapMongo()
# descs = CM.find({'is_gold':1,'sig_id':{'$regex':'CPC006'},'pert_time':6},{'pert_desc':1})
# descs = list(set(descs))
# sd = []
# res = queue.q_runner(descs, _worker1)

cp_dirs = [x[0] for x in os.walk('/xchip/cogs/projects/SigDiv/cfwork/html/')]
d = {}
for cpd in cp_dirs[1:]:
    base = os.path.basename(cpd)
    summary_path = os.path.join(cpd,base + '_summary.txt')
    if os.path.exists(summary_path):
	    with open(summary_path,'r') as f:
	        f.readline()
	        fields = f.readline().strip().split('\t')
	        html_text = '''<td><a class="btn btn-mini" href="{0}"><i class="icon-list"></i> Cluster Details</a>'''.format(base)
	        d.update({fields[0]: pd.Series([fields[1],fields[2],'{0:.2f}'.format(float(fields[3])),html_text], index = ['# signatures','# classes','signature diversity','cluster detail'])})
        
df = pd.DataFrame(d)
df = df.T
df.to_csv('/xchip/cogs/projects/SigDiv/cfwork/html/full_summary.txt',sep='\t')

# cmap_base_dir = '/'.join(os.path.dirname(cmap.__file__).split('/')[0:-1])
# env = jinja2.Environment(loader=jinja2.FileSystemLoader(cmap_base_dir + '/templates'))
# template = env.get_template('Sig_Diversity_Detail_Template.html')

# heatmap_tuples = []
# for sf in sum_files:
# 	basename = os.path.basename(sf).split('.txt')[0]
# 	basename = basename.replace('.','_')
# 	basename = basename.replace(' ','_')
# 	heatmaps = glob.glob(basename + '*_cluster*_heatmap.png')
# 	for i,heatmap in enumerate(heatmaps):
# 		heatmap_tuples.append(os.path.basename(heatmap),'Cluster {0}'.format(i+1))
# 	with open('/xchip/cogs/cflynn/tmp/sig_div/{0}_cluster_detail.html'.format(basename),'w') as f:
# 		f.write(template.render(distance_image=basename+'distance_matrix.png',label_image=basename+'label_matrix.png',heatmap_tuples=heatmap_tuples))
