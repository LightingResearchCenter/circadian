function [absTime,relTime,light,activity,masks] = importD12(filePath)
%IMPORTD12 Summary of this function goes here
%   Detailed explanation goes here

Data = readD12cdf(filePath);

absTime = absolutetime(Data.Variables.time(:),'cdfepoch',false,...
    Data.Variables.timeOffset,'seconds');
relTime = relativetime(Data.Variables.time(:),'cdfepoch',false,...
    Data.Variables.timeOffset,'seconds');

light = []; % placeholder

activity = Data.Variables.activity(:);

masks = []; % placeholder
end

