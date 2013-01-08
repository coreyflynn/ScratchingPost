# run GSEA from a class 

# Volumes/xchip_cogs/cflynn/InferenceEval/RNAi/RNAI6.cls#ESR1_versus_GFP


java -cp /xchip/projects/xtoolsgsea2.jar -Xmx512m xtools.gsea.Gsea -res $1 -cls $2 -gmx $3 -collapse false -mode Max_probe -norm meandiv -nperm 100 -permute gene_set -rnd_type no_balance -scoring_scheme weighted -rpt_label my_analysis -metric Signal2Noise -sort real -order descending -chip gseaftp.broadinstitute.org://pub/gsea/annotations/HG_U133A.chip -include_only_symbols true -make_sets true -median false -num 100 -plot_top_x 20 -rnd_seed timestamp -save_rnd_lists false -set_max 500 -set_min 15 -zip_report false -out $4 -gui false