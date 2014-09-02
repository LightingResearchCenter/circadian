function [absTime,relTime,light,activity,masks] = convertcdf(filePath)
%CONVERTCDF Summary of this function goes here
%   Detailed explanation goes here

Data = daysimeter12.readcdf(filePath);

absTime = absolutetime(Data.Variables.time(:),'cdfepoch',false,...
    Data.Variables.timeOffset,'seconds');
relTime = relativetime(Data.Variables.time(:),'cdfepoch',false,...
    Data.Variables.timeOffset,'seconds');

red = Data.Variables.red;
green = Data.Variables.green;
blue = Data.Variables.blue;

illuminance = Data.Variables.illuminance;
cla = Data.Variables.CLA;

chromaticity = daysimeter12.rgb2chrom(red,green,blue);

light = lightmetrics('illuminance',illuminance,'cla',cla,'chromaticity',chromaticity); % placeholder

activity = Data.Variables.activity(:);

masks = []; % placeholder
end

