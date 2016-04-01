function [ deviceSn ] = parseDeviceSn( logInfoTxt )
%PARSEDEVICESN Summary of this function goes here
%   Detailed explanation goes here

% Find the position of the first line feed character (char(10))
q = find(logInfoTxt==char(10),1,'first');
% Select the 4 characters after the line feed
deviceSn = logInfoTxt(q+1:q+4);

end

