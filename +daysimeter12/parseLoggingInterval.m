function [ loggingInterval ] = parseLoggingInterval( logInfoTxt )
%PARSELOGGINGINTERVAL Summary of this function goes here
%   Detailed explanation goes here

% Find the position of the first 3 line feed characters (char(10))
q = find(logInfoTxt==char(10),3,'first');
% Select the 3 characters after the third line feed
loggingIntervalStr = logInfoTxt(q(3)+1:q(3)+3);
% Convert the logging interval string to a number
loggingInterval = str2double(loggingIntervalStr);

end

