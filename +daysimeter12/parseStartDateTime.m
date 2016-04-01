function [ startDateTime ] = parseStartDateTime( logInfoTxt )
%PARSESTARTDATETIME Summary of this function goes here
%   Detailed explanation goes here

% Find the position of the first 2 line feed characters (char(10))
q = find(logInfoTxt==char(10),2,'first');
% Select the 14 characters after the second line feed
startDateTimeStr = logInfoTxt(q(2)+1:q(2)+14);
% Convert the date string to a date vector
startDateTime = datevec(startDateTimeStr,'mm-dd-yy HH:MM');

end

