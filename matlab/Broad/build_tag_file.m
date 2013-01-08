function build_tag_file(input_path, output_path,control_string)

%read in gctx
[pathstr, name, ext] = fileparts(input_path);
if strcmp(ext,'.gct')
    input_gct = parse_gct(input_path);
else
    input_gct = parse_gctx(input_path);
end     

%find the DMSO entries in the file
pert_id_ind = get_rep_inds(input_gct.chd,'pert_id');
pert_ids = input_gct.cdesc(:,pert_id_ind);
pert_desc_ind = get_rep_inds(input_gct.chd,'pert_mut');
pert_descs = input_gct.cdesc(:,pert_desc_ind);
dmso_inds = get_rep_inds(pert_ids,control_string);

%fix the pert_desc names to exclude '/'
for ii = 1:length(pert_descs)
    pert_descs{ii} = regexprep(pert_descs{ii},'/','-');
end

%create a hash map to hold all pert_ids and their associated replicate indices
fprintf('building pert_id hash map...\n');
pert_map = containers.Map();
h = waitbar(0,'building pert id hash map...');
for ii = 1:length(pert_ids)
    waitbar(ii/length(pert_ids),h,sprintf('building pert id hash map (%i of %i)',ii,length(pert_ids)));
    if ~isKey(pert_map,pert_descs{ii})
        matched_inds = get_rep_inds(pert_ids,pert_ids{ii});
        pert_map(pert_descs{ii}) = matched_inds;
    end
end
[pathstr, name, ext] = fileparts(input_path);
save(sprintf('%s_map.mat',fullfile(pathstr,name)),'pert_map');
close(h);

%loop through all of the keys in the hash_map and fill out a cell array with all of the information
%needed in a tag file for bsig_gen
fprintf('building tag table...\n');
tag_table = cell(length(input_gct.cid)+1,pert_map.size(1)+1);
for ii = 1:size(tag_table,1)*size(tag_table,2)
    tag_table{ii} = '';
end
tag_table{1,1} = 'Sample_id';
for ii = 1:length(input_gct.cid)
    tag_table{ii+1,1} = input_gct.cid{ii};
end


keys = pert_map.keys;
dmso_inds = pert_map(control_string);
for ii = 1:pert_map.size(1)
    if ~strcmp(keys{ii},control_string)
        tag_table{1,ii+1} = ['p:' keys{ii}];
        key_inds = pert_map(keys{ii});
        for jj = 1:length(key_inds)
            tag_table{key_inds(jj)+1,ii+1} = keys{ii};
        end
        for jj = 1:length(dmso_inds)
            tag_table{dmso_inds(jj)+1,ii+1} = control_string;
        end
    end
end

%write the tag file to disk
tag_file = fopen(output_path,'w');
for ii = 1:size(tag_table,1)
    for jj = 1:size(tag_table,2)
        fprintf(tag_file,'%s\t',tag_table{ii,jj});
    end
    fprintf(tag_file,'\n');
end

fclose(tag_file);

function matched_inds = get_rep_inds(pert_ids,name_to_match)
matched = cellfun(@(x)regexp(x,name_to_match),pert_ids,'UniformOutput',0);
notEmpties = ~cellfun(@isempty,matched);
matched_inds = find(notEmpties==1);




