function [ message ] = setStartDateTime( log_infoPath, startDateTime )
%SETSTARTDATETIME Summary of this function goes here
%   startDateTime must be a datevec, datenum, or datetime

% Read the current file contents
logInfoTxt = daysimeter12.readloginfo(log_infoPath);

% Write the start date time as a string
s = datestr(startDateTime,'mm-dd-yy HH:MM');

% Find the position of the first 2 line feed characters (char(10))
q = find(logInfoTxt==char(10),2,'first');
% Replace the existing start date time
logInfoTxt(q(2)+1:q(2)+14) = s;

% Open the file for writing, and erase existing contents
fidInfo = fopen(log_infoPath,'w');
% Create an opject that closes the file when the object is destroyed
c = onCleanup(@() fclose(fidInfo));
% Check for error messages
message = ferror(fidInfo);
% Continue if there is no erro message
if isempty(message)
    % Write the modified text to the file
    fprintf(fidInfo,logInfoTxt);
    % Check for error messages
    message = ferror(fidInfo);
end

end

