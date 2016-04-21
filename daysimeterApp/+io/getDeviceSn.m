function deviceSn = getDeviceSn(daysimeterPath)
%GETDEVICESN Summary of this function goes here
%   Detailed explanation goes here

log_infoPath = fullfile(daysimeterPath,'log_info.txt');
logInfoTxt = io.readloginfo(log_infoPath);
deviceSn = io.parseDeviceSn(logInfoTxt);

end

