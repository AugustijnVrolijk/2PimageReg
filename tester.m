%{
str1 = "hello1";
%str2 = "hello2";
%str3 = "hello3";
%str4 = "hello4";


n = 1;

test1 = cell(n, 1);
test2(n, 1) = "";

for i=1:n
    varName = sprintf('str%d', i); % Create variable name as a string
    test1{i} = eval(varName);
    test2(i) = eval(varName);
end

disp(test1)
disp(test2)

disp(test2(1))
disp(test1{1})

disp("")
%}

emptyCellArr = cell(0,1);
disp(length(emptyCellArr));
disp(isempty(emptyCellArr));