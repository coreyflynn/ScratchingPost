function texSpecialCharReplace(filePath,outputPath)
% TEXSPECIALCHARREPLACE replace all occurances of special tex characters with tex friedly versions
%
% TEXSPECIALCHARREPLACE takes a txt file as input and replaces all occurances of strings that will
% cause problems in the tex compiler such as "%".  These strings are substituted with their literal 
% versions, i.e. "\%" and the output file is written to the path in outputPath
%
% USAGE:
% texSpecialCharReplace(filePath)
%
% INPUT VARIABLE DEFINITIONS
% filePath: the path to the file to be operated on
% outputPath: the path to write the resulting file to
%
% Author: Corey Flynn, Broad Institute 2011

%open files
fid = fopen(filePath,'r');
fid2 = fopen(outputPath,'w');

%for each line in fid, replace special characters and write that line to fid2
line = fgets(fid)
while ischar(line)
    line = regexprep(line,'%','\%');
    line = regexprep(line,'_','\_')
    fwrite(fid2,line);
    line = fgets(fid);
end

%close files
fclose(fid);
fclose(fid2);