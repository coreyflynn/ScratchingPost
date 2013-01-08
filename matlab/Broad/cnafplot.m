function cnafplot(input_file)

f = fopen(input_file,'r');
data = textscan(f,'%s %f %f','Delimiter','\t','HeaderLines',1);
names = data{1}
Y = data{2}
X = data{3}

unique_names = unique(names)
unique_names(1) = []; %get rid of ''

%------single plot testing------
make_density_plot(names,X,Y,unique_names{1},1);
title(unique_names{1});


%------export all plots------
for ii=1:length(unique_names)
    make_density_plot(names,X,Y,unique_names{ii},.5);
    title(unique_names{ii});
    print(gcf,fullfile(pwd,sprintf('%s_density_plot',unique_names{ii})),'-dpng');
end

function make_density_plot(names,X,Y,sample_name,sigma)
inds = get_cell_inds(names,sample_name);
density_plot(X(inds),Y(inds),sigma);

