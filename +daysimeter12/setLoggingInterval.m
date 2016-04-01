function [ message ] = setLoggingInterval( log_infoPath, loggingInterval )
%SETLOGGINGINTERVAL Summary of this function goes here
%   Detailed explanation goes here

% Read the current file contents
logInfoTxt = daysimeter12.readloginfo(log_infoPath);

% Write the logging interval as a 3 digit padded integer
s = sprintf('%03i',loggingInterval);

% Find the position of the first 3 line feed characters (char(10))
q = find(logInfoTxt==char(10),3,'first');
% Replace the existing logging interval
logInfoTxt(q(3)+1:q(3)+3) = s;

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

