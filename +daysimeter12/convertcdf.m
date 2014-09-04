function [absTime,relTime,epoch,light,activity,masks] = convertcdf(filePath)
%CONVERTCDF Summary of this function goes here
%   Detailed explanation goes here

Data = daysimeter12.readcdf(filePath);

absTime = absolutetime(Data.Variables.time(:),'cdfepoch',false,...
    Data.Variables.timeOffset,'seconds');
relTime = relativetime(Data.Variables.time(:),'cdfepoch',false,...
    Data.Variables.timeOffset,'seconds');

% Find the most frequent sampling rate.
epochSeconds = mode(diff(relTime.seconds));

% Create a samplingrate object called epoch.
epoch = samplingrate(epochSeconds,'seconds');

red = Data.Variables.red(:);
green = Data.Variables.green(:);
blue = Data.Variables.blue(:);

illuminance = Data.Variables.illuminance(:);
cla = Data.Variables.CLA(:);

chromaticity = daysimeter12.rgb2chrom(red,green,blue);

light = lightmetrics('illuminance',illuminance,'cla',cla,...
    'chromaticity',chromaticity);

activity = Data.Variables.activity(:);


% Check what logical masks are available.
if isfield(Data.Variables,'logicalArray')
    observation = logical(Data.Variables.logicalArray(:));
else
    observation = logical([]);
end
if isfield(Data.Variables,'complianceArray')
    compliance = logical(Data.Variables.complianceArray(:));
else
    compliance = logical([]);
end
if isfield(Data.Variables,'bedArray')
    bed = logical(Data.Variables.bedArray(:));
else
    bed = logical([]);
end

% Create eventmasks object called masks.
masks = eventmasks('compliance',compliance,'observation',observation,...
    'bed',bed);

end

