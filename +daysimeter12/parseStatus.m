function [ status ] = parseStatus( logInfoTxt )
%PARSESTATUS Summary of this function goes here
%   Detailed explanation goes here

% Select the first character
statusNumStr = logInfoTxt(1);
% Convert the status character to a double
statusNum = str2double(statusNumStr);
% Convert the status number to an enumerated daysimeterStatus object
status = daysimeter12.daysimeterStatus(statusNum);

end
