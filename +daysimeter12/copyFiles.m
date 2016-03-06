function copyFiles(daysimeter,saveLoc,nameStub)
%COPYFILES Summary of this function goes here
%   Detailed explanation goes here

log_infoPath = fullfile(daysimeter,'log_info.txt');
data_logPath = fullfile(daysimeter,'data_log.txt');

newLog_infoPath = fullfile(saveLoc,[nameStub,'-LOG.txt']);
newData_logPath = fullfile(saveLoc,[nameStub,'-DATA.txt']);

end

