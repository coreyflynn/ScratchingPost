function bouton_results_compile
%compile bouton results for the selected directory
start_dir = pwd;

user_dir = uigetdir;
cd(user_dir);
file_list = dir([user_dir '/*_results.mat']);

correct_file = fopen('numCorrectDetect.txt','w');
false_file = fopen('numFalseAlarms.txt','w');
ground_file = fopen('numGroundTruth.txt','w');

%find the number of detection levels used in the experiment
load(file_list(1).name);
numCorrectDetect
fprintf(correct_file,'file name');
fprintf(false_file,'file name');
fprintf(ground_file,'file name');
fprintf(ground_file,'\tground truth number\n');
for ii = 1:length(numCorrectDetect{1})
    fprintf(correct_file,'\tlevel %i',ii);
    fprintf(false_file,'\tlevel %i',ii);
end
fprintf(correct_file,'\n');
fprintf(false_file,'\n');

for ii = 1:length(file_list)
    try
        load(file_list(ii).name);
        fprintf(correct_file,file_list(ii).name);
        fprintf(false_file,file_list(ii).name);
        fprintf(ground_file,file_list(ii).name);
        fprintf(ground_file,'\t%i\n',size(groundTruth,2));
        for jj = 1:length(numCorrectDetect{1})
            fprintf(correct_file,'\t%i',numCorrectDetect{1}(jj));
            fprintf(false_file,'\t%i',numFalseAlarms{1}(jj));
        end
        fprintf(correct_file,'\n');
        fprintf(false_file,'\n');
    catch
        fprintf('could not process data for %s\n',file_list(ii).name);
    end
end

fclose(correct_file);
fclose(false_file);
fclose(ground_file);

%collapse all slices into one result for the correct detections and the false positives
corrects_full = dlmread('numCorrectDetect.txt','\t',1,1);
plot(sum(corrects_full));
xlabel('Level');
ylabel('Number of correct detections');
title('Correct Detections');
print(gcf,'correct_raw.pdf','-dpdf');

false_full = dlmread('numFalseAlarms.txt','\t',1,1);
plot(sum(false_full));
xlabel('Level');
ylabel('Number of false detections');
title('False Detections');
print(gcf,'false_raw.pdf','-dpdf');

gound_full = dlmread('numGroundTruth.txt','\t',1,1);
gound_total = sum(gound_full);

plot(sum(corrects_full)/gound_total);
xlabel('Level');
ylabel('Number of correct detections relative to ground truth');
title('Correct Detections');
print(gcf,'correct_ratio.pdf','-dpdf');

plot(sum(false_full)/gound_total);
xlabel('Level');
ylabel('Number of false detections relative to ground truth');
title('False Detections');
print(gcf,'false_ratio.pdf','-dpdf');



cd(start_dir);