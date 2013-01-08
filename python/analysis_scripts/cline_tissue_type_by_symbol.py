import cmap.io.gct as gct

#open the cline gene data
cline_path = '/xchip/cogs/data/vdb/cline/cline_gene_n1515x12716.gctx'
cline = gct.GCT(cline_path)

#find the index for the desired gene
gene_ind = cline.get_gctx_rid_inds(cline_path,'MUC1',exact=True)

# for each cell line in the file, if the gene is expressed over a baseline
# of 6, count it as a possitive.  if it is not count it as a negative. Keep
# a running proportion of all tissue types and their gene expression for the 
# desired gene
tissue_dict = {}
cids = cline.get_cids()
tissues = cline.get_column_meta('cell_lineage')
for i in range(cline.matrix.shape[1]):
	tissue = tissues[i]
	try:
		tissue_dict[tissue]['count'] += 1
	except KeyError:
		tissue_dict[tissue] = {'count':1,'pos':0,'neg':0,'pos_fraction':0}
	if cline.matrix[gene_ind,i] >= 6:
		tissue_dict[tissue]['pos'] += 1
	else:
		tissue_dict[tissue]['neg'] += 1
	tissue_dict[tissue]['pos_fraction'] = tissue_dict[tissue]['pos']/float(tissue_dict[tissue]['count'])

with open('/xchip/cogs/cflynn/tmp/MUC1_cline_tissue_expression','w') as f:
	f.write('\t'.join(['tissue','# MUC1 possitive','# MUC1 negative','# MUC1 possitive fraction']) + '\n')
	for key in tissue_dict.keys():
		d = tissue_dict[key]
		f.write('{0}\t{1}\t{2}\t{3}\n'.format(key,d['pos'],d['neg'],d['pos_fraction']))
