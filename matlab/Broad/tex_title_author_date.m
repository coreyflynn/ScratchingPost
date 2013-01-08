function tex_title_author_date(fid,title,author)
% TEX_TITLE_AUTHOR_DATE prints the tex lines required for a tex title page
%
% USAGE:
% textitleauthorDate(fid,title,author)
%
% INPUT VARIABLES:
% fid: the file id to be written to
% title: the title of the document to be written
% author: the author of the document to be written
%
% author: Corey Flynn, Broad Institute 2011
fprintf(fid,'%s\n',horzcat('\title{',title));
fprintf(fid,'%s\n',horzcat('\author{',author,'}'));
fprintf(fid,'%s\n','\date{\today}');
fprintf(fid,'%s\n','\maketitle');