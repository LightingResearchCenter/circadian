function [ num ] = readdatalog( data_logPath )
%READDATALOG Summary of this function goes here
%   Detailed explanation goes here

% Open the file for reading
fidData = fopen(data_logPath,'r','b');
% Create an opject that closes the file when the object is destroyed
c = onCleanup(@() fclose(fidData));
% Read the file as unsigned integers
num = fread(fidData,'uint16');

end

