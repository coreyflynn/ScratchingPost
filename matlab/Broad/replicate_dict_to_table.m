function replicate_dict_to_table(dict,out_path)
%function to write a replicate dicitonary to a tab delimited table
keys = dict.keys;
f = fopen(out_path,'w');
for ii = 1:length(keys)
    line = keys{ii};
    corrs = dict(keys{ii});
    for jj = 1:length(corrs)
        line = sprintf('%s\t%s',line,num2str(corrs(jj)));
    end
    line = sprintf('%s\n',line);
    fprintf(f,line);
end
fclose(f);
    