function sc_permutations(scores)

%sample permutation

perms = zeros(1,1000);
num_scores = length(scores);
for ii = 1:length(perms)
    inds = randperm(num_scores);
    perms(ii) = get_ss(scores(sort(inds(1:200),'descend')),50);
end
true_ss = get_ss(sort(scores,'descend'),50);
ksdensity(perms);
hold on;line([true_ss true_ss],ylim);
hold off;

disp(mean(perms))
disp(std(perms))