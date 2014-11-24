function [absTime,relTime,epoch,light,activity,masks,subjectID,deviceSN] = convertcdf(cdfData)
%CONVERTCDF Convert an LRC formatted CDF to custom classes
%   Detailed explanation goes here

% Import daysimeter12 package to enable all other daysimeter12 functions
import daysimeter12.*;

% Extract subject ID and device serial number (SN)
subjectID = cdfData.GlobalAttributes.subjectID;
deviceSN  = cdfData.GlobalAttributes.deviceSN;

% Convert the time to custom time classes
absTime = absolutetime(cdfData.Variables.time(:),'cdfepoch',false,...
    cdfData.Variables.timeOffset,'seconds');
relTime = relativetime(absTime);

% Find the most frequent sampling rate.
epochSeconds = mode(diff(relTime.seconds));

% Create a samplingrate object called epoch.
epoch = samplingrate(epochSeconds,'seconds');

% Prepare light data
red = cdfData.Variables.red(:);
green = cdfData.Variables.green(:);
blue = cdfData.Variables.blue(:);

illuminance = cdfData.Variables.illuminance(:);
cla = cdfData.Variables.CLA(:);

% Create an instance of chromcoord from RGB data
chromaticity = rgb2chrom(red,green,blue);

% Create an instance of lightmetrics
light = lightmetrics('illuminance',illuminance,'cla',cla,...
    'chromaticity',chromaticity);

% Reassign activity as a vertical array
activity = cdfData.Variables.activity(:);


% Check what logical masks are available.
if isfield(cdfData.Variables,'logicalArray')
    observation = logical(cdfData.Variables.logicalArray(:));
else
    observation = logical([]);
end
if isfield(cdfData.Variables,'complianceArray')
    compliance = logical(cdfData.Variables.complianceArray(:));
else
    compliance = logical([]);
end
if isfield(cdfData.Variables,'bedArray')
    bed = logical(cdfData.Variables.bedArray(:));
else
    bed = logical([]);
end

% Create eventmasks object called masks.
masks = eventmasks('observation',observation,'compliance',compliance,...
    'bed',bed);

end

