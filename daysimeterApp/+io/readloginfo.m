function logInfoTxt = readloginfo(log_infoPath)
%READLOGINFO Summary of this function goes here
%   Detailed explanation goes here

% Open the file for reading
fidInfo = fopen(log_infoPath,'r','b');
% Create an opject that closes the file when the object is destroyed
c = onCleanup(@() fclose(fidInfo));
% Read the file as char array
logInfoTxt = fread(fidInfo,'*char')';

end

