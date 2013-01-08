function colored_label_table(colLabelsCell,itemsCell,labelsCell)
% displays the items listed in itemsCell and associates them with the colored tags listed in 
% labelsCell

% Create a cell array with HTML code
htmlCell = cellfun(@colText,labelsCell);
    
celldata = vertcat(itemsCell,labelsCell);

% Create a uitable with one row and 4 columns and colored cells
uitable(f, 'Data', celldata, ...
'ColumnName', colnames, ...
'Units', 'normalized', ...
'Position', [0 0 1 1]);


function outHtml = colText(inColor)
% return a HTML string with colored font
switch inColor
    case 1
        outHtml = ['<html><font bgcolor="red">', ...
        inColor, ...
        '</font></html>'];
    case 2
        outHtml = ['<html><font bgcolor="green">', ...
        inColor, ...
        '</font></html>'];
    case 3
        outHtml = ['<html><font bgcolor="blue">', ...
        inColor, ...
        '</font></html>'];
end