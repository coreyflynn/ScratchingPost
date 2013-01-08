function replicate_corr_ouput_to_table(out,file_name)

f = fopen(file_name,'w');
for ii = 1:length(out.id)
    fprintf(f,out.id{ii});
    tmp_array = out.corr{ii};
    if length(find(tmp_array > .5)) >= 1
        fprintf(f,'\tTrue');
    else
        fprintf(f,'\tFalse');
    end
    for jj = 1:length(tmp_array)
        fprintf(f,'\t%s',num2str(tmp_array(jj)));
    end
    fprintf(f,'\n');
end
fclose(f);