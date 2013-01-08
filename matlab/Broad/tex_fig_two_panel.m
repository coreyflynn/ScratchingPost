function tex_fig_two_panel(fid,figure1_name,figure1_caption,figure2_name,figure2_caption,overall_caption)
% TEX_FIG_TWO_PANEL prints the tex lines required for a two panel figure
%
% USAGE:
% ttex_fig_two_panel(fid,figure1_name,figure1_caption,figure2_name,figure2_caption,overall_caption)
%
% INPUT VARIABLES:
% fid: the file id to be written to
% figure1_name: the name of the first tex figure to be generated
% figure1_caption: the caption of first the tex figure to be generated
% figure2_name: the name of the second tex figure to be generated
% figure2_caption: the caption of the second tex figure to be generated
%
% Author: Corey Flynn, Broad Institute 2011
fprintf(fid,'%s\n','\begin{figure}[!htb]');
fprintf(fid,'%s\n','\begin{centering}');
fprintf(fid,'%s\n',horzcat('\subfloat[',figure1_caption,'][',figure1_caption,']{'));
fprintf(fid,'%s\n',horzcat('\includegraphics[width=0.45\textwidth]{',figure1_name,'}}'));
fprintf(fid,'%s\n',horzcat('\subfloat[',figure2_caption,'][',figure2_caption,']{'));
fprintf(fid,'%s\n',horzcat('\includegraphics[width=0.45\textwidth]{',figure2_name,'}}'));
fprintf(fid,'%s\n',horzcat('\caption{',overall_caption,'}'));
fprintf(fid,'%s\n','\end{centering}');
fprintf(fid,'%s\n','\end{figure}');