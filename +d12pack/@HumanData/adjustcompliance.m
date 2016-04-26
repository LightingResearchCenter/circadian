function PhasorCompliance = adjustcompliance(Epoch,Time,Compliance,varargin)
%ADJUSTCROP Summary of this function goes here
%   Detailed explanation goes here

if nargin > 3
    InBed = varargin{1};
    noncomplianceArray = ~Compliance & ~InBed; % noncompliance out of bed
else
    noncomplianceArray = ~Compliance;
end

% Calculate the sampling epoch
epoch_days = days(Epoch);

% Find blocks marked to be removed
D = diff(double(noncomplianceArray));

cropStartArray = find(D == -1);
cropStartArray = cropStartArray + 1;
cropStopArray  = find(D ==  1);

if numel(cropStartArray)<1 || numel(cropStopArray)<1
    return;
end

newLogicalArray = true(size(noncomplianceArray));
tempLogicalArray = newLogicalArray;

% Ignore cropping at ends of data
if ~noncomplianceArray(1)
    newLogicalArray(1:cropStopArray(1)) = false;
    cropStopArray(1) = [];
end

if ~noncomplianceArray(end)
    newLogicalArray(cropStartArray(end):end) = false;
    cropStartArray(end) = [];
end

nStarts = numel(cropStartArray);
nStops  = numel(cropStopArray);

if nStarts ~= nStops
    error('Missmatched number of crop starts and stops');
end

if nStarts < 1
    return;
end

for i1 = 1:nStarts
    startTime = Time(cropStartArray(i1));
    stopTime  = Time(cropStopArray(i1));
    delta_duration = stopTime - startTime;
    delta_hours  = hours(delta_duration); % duration in hours
    
    % ignore blocks less than 2 hours
    if delta_hours < 2
        continue;
    end
    
    % expand the block to a multiple of 24 hours
    modDuration = mod(delta_duration,1);
    paddingTimeDays = (1-modDuration);
    newStartTime = startTime - paddingTimeDays;
    newStopTime  = stopTime;
    newCropBlock = ~(Time >= newStartTime & Time <= newStopTime);
    
    % check that the new crop block does not overlapp anything else
    % try all possible combinations if it does
    ii = 0;
    while any(~tempLogicalArray & ~newCropBlock) && (newStartTime <= startTime) && (newStopTime >= stopTime)
        newStartTime = startTime - paddingTimeDays + ii*epoch_days;
        newStopTime  = stopTime  + ii*epoch_days;
        newCropBlock = ~(Time >= newStartTime & Time <= newStopTime);
        ii = ii + 1;
    end
    
    % combine new crop block with existing logical array
    tempLogicalArray = tempLogicalArray & newCropBlock;
    
end

noncomplianceArray = newLogicalArray & tempLogicalArray;

PhasorCompliance = ~noncomplianceArray;

end

