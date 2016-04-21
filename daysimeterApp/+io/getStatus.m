function status = getStatus(daysimeterPath)
%GETSTATUS Summary of this function goes here
%   Detailed explanation goes here

log_infoPath = fullfile(daysimeterPath,'log_info.txt');
logInfoTxt = io.readloginfo(log_infoPath);
status = io.parseStatus(logInfoTxt);

end

