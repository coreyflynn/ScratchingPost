function gctStruct = uiparse_gct
% UIPARSE_GCT opens a file dialog to select a .gct file to read into the local workspace
%
% UIPARSE_GCT is a simple UI wrapper for parse_gct from the broad matlab tool kit (bmtk)
%
% USAGE:
% gctStruct = uiparse_gct
%
% OUTPUT VARIABLE DEFINITIONS
% gctStruct = the structure containing data from the selected .gct file.  This structure is returned
% to the workspace.
%
% Author: Corey Flynn, Broad Institute 2011

%parse inputs and select files if there are no inputs

[gctFile,gctPath] = uigetfile([pwd '/*.gct'],'Select gct file');
inputGCT = [gctPath gctFile];
gctStruct = parse_gct(inputGCT);