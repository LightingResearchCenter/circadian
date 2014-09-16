function [absTime,relTime,epoch,light,activity,masks] = convertcdf(filePath)
%CONVERTCDF Convert an LRC formatted CDF to custom classes
%   Detailed explanation goes here

% Import daysimeter12 package to enable all other daysimeter12 functions
import daysimeter12.*;

% Read the data from file
Data = readcdf(filePath);

% Convert the time to custom time classes
absTime = absolutetime(Data.Variables.time(:),'cdfepoch',false,...
    Data.Variables.timeOffset,'seconds');
relTime = relativetime(absTime);

% Find the most frequent sampling rate.
epochSeconds = mode(diff(relTime.seconds));

% Create a samplingrate object called epoch.
epoch = samplingrate(epochSeconds,'seconds');

% Prepare light data
red = Data.Variables.red(:);
green = Data.Variables.green(:);
blue = Data.Variables.blue(:);

illuminance = Data.Variables.illuminance(:);
cla = Data.Variables.CLA(:);

% Create an instance of chromcoord from RGB data
chromaticity = rgb2chrom(red,green,blue);

% Create an instance of lightmetrics
light = lightmetrics('illuminance',illuminance,'cla',cla,...
    'chromaticity',chromaticity);

% Reassign activity as a vertical array
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
masks = eventmasks('observation',observation,'compliance',compliance,...
    'bed',bed);

end

