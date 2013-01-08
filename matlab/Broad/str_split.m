function outputCell = str_split(s,delim)
%split the input string by the given delimeter
remain = s;
outputCell = {};
while true
   [str, remain] = strtok(remain, delim);
   outputCell = horzcat(outputCell,str);
   if isempty(str),  break;  end
end