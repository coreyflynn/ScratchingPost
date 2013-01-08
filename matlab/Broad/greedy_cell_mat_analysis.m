function [found_lines,scores] = greedy_cell_mat_analysis(cell_mat,seed_lines,choose_num)
%find the optimal combination of cells for some number of cell lines in the input cell_mat.

found_lines = zeros(1,choose_num);
scores = zeros(1,choose_num);

%first use the seed lines
for ii = 1:length(seed_lines)
    found_lines(ii) = seed_lines(ii);
    line_sums = sum(cell_mat,1);
    scores(ii) = line_sums(seed_lines(ii));
    cp_inds = find(cell_mat(:,seed_lines(ii))==1);
	cell_mat(cp_inds,:) = 0;
end


%find the best cell line in the given matrix after the seed lines are used
for ii = length(seed_lines)+1:choose_num
	line_sums = sum(cell_mat,1);
	best_line = find(line_sums==max(line_sums),1,'last');
	found_lines(ii) = best_line;
	scores(ii) = line_sums(best_line);
	cp_inds = find(cell_mat(:,best_line)==1);
	cell_mat(cp_inds,:) = 0;
end