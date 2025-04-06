config = struct;
config.name = "default_config";

config.metric = struct;
config.optimiser = struct;
config.data = struct;
%"IDName = getIDName(Name, Date)", "Date = getDate(Name)"
config.data.ExtraColumns = {};
config.data.FetchDataCols = {"Image = getImg(Name, Path)", "Mask = getMask(Name, Path)"};

callingFileDir = fileparts(mfilename('fullpath'));
savePath = fullfile(callingFileDir, "default_config.mat");

save(savePath, "config")

clear
clc