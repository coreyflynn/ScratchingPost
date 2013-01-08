"""
Created on Jul 20, 2012

@author: Corey Flynn
"""
import cmap.analytics.query as query

#akt pathway gene set from http://www.broadinstitute.org/gsea/msigdb/cards/BIOCARTA_AKT_PATHWAY.html
akt_members = ['HSP90AA1', 'RELA', 'NFKBIA', 'FOXO1',
               'NFKB1', 'BAD', 'FOXO3', 'AKT1',
               'PDPK1', 'YWHAH', 'CASP9', 'PPP2CA',
               'IKBKG', 'PIK3CA', 'IKBKB', 'PIK3R1',
               'GHR']

#instantiate a query object and fill its database with coresig data from a549, vcap, and PC3
q = query.Query()
q.add_to_database_from_gct('/xchip/cogs/stacks/STK022_GP/by_cell/vcap/coresig/KD_VCAP_CORESIG_SCORE_LM_n2508x978.gctx',meta=['pert_desc','id'])
q.add_to_database_from_gct('/xchip/cogs/stacks/STK022_GP/by_cell/pc3/coresig/KD_PC3_CORESIG_SCORE_LM_n1387x978.gctx', meta=['pert_desc','id'])
q.add_to_database_from_gct('/xchip/cogs/stacks/STK022_GP/by_cell/a549/coresig/KD_A549_CORESIG_SCORE_LM_n1952x978.gctx', meta=['pert_desc','id'])

#get a list of targets of all hairpins in the database and grab only those that are akt_members.
#from that list, generate a list of indices of the database entries to run as queries
query_list = []
pert_descs = q.database_meta['pert_desc']
pert_id = q.database_meta['id']
for i, target in enumerate(pert_descs):
    if target in akt_members:
        query_list.append(pert_id[i])

query_inds = []
for query in query_list:
    query_inds.append(q.database_cid.index(query))
    
#run a cmap query for each query ind and save it to a table
print('running %i queries against %i instances' %(len(query_list),q.database.shape[1]))
cid = [q.database_cid[x] for x in query_inds]
q.cmap_query(query=q.database[:,query_inds], cid=cid)
q.results[0].write_table('/xchip/cogs/cflynn/tmp/akt_pathway_KD_coresig_cmap_results.txt')

        

