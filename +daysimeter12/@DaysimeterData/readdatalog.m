function data_log = readdatalog(data_log_path)
%READDATALOG Summary of this function goes here
%   Detailed explanation goes here

% Open the file for reading
fidData = fopen(data_log_path,'r','b');
% Create an opject that closes the file when the object is destroyed
c = onCleanup(@() fclose(fidData));
% Read the file as unsigned integers
data_log = fread(fidData,'uint16');

end

