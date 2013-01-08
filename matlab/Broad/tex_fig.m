function tex_fig(varargin)
% TEX_FIG prints the tex lines required for a single panel figure
%
% USAGE:
% tex_line(fid,figure_name,figure_caption) prints the lines required for tex figure generation using
% the fid, figure_name, and figure_caption specified.
%
% tex_line(fid,figure_name,figure_caption, figure_size) same as the above call with onlt using figure_size to
% determine the width of the output figure
%
%
% INPUT VARIABLES:
% fid: the file id to be written to
% figure_name: the name of the tex figure to be generated
% figure_caption: the caption of the tex figure to be generated
%
% OPTIONAL INPUT VARIABLES:
% figure_size: the width of the tex figure to be generated
%
% Author: Corey Flynn, Broad Institute 2011

%parse arguments
if nargin == 3
    fid = varargin{1};
    figure_name = varargin{2};
    figure_caption = varargin{3};
    figure_size = '1.0';
elseif  nargin == 4
    fid = varargin{1};
    figure_name = varargin{2};
    figure_caption = varargin{3};
    figure_size = varargin{4};    
end

fprintf(fid,'%s\n','\begin{figure}[!htb]');
fprintf(fid,'%s\n','\begin{centering}');
fprintf(fid,'%s\n',horzcat('\includegraphics[width=',figure_size,'\textwidth]{',figure_name,'}'));
fprintf(fid,'%s\n',horzcat('\caption{',figure_caption,'}'));
fprintf(fid,'%s\n','\end{centering}');
fprintf(fid,'%s\n','\end{figure}');
