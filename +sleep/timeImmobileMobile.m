function [immobileTime,immobilePercent,mobileTime,mobilePercent] = timeImmobileMobile(time,immobility,sleepStart,sleepEnd,epoch,assumedSleepTime)
%ACTUALIMMOBILE Summary of this function goes here
%   Detailed explanation goes here

% Find when in bed and assumed asleep
bed = (time >= sleepStart) & (time <= sleepEnd);

% Calculate Immobile Time in minutes
immobileTime = sum(immobility(bed))*epoch/60;
if immobileTime > assumedSleepTime
    immobileTime = assumedSleepTime;
end


% Calculate Mobile Time in minutes
mobileTime = assumedSleepTime - immobileTime;

% Calculate Immobile Time Percentage
immobilePercent = immobileTime/assumedSleepTime;
% Calculate Mobile Time Percentage
mobilePercent = mobileTime/assumedSleepTime;

end

