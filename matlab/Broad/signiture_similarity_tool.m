function scores = signiture_similarity_tool(input_gct,inds)
%compute the similarity of the first profile in inds with the others using the top and bottom lists of genes as the metric

%get the first sample ind up and down lists and use those as the comparison lists for all other samples in inds
[ref_up_list, ref_down_list, ref_up_ind, ref_down_ind] = get_sorted_lists(input_gct,inds(1));
scores = zeros(1,length(inds));

for ii = 1:length(inds)
    up_S = zeros(1,length(input_gct.rid));
    down_S = zeros(1,length(input_gct.rid));
    [sample_up_list, sample_down_list, sample_up_ind, sample_down_ind] = get_sorted_lists(input_gct,inds(ii));
    
    up_S(sample_up_ind) = 1;
    [up_P,up_score] = CMap_enrichment_score(input_gct.mat(:,inds(1)), up_S);
    
    down_S(sample_down_ind) = 1;
    [down_P,down_score] = CMap_enrichment_score(input_gct.mat(:,inds(1)), down_S);
    
    sample_score = (abs(up_score) + abs(down_score))/2;
    
    if abs(up_score) < abs(down_score)
        sample_score = -sample_score;
    end
    scores(ii) = sample_score;
end


%{
for ii = 1:length(inds)
    [sample_up_list, sample_down_list] = get_sorted_lists(input_gct,inds(ii));
    up_score = length(intersect(ref_up_list, sample_up_list));
    down_score = length(intersect(ref_down_list, sample_down_list));
    sample_score = (up_score + down_score)/2;
    
    if up_score < down_score
        sample_score = -sample_score;
    end
    scores(ii) = sample_score;
end
%}

function [up_list, down_list, up_ind, down_ind] = get_sorted_lists(gct,ind)
[s,i] = sort(gct.mat(:,ind));
up_ind = i(end-99:end);
down_ind = i(1:100);
up_list = gct.rid(up_ind);
down_list = gct.rid(down_ind);