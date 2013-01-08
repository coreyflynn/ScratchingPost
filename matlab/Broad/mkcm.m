function cm = mkcm(clu_1, clu_2)

f_1 = fopen(clu_1,'r');
f_2 = fopen(clu_2,'r');
clu_1_dict = build_class_dict(f_1);
clu_2_dict = build_class_dict(f_2);

%find the number of classes and find the right mapping from dataset 1 to 2 for all classes
num_classes = max(cell2mat(values(clu_1_dict)));
class_vectors = zeros(num_classes, num_classes);
for ii = 1:num_classes
class_vectors(ii,:) = get_class_vector(ii,clu_1_dict,clu_2_dict,class_vectors);
end

optimal_classes = get_optimal_classes(class_vectors);

cm = class_vectors(optimal_classes,:);

function class_dict = build_class_dict(f)
%   utility funciton to build a class label dictionary from an input list in the provided
%   .clu file
line = fgetl(f);
class_dict = containers.Map();
while ischar(line)
    colon_pos = regexp(line,':');
    if ~isempty(colon_pos)
        class_id = str2num(line(colon_pos-1));
        line = fgetl(f);   
        continue;
    end
    class_dict(line) = class_id;
    line = fgetl(f);    
end

function class_vector = get_class_vector(clu_1_class,clu_1_dict,clu_2_dict,data_map)
%    Utility function to find the class labeling match for all of the class labels in the
%    first input file.  This is used to fix cases where the class label mapping is not direct. For
%    example if class 1 is labeled as class 2 in the second data set.
class_vector = zeros(1, length(data_map));
clu_1_keys = keys(clu_1_dict);
for ii = 1:length(clu_1_keys)
    if clu_1_dict(clu_1_keys{ii}) == clu_1_class
        class_vector(clu_2_dict(clu_1_keys{ii})) = class_vector(clu_2_dict(clu_1_keys{ii})) + 1;
    end
end
class_vector;

function optimal_classes = get_optimal_classes(class_vectors)
%   Utility function to find the optimal class match from an input set of class_vectors
num_classes = size(class_vectors,1);
is_taken = zeros(1,size(class_vectors,1));
optimal_classes = zeros(1,size(class_vectors,1));
class_support = zeros(1,size(class_vectors,1));
for ii = 1:num_classes
    [sorted, inds] = sort(class_vectors(:,ii),'descend');
    assigned = 0;
    iter = 1;
    while assigned == 0
        class_assignment = inds(iter);
        if is_taken(class_assignment) == 0
            optimal_classes(ii) = class_assignment;
            is_taken(class_assignment) = 1;
            class_support(class_assignment) = sorted(iter);
            assigned = 1;
        else
            if class_support(class_assignment) <= sorted(iter)
                old_assignment = find(optimal_classes == class_assignment);
                optimal_classes(ii) = optimal_classes(old_assignment);
                optimal_classes(old_assignment) = old_assignment;
                is_taken(class_assignment) = 1;
                class_support(ii) = sorted(iter);
                class_support(ii) = class_support(old_assignment);
                assigned = 1;
            end
            iter = iter + 1;
        end
    end
end

%fix redundancies

for ii = 1:num_classes
    class_members = find(optimal_classes == ii);
    if length(class_members) > 1
        available_classes = setdiff(1:num_classes,optimal_classes);
        class_loser = find(class_support(class_members) == min(class_support(class_members)),1);
        optimal_classes(class_members(class_loser)) = available_classes(1);
        available_classes([]);
    end
end

%close files
fclose('all');