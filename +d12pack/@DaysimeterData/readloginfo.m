function log_info = readloginfo(log_info_path)
%READLOGINFO Summary of this function goes here
%   Detailed explanation goes here

% Open the file for reading
fidInfo = fopen(fullfile(log_info_path),'r','b');
% Create an opject that closes the file when the object is destroyed
c = onCleanup(@() fclose(fidInfo));
% Read the file as char array
log_info = fread(fidInfo,'*char')';

end

