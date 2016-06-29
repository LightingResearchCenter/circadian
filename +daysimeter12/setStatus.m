function [ message ] = setStatus( log_infoPath, statusObj )
%SETSTATUS Summary of this function goes here
%   Detailed explanation goes here

% Read the current file contents
logInfoTxt = daysimeter12.readloginfo(log_infoPath);

% Write the status as an integer to a string
s = sprintf('%i',uint32(statusObj));
% Replace the first character with the new status character
logInfoTxt(1) = s(1);

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

