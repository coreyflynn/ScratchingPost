% function tmpscript
% 	%reads in all of the LFC data and collapses it to a new file
	
% 	% read the file
% 	clogp = parse_gctx('/xchip/cogs/projects/clogp/clogp_cp_tbl_n329044x978.gctx');

% 	% find all unique brew sig ids
% 	sig_pieces = cellfun(@(x) regexp(x,'_','split'),clogp.cid,'Un',0);
% 	brew_ids  = cellfun(@(x) sprintf('%s_%s_%s%s',x{1},x{2},x{3},regexprep(x{6},'.*:','')),sig_pieces,'Un',0);
% 	unique_brew_ids = unique(brew_ids);

% 	% for each unique brew id, find the component brew ids and combine them into a
% 	% single signature
	% unique_sigs = zeros(978,length(unique_brew_ids));
	% num_brew_ids = length(brew_ids);
	% [brew_ids_sort,brew_ids_sort_ind] = sort(brew_ids);
	% brew_id = brew_ids_sort{1};
	% brew_inds = [];
	% lfc_cid = cell(99032,1);
	% unique_sigs_ind = 1;
	% for ii = 1:num_brew_ids
	% 	if strcmp(brew_id,brew_ids_sort{ii}) ==1
	% 		brew_inds(end+1) = brew_ids_sort_ind(ii);
	% 	else
	% 		unique_sigs(:,unique_sigs_ind) = mean(clogp.mat(:,brew_inds),2);
	% 		brew_inds = [];
	% 		unique_sigs_ind = unique_sigs_ind +1;
	% 		brew_id = brew_ids_sort{ii};
	% 		lfc_cid{unique_sigs_ind} = brew_id;
	% 		disp(brew_id);
	% 	end
	% end

	% create the appropriate output structure and write to file
	lfc = clogp;
	lfc.mat = single(unique_sigs);
	lfc.cid = lfc_cid;
	lfc.chd = {};
	lfc.cdesc = {};
	lfc.cdict = '';

	mkgctx('/xchip/cogs/projects/clogp/clogp_cp_tbl_collapsed',lfc);

