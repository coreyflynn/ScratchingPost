function result_struct = brute_force_cell_mat_analysis(cell_mat,choose_num,passes)
%find the optimal combination of cells for some number of passes through the input cell_mat.  After
%each pass, remove the best cell lines and run again

%number of cell lines
num_lines = size(cell_mat,2);
lines = 1:num_lines;
used_lines = [];

for ii = 1:passes
    pass_name = sprintf('pass%i',ii);
    unused_lines = lines;
    unused_lines(used_lines) = [];
    [result_struct.(pass_name),used_lines] = get_scores(cell_mat,choose_num,unused_lines,used_lines);
end


function [pass_struct,used_lines] = get_scores(cell_mat,choose_num,unused_lines,used_lines)

%build choose list
disp('building choice list...');
choose_list = nchoosek(unused_lines,choose_num);
%choose_list = randperm(35);
%choose_list = choose_list(1:choose_num);

%for each choice in the choose list, find the sum of the compounds found by that list and store the
%result
scores = zeros(1,size(choose_list,1));
cells = zeros(size(choose_list,1),size(choose_list,2));
disp('building results...');
for ii = 1:size(choose_list,1)
    tmp_list = choose_list(ii,:);
    cells(ii,:) = tmp_list;
    tmp_mat = cell_mat(:,tmp_list);
    scores(ii) = sum(sum(tmp_mat,2)>=1);
end
[sorted_scores,sorted_scores_ind] = sort(scores,'descend');
scores = sorted_scores;
cells = cells(sorted_scores_ind,:);
pass_struct.scores = scores;
pass_struct.cells = cells;
pass_struct.best_score = scores(1);
pass_struct.best_cells = cells(1,:);
tmp_mat = cell_mat(:,cells(1,:));
pass_struct.best_cells_pert_inds = find(sum(tmp_mat,2)>=1);
used_lines = horzcat(used_lines,pass_struct.best_cells);