function grp = uiparse_grp
% UIPARSE_GRP opens a file dialog to select a .grp file to read into the local workspace
%
% UIPARSE_GRP is a simple UI wrapper for parse_grp from the broad matlab tool kit (bmtk)
%
% USAGE:
% grpStruct = uiparse_grp
%
% OUTPUT VARIABLE DEFINITIONS
% grpStruct = the structure containing data from the selected .grp file.  This structure is returned
% to the workspace.
%
% Author: Corey Flynn, Broad Institute 2012

%parse inputs and select files if there are no inputs

[grpFile,grpPath] = uigetfile([pwd '/*.grp'],'Select grp file');
inputgrp = [grpPath grpFile];
grp = parse_grp(inputgrp);