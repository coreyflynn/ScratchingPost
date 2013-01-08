function consensus_cluster_report_tool(dir_1, dir_2, varargin)

%parse optional arguments
pnames = {'o','mkwork'};
dflts = {pwd,'true'};
args = parse_args(pnames,dflts,varargin{:});

%get the starting directory
start_dir = pwd;

%get all clu and gif files from the input directories
cd(dir_1);
dir_1_clu = dir('*.clu');
dir_1_gif = dir('*.gif');
cd(start_dir);
cd(dir_2);
dir_2_clu = dir('*.clu');
dir_2_gif = dir('*.gif');

cd(start_dir);

cms = cell(length(dir_1_clu),1);
for ii = 1:length(dir_1_clu)
    file_1 = [dir_1 '/' dir_1_clu(ii).name];
    file_2 = [dir_2 '/' dir_2_clu(ii).name];
    cms{ii} = mkcm(file_1,file_2);
end

%make a work folder if required
if strcmp(args.mkwork, 'true')
    work_folder = mkworkfolder(args.o,'cc_report');
else
    work_folder = args.o
end

%copy all of the .gif files over to the work directrory
for ii = 1:length(dir_1_gif)
    file_1 = [dir_1 '/' dir_1_gif(ii).name];
    file_2 = [dir_2 '/' dir_2_gif(ii).name];
    copyfile(file_1, [work_folder '/dir_1_' num2str(ii) '.gif']);
    copyfile(file_2, [work_folder '/dir_2_' num2str(ii) '.gif']);
end

%create an html report for all clustering comparisions
f = fopen([work_folder '/index.html'], 'w');
fprintf(f,'<h1>Consensus Clustering Report</h1>\n');
for ii =1:length(cms)
    mk_html_cm(f,cms{ii},ii,dir_1,dir_2);
end
fclose('all');

%return to the start directory
cd(start_dir);

function mk_html_cm(f,cm,gif_num,dir_1,dir_2)
cm_size = size(cm,1);
fprintf(f,['<h2>' num2str(cm_size) ' Cluster Confusion Matrix</h2>\n']);
fprintf(f,'<table border="1">\n');
fprintf(f,'<tr bgcolor=#999999>\n');
fprintf(f,'<th></th>\n');
for ii = 1:cm_size
    fprintf(f,['<th>Class ' num2str(ii) '</th>\n']);
end
fprintf(f,'<th>&#37</th>\n');
fprintf(f,'</tr>\n');

for ii = 1:cm_size
    fprintf(f,'<tr>\n');
    fprintf(f,['<th bgcolor=#999999>Class ' num2str(ii) '</th>\n']);
    for jj = 1:cm_size
        fprintf(f,['<td> ' num2str(cm(ii,jj)) '</td>\n']);
    end
    fprintf(f,['<td bgcolor=#999999> ' num2str(cm(ii,ii)/sum(cm(ii,:))) '</td>\n']);
    fprintf(f,'</tr>\n');
end

fprintf(f,'<tr bgcolor=#999999>\n');
fprintf(f,'<th>&#37</th>\n');
correct_sum = 0;
sample_sum = 0;
for ii = 1:cm_size
    correct_sum = correct_sum + cm(ii,ii);
    sample_sum = sample_sum + sum(cm(:,ii));
    fprintf(f,['<td> ' num2str(cm(ii,ii)/sum(cm(:,ii))) '</td>\n']);
end
fprintf(f,['<td bgcolor = FFAAAA> ' num2str(correct_sum/sample_sum) '</td>\n']);
fprintf(f,'</tr>\n');


fprintf(f,'</table>\n');

fprintf(f,['<p>left=' dir_1 ', right=' dir_2 '</p>\n']);
fprintf(f,['<figure>\n']);
fprintf(f,['<img src=dir_1_' num2str(gif_num) '.gif width=200></img>\n']);
fprintf(f,['<img src=dir_2_' num2str(gif_num) '.gif width=200></img>\n']);
fprintf(f,['</figure>\n']);
