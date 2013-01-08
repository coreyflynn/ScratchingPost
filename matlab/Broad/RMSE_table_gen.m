function RMSE_table = RMSE_table_gen

raw_data_path = '/xchip/cogs/bged/BSE/BSE005_CCLE/BSE005_CCLE_GEX_n807x22268.gct';

%generate the GEX version of all models
%{
for ii = 1:10
    model_path = sprintf('/xchip/cogs/data/models/subset_models/mlr10k_%02i_epsilon_978.mat',ii);
    cd(sprintf('/xchip/cogs/cflynn/InferenceEval/models/modelTest/model_%02i/CCLE/data',ii));
    infer_tool('res',raw_data_path,'model',model_path,'out',pwd);
end
%}
%compute the RMSE for each probe in each model and build a 22268x10 table holding the results
RMSE_table = zeros(22268,10);
obs = parse_gct(raw_data_path);
for ii = 1:10
        cd(sprintf('/xchip/cogs/cflynn/InferenceEval/models/modelTest/model_%02i/CCLE/data',ii));
        inf = parse_gct('BSE005_CCLE_GEX_INF_n807x22268.gct');
        [inf,obs] = reorder_probes(inf,obs);
        for jj = 1:22268
            RMSE_table(jj,ii) = rmse(inf.mat(jj,:),obs.mat(jj,:));
        end
end

%write the RMSE_table to file
f  = fopen('RMSE_table.txt','w');
fprintf(f,'Probeset\tModel01\tModel02\tModel03\tModel04\tModel05\tModel06\tModel07\tModel08\tModel09\tModel10\n');

for ii = 1:22268
    fprintf(f,'%s',obs.rid{ii});
    for jj = 1:10
        fprintf(f,'\t%f',RMSE_table(ii,jj));
    end
    fprintf(f,'\n');
end

%plot the results
scatter(mean(RMSE_table,2),std(RMSE_table,0,2),'.');
xlabel('Mean RMSE');
ylabel('RMSE Standard Deviation');
fclose(f);
