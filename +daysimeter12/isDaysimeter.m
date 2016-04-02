function tf = isDaysimeter(drv)
%ISDAYSIMETER will tell if the drive appears to be a Daysimeter
%   TF = ISDAYSIMETER(DRV) where DRV is a Char array with the name of a drive.
%   It will return a logical true if the drive only has the two files necessary
%   for a daysimeter.
%
%   *AS OF 3/23/2016*
%   This currently has only be tested on windows computers.

fileNames = {'log_info.txt';'data_log.txt'};
filePaths = fullfile(drv,fileNames);

isFile = @(x) exist(x,'file') == 2;
% has2files =@(x) length(dir(x)) == 2; did not work on windows 10
% &cellfun(has2files,{drv})
tf = all(cellfun(isFile,filePaths));

end
