function run_java_cc(gct_path,output_dir,cc_range)
%function to run stefano monti's consensus clustering algorithm

%run the consensus clustering
fprintf([repmat('*',1,60) '\n']);
call_1 = ['java -cp /xchip/cogs/bin/geneweaver.jar '...
        'edu.mit.wi.genome.geneweaver.clustering.ConsensusClustering '...
        gct_path ' "' cc_range '" ' '200 -o ' output_dir '/cc -s -p -N 20'];

fprintf(['Running Consensus Clustering. with the system call:\n\n' call_1...
        '\n\nThis may take tens of minutes...\n' [repmat('*',1,60) '\n'] '\n']);

system(call_1,'-echo');