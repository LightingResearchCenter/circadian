function calFactors = calculateCalibration(data,startTime,endTime,referenceIlluminance)
%CALCULATECALIBRATION Summary of this function goes here
%   Detailed explanation goes here

% Select data from specified period
idx = data.datetime >= startTime & data.datetime <= endTime;
selection = data(idx,:);

% Calculate calibration factors
rCal = referenceIlluminance/mean(selection.R);
gCal = referenceIlluminance/mean(selection.G);
bCal = referenceIlluminance/mean(selection.B);

% Combine output
calFactors = [rCal, gCal, bCal];

end

