function [ Status ] = getCurrentStatus( daysim )
%GETCURRENTSTATUS get the current status of the daysimeter
%   GETCURRENTSTATUS(DAYSIM) will return the status of the Daysimeter passed. if
%   there is an error in the program it will close any file that it has opended
%   before running the error. 

fileNames = 'log_info.txt';
filePaths = fullfile(daysim,fileNames);
logFile = fopen(filePaths,'r');
c = onCleanup(@() fclose('all'));
Status = textscan(logFile,'%q',1);
end

