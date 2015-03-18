function [millerTime,millerDataArray] = millerize(relTime,dataArray,masks)
%MILLERIZE Summary of this function goes here
%   Detailed explanation goes here

dataArray = dataArray(masks.observation & masks.compliance);

if ~isempty(relTime.startTime)
    startTime_datevec = relTime.startTime.localDateVec;
    startTime_minutes = startTime_datevec(4)*60 + startTime_datevec(5) + startTime_datevec(6)/60;

    relTime_minutes = relTime.minutes(masks.observation & masks.compliance) + startTime_minutes;

    mod_minutes = mod(relTime_minutes,24*60);

    roundedMod_minutes = round(mod_minutes/10)*10; % precise to 10 minutes
else
    roundedMod_minutes = relTime.minutes(masks.observation & masks.compliance);
end

millerTimeArray_minutes = unique(roundedMod_minutes);

nPoints = numel(millerTimeArray_minutes);

millerDataArray = zeros(nPoints,1);

for i1 = 1:nPoints
    idx = roundedMod_minutes == millerTimeArray_minutes(i1);
    millerDataArray(i1) = mean(dataArray(idx));
end

millerTime = relativetime(millerTimeArray_minutes,'minutes');

end

