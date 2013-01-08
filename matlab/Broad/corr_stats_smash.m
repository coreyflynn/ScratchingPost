function [H,V] = corr_stats_smash(out)

brew_base = '/xchip/cogs/data/brew'
base_names = uiparse_grp;

corr_file_tmp = fullfile(brew_base,base_names{1},'sigstat',[base_names{1} '_SIGSTATS.txt']);
[H,V] = parse_tab_dlm(corr_file_tmp);

for ii = 2:length(base_names)
    corr_file_tmp = fullfile(brew_base,base_names{ii},'sigstat',[base_names{ii} '_SIGSTATS.txt']);
    [H_tmp,V_tmp] = parse_tab_dlm(corr_file_tmp);
    for jj = 1:length(V)
        V{jj} = vertcat(V{jj},V_tmp{jj});
    end
end

f = fopen(out,'w');
for ii =1:length(H)
    fwrite(f,sprintf('%s\t',H{ii}));
end
fprintf(f,'\n');

for ii = 1:length(V{1})
    for jj = 1:length(V)
            fwrite(f,sprintf('%s\t',V{jj}{ii}));
    end
    fprintf(f,'\n');
end
fclose(f);
    