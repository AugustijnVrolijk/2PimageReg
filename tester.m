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


%{
FEATURES FOR IMAGE:

    Selection of which images to show
    option to select img type (i.e. mask or bimg)
    
    SHOW PAIR Toggle, (only show 2, and if a new image is selected then remove the last one from being shown)
        Instead of just a pair, you can select how many you want shown

    Reset colours: To maximise contrast,
        LOOK AT CreateRBG2 from Leander
    Recenter images


    Calculating largest dims and getting the transformed images under this
    should happen once and under recenter images for the selected images

    but maybe reset colours dynamically
%}