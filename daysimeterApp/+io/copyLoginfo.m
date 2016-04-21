function [status,message,messageId] = copyLoginfo(daysimeterPath,savePath,nameStub)
%COPYFILES Summary of this function goes here
%   Detailed explanation goes here

log_infoPath = fullfile(daysimeterPath,'log_info.txt');
newLog_infoPath = fullfile(savePath,[nameStub,'-LOG.txt']);

[status,message,messageId] = copyfile(log_infoPath,newLog_infoPath);

end

