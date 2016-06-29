function [ loggingInterval ] = parseLoggingInterval( logInfoTxt )
%PARSELOGGINGINTERVAL return the daysimeters logging interval
%   logInfoTxt should be the read in string of the daysimeter.

% Find the position of the first 3 line feed characters (char(10))
q = find(logInfoTxt==char(10),3,'first');
% Select the 3 characters after the third line feed
loggingIntervalStr = logInfoTxt(q(3)+1:q(3)+3);
% Convert the logging interval string to a number
loggingInterval = str2double(loggingIntervalStr);

end

