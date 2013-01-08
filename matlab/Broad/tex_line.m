function tex_line(fid,line,varargin)
% TEX_LINE prints a single line in tex format to the specified output file 
%
% USAGE:
% tex_line(fid,line)
%
% INPUT VARIABLES:
% fid: the file id to be written to
% line: the line to be written to the tex file
%
% Author: Corey Flynn, Broad Institute 2011

if nargin == 2
    fprintf(fid,'%s\n',horzcat(line,'\\'));
elseif nargin == 3
    if varargin{1} == 1
        fprintf(fid,'%s\n',horzcat(line,'\\'));
    else
        fprintf(fid,'%s\n',line);
    end
end
