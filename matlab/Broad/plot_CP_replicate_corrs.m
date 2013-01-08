function varargout = plot_CP_replicate_corrs(gct_path,fig_title)
%load a gct file in
try
    gct = parse_gct(gct_path);
catch
    gct = parse_gctx(gct_path);
end

%constrain z-scores to [-10 10]
gct.mat(find(gct.mat > 10)) = 10;
gct.mat(find(gct.mat < -10)) = -10;

%gct.mat(intersect(find(gct.mat > -2),find(gct.mat < 2) )) = 0;

%generate the crosscorrelaton of all samples
cm = fastcorr(gct.mat,'type','Spearman');

%pull out all of the replicate correlations 

disp('grabbing replicate corrs...');

%find the unique labels
labels  = gct.cdesc(:,gct.cdict('pert_id'));
unique_labels = unique(labels);
unique_labels = setdiff(unique_labels,'DMSO');


%construct a dictionary to hold correlations for labels
rep_corrs_dict = containers.Map;

%fill a boolean matrix with the location of the replicates
rep_loc = cm*0;
for ii = 1:length(unique_labels)
    matched_inds = get_rep_inds(labels,unique_labels(ii));
    try %in case there is only one replicate
        match_combos = combntns(matched_inds,2);
        tmp_corrs = zeros(1,size(match_combos,1));
        for jj = 1:size(match_combos,1)
            rep_loc(match_combos(jj,1),match_combos(jj,2)) = 1;
            rep_loc(match_combos(jj,2),match_combos(jj,1)) = 1;
            tmp_corrs(jj) = cm(match_combos(jj,2),match_combos(jj,1));
        end
    rep_corrs_dict(unique_labels{ii}) = tmp_corrs;
    catch
        continue
    end
end
rep_loc = rep_loc + triu(ones(size(cm)),1);
non_rep_corrs = cm(find(rep_loc == 1));
rep_corrs = cm(find(rep_loc == 2));

%plot the distributions of the replicates and non-replicates
[nr_n,nr_x] = hist(non_rep_corrs(:),100);
[r_n,r_x] = hist(rep_corrs(:),100);
%windowSize = 3;
%nr_n = filter(ones(1,windowSize)/windowSize,1,nr_n);
%r_n = filter(ones(1,windowSize)/windowSize,1,nr_n);
nr_n = smooth(nr_n,10);
r_n = smooth(r_n,10);

plot(nr_x,nr_n/sum(nr_n),'b'); hold on;
plot(r_x,r_n/sum(r_n),'r'); hold off;
xlim([-1 1]);
legend({'non-replicates','replicates'});
title(fig_title);

%return the correlations in a pert_id and corr entry structure if an output is called for
if nargout == 1
    out.id = {};
    out.corr = {};
    out.corr_dict = rep_corrs_dict;
    rep_keys = rep_corrs_dict.keys;
    for ii = 1:length(rep_keys)
        out.id = horzcat(out.id,rep_keys{ii});
        out.corr = horzcat(out.corr,rep_corrs_dict(rep_keys{ii}));
    end
    varargout{1} = out;
end


function matched_inds = get_rep_inds(labels,name_to_match)
matched = cellfun(@(x)strmatch(x,name_to_match,'exact'),labels,'UniformOutput',0);
notEmpties = ~cellfun(@isempty,matched);
matched_inds = find(notEmpties==1);