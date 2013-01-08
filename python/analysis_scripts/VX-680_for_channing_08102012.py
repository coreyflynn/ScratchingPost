'''
finds the signature strength and replicate correlation scores for VX-680 in all of the cell
lines provided.  SC plots are dumped into the specified output directory 
'''
import glob
import os
import cmap.analytics.sc as sc
import cmap.io.report as report

output_path = '/xchip/cogs/cflynn/tmp/VX-680_figs'
lines = ['MCF7','VCAP','A375','DV90','HCC44','NCIH446','A549','A427','HCC2429','HCC78',
         'LCLC97TM1','H2172']

#find all of the plates we have for the lines in our current data
plate_paths = []
for line in lines:
    line_plate_paths = glob.glob('/xchip/cogs/data/brew/vc/CPC006_' + line + '*')
    plate_paths.extend(line_plate_paths)

#for each plate, create an SC object housing its data and find the signature strength
#and replicate correlation values for VX-680. save the figures to file and create a report
#of all the signature strength and replicate correlation values.
rep = report.RPT('VX-680 Signature Strength and Replicate Correlations')
for path in plate_paths:
    plate_name = os.path.basename(path)
    lm_gctx = glob.glob(os.path.join(path,'by_rna_well',plate_name + '*SCORE_LM*.gctx'))
    SCObj = sc.SC()
    SCObj.add_sc_from_gct(src=lm_gctx[0])
    SCObj.plot(out=os.path.join(output_path,plate_name + 'VX-680.png'), title=plate_name,
                highlight='VX-680', highlight_label='VX-680')
    print('saved ' + os.path.join(output_path,plate_name + 'VX-680.png'))
    
    #get the index of VX-680
    ind = [i for i in range(len(SCObj.pid)) if 'VX-680' in SCObj.pid[i]]
    rep.header(str(plate_name))
    rep.pre('Signature Strength = ' + str(SCObj.s[ind[0]]))
    rep.pre('Replicate Correlation = ' + str(SCObj.c[ind[0]]))
    
rep.write(os.path.join(output_path,'VX680_scores.pdf'))
    
         
         