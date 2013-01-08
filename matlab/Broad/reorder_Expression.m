function reordered_Expression = reorder_Expression(inputExpression,T)
[sortedT,sortedTorder] = sort(T);
reordered_Expression = inputExpression*0;
for ii = 1:length(T)
    reordered_Expression(ii) = inputExpression(sortedTorder(ii));
end
