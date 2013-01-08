function tex_includes(fid,varargin)
% TEX_INCLUDES prints the tex lines required for a tex header and includes
%
% USAGE:
% tex_includes(fid) prints the line required to generated a well formatted tex header to the file
% identifier fid
%
% tex_includes(fid,'class',classType) same as the previsous call with the tex class specified as 
% classType
%
% INPUT VARIABLES:
% fid: the file id to be written to
%
% OPTIONAL PARAMETERS:
% 'class': specifies the class type to be used by tex.
%
% author: Corey Flynn, Broad Institute 2011

%parse optional arguments
pnames = {'class'};
dflts = {'article'};
args = parse_args(pnames,dflts,varargin{:});

if strcmp(args.class,'article')
    %basic includes
    fprintf(fid,'%s\n','\documentclass[12pt]{article}');
    fprintf(fid,'%s\n','\usepackage{graphicx}');
    fprintf(fid,'%s\n','\usepackage[lofdepth,lotdepth]{subfig}');
    fprintf(fid,'%s\n','\usepackage{hyperref}');
    fprintf(fid,'%s\n','\usepackage{tabularx}');

    %matlab syntax coloring
    fprintf(fid,'%s\n','% begin matlab code syntax coloring stuff');
    fprintf(fid,'%s\n','\usepackage{listings}');
    fprintf(fid,'%s\n','\usepackage{color}');
    fprintf(fid,'%s\n','\usepackage{textcomp}');
    fprintf(fid,'%s\n','\definecolor{listinggray}{gray}{0.9}');
    fprintf(fid,'%s\n','\definecolor{lbcolor}{rgb}{0.9,0.9,0.9}');
    fprintf(fid,'%s\n','\lstset{');
    fprintf(fid,'%s\n','	backgroundcolor=\color{lbcolor},');
    fprintf(fid,'%s\n','	tabsize=4,');
    fprintf(fid,'%s\n','	rulecolor=,');
    fprintf(fid,'%s\n','	language=matlab,');
    fprintf(fid,'%s\n','        basicstyle=\tiny  ,');
    fprintf(fid,'%s\n','        upquote=true,');
    fprintf(fid,'%s\n','        aboveskip={1.5\baselineskip},');
    fprintf(fid,'%s\n','        columns=fixed,');
    fprintf(fid,'%s\n','        showstringspaces=false,');
    fprintf(fid,'%s\n','        extendedchars=true,');
    fprintf(fid,'%s\n','        breaklines=true,');
    fprintf(fid,'%s\n','        prebreak = \raisebox{0ex}[0ex][0ex]{\ensuremath{\hookleftarrow}},');
    fprintf(fid,'%s\n','        frame=single,');
    fprintf(fid,'%s\n','        showtabs=false,');
    fprintf(fid,'%s\n','        showspaces=false,');
    fprintf(fid,'%s\n','        showstringspaces=false,');
    fprintf(fid,'%s\n','        identifierstyle=\ttfamily,');
    fprintf(fid,'%s\n','        keywordstyle=\color[rgb]{0,0,1},');
    fprintf(fid,'%s\n','        commentstyle=\color[rgb]{0.133,0.545,0.133},');
    fprintf(fid,'%s\n','        stringstyle=\color[rgb]{0.627,0.126,0.941},');
    fprintf(fid,'%s\n','}');
    fprintf(fid,'% end matlab code syntax coloring stuff');


    fprintf(fid,'%s\n','\begin{document}');
end

if strcmp(args.class,'beamer')
    fprintf(fid,'%s\n','\documentclass{beamer}');
    fprintf(fid,'%s\n','\usetheme{Warsaw}');
    fprintf(fid,'%s\n','\begin{document}');
end
