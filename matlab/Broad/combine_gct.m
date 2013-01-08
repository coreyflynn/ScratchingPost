function combine_gct(gcts,out)
% Usage: COMBINE_GCT(gcts,out)
% Inputs:
%   gcts: A .grp or cell array of .gct files to be combined
%       All .gct's must have the same rid's and must be version #1.3
%   out: the path to the output .gct file
%       The output path must be given after the names of the .gct files 
% Description:
%   takes any number of .gct files with identical row id's and concatenates them together
%   keeps the column annotations and row annotations shared by all .gct's; others are dropped
%   orders the row id's as in the first .gct file in the list

gcts = parse_grp(gcts); % get the .gct's to combine
G = length(gcts); % the number of .gct's

% load the first .gct
ds = parse_gct(gcts{1}); % the data set that we'll append to
ds = rmfield(ds,'src'); % get rid of the source field, since we get .gct files from multiple places
if ~strcmp(ds.version,'#1.3')
    error('%s is not a version #1.3 .gct', gcts{1})
end

% add on the rest of the .gct's, one at a time
for g = 2:G
    tmp = parse_gct(gcts{g});
    if ~strcmp(tmp.version, '#1.3')
        error('%s is not a version #1.3 .gct', gcts{g}) % make sure the .gct is the right version
    end
    if length(tmp.rid) ~= length(ds.rid)
        error('.gct %s has a different number of rows than the preceding files', gcts{g}) % make sure there are the same number of rows
    end
    [rid,tmpridx, ~] = intersect_ord(tmp.rid,ds.rid); % may need to reorder the genes in the file we're appending
    if length(rid) ~= length(ds.rid)
        error('.gct %s has some row id''s that do not match', gcts{g}) % make sure the row id's match, up to ordering
    end
    tmpmat = tmp.mat(tmpridx,:); % reorder the genes in the file we're appending
    ds.mat = [ds.mat, tmpmat]; % append the genes
    ds.cid = [ds.cid; tmp.cid]; % append the column id's
    
    % get the shared row annotations, ordering as in the first .gct
    [rhd,tmpidx,dsidx] = intersect_ord(tmp.rhd,ds.rhd);
    ds.rhd = rhd;
    ds.rdict = list2dict(ds.rhd);
    ds.rdesc = [ds.rdesc(:,dsidx); tmp.rdesc(:,tmpidx)];
    
    % same for the shared column annotations, ordering as in the first .gct
    [chd,tmpidx,dsidx] = intersect_ord(tmp.chd,ds.chd);
    ds.chd = chd;
    ds.cdict = list2dict(ds.chd);
    ds.cdesc = [ds.cdesc(:,dsidx); tmp.cdesc(:,tmpidx)];  
end

mkgct(out, ds); % output the combined .gct file