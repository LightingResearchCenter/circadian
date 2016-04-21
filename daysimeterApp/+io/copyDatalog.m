function [status,message,messageId] = copyDatalog(daysimeterPath,savePath,nameStub)
%COPYFILES Summary of this function goes here
%   Detailed explanation goes here

data_logPath = fullfile(daysimeterPath,'data_log.txt');
newData_logPath = fullfile(savePath,[nameStub,'-DATA.txt']);

[status,message,messageId] = copyfile(data_logPath,newData_logPath);

end

