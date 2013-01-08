function combine_plate_replicates(input_dir,basenames,output_dir,control_string)
%USAGE: COMBINE_PLAET_REPLICATES(input_dir,basename,output_dir)
%
%INPUTS:
%input_dir: the directory to look for folders containing basename strings
%basename: a cell array of strings corresponding to the first portion of replicate folder names
%           to combine.
%output_dir: the directory in which to store combined results
%control_string: the pert_desc string used as a control in the plates to be combined.  This is used
%                to generate the tag file for the combined gct file
%
%Description:
%takes a list of folder name stubs and looks for replicates in the given input directory.  All of 
%the L1000 z-score data found in these folders is then combined into one gct file and written to
%output_dir in its own folder named with the corresponding stub.  Additionally, a tag file is 
%created for each output gct in the same folder.

%get input_dir contents
start_dir = pwd;
cd(input_dir)
input_contents = dir(input_dir);
input_names = {input_contents.name};

%first check for the output directory and create it if it does not exist
if ~isdir(output_dir)
    mkdir(output_dir);
end

%for each basename, find all folders, collect replicates, and write a combined gct to file
for ii = 1:length(basenames)
    basename = basenames{ii};
    disp(['finding ' basename]);
    rep_inds = get_rep_inds(input_names,basename);
    combine_list = {};
    for jj = 1:length(rep_inds)
        gct_tmp_file = dir([input_names{rep_inds(jj)} '/zs/' basename '*978.gct']);
        if length(gct_tmp_file) > 0
            gct_tmp_name = gct_tmp_file(1).name;
            combine_list =  horzcat(combine_list,[input_names{rep_inds(jj)} '/zs/' gct_tmp_name]);
        end
    end

    if length(combine_list) > 1
        %if there is not an appropriate sub-directory in output_dir, create it
        if ~isdir([output_dir '/' basename])
            mkdir([output_dir '/' basename]);
        end
        
        %combine the found gct files into one and write it to file
        merged_gct = merge_profile(combine_list);
        mkgct([output_dir '/' basename '/' basename],merged_gct);
        
        %make a tag file for the gct file
        output_gct_path = dir([output_dir '/' basename '/' basename '*978.gct']);
        output_gct_path = [output_dir '/' basename '/' output_gct_path(1).name];
        output_tag_path = [output_dir '/' basename '/' basename '_tag.txt'];
        build_tag_file(output_gct_path, output_tag_path,control_string)
    end
    
end
    

%find all of the folder names in input_dir that match base name


function matched_inds = get_rep_inds(pert_ids,name_to_match)
matched = cellfun(@(x)regexp(x,name_to_match),pert_ids,'UniformOutput',0);
notEmpties = ~cellfun(@isempty,matched);
matched_inds = find(notEmpties==1);