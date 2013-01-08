function ss = get_ss(scores,num_probes)
sorted = sort(scores,'descend');
top = mean(sorted(1:num_probes));
bot = mean(sorted(end-num_probes,end));
ss = top-bot;