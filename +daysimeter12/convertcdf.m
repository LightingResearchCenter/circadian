function [absTime,relTime,light,activity,masks] = convertcdf(filePath)
%CONVERTCDF Summary of this function goes here
%   Detailed explanation goes here

Data = daysimeter12.readcdf(filePath);

absTime = absolutetime(Data.Variables.time(:),'cdfepoch',false,...
    Data.Variables.timeOffset,'seconds');
relTime = relativetime(Data.Variables.time(:),'cdfepoch',false,...
    Data.Variables.timeOffset,'seconds');

light = []; % placeholder

activity = Data.Variables.activity(:);

masks = []; % placeholder
end

