function tf = isDaysimeter(drv)
%ISDAYSIMETER Summary of this function goes here
%   Detailed explanation goes here

fileNames = {'log_info.txt';'data_log.txt'};
filePaths = fullfile(drv,fileNames);

isFile = @(x) exist(x,'file') == 2;

tf = all(cellfun(isFile,filePaths));

end

