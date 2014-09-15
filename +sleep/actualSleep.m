function [actualSleepTime,actualSleepPercent,actualWakeTime,actualWakePercent] = actualSleep(time,sleep,sleepStart,sleepEnd,epoch,assumedSleepTime)
%ACTUALSLEEP Summary of this function goes here
%   Detailed explanation goes here

% Find when in bed and assumed asleep
bed = (time >= sleepStart) & (time <= sleepEnd);

% Calculate Actual Sleep Time in minutes
actualSleepTime = sum(sleep(bed))*epoch/60;
if actualSleepTime > assumedSleepTime
    actualSleepTime = assumedSleepTime;
end


% Calculate Actual Wake Time in minutes
actualWakeTime = assumedSleepTime - actualSleepTime;

% Calculate Actual Sleep Time Percentage
actualSleepPercent = actualSleepTime/assumedSleepTime;
% Calculate Actual Wake Time Percentage
actualWakePercent = actualWakeTime/assumedSleepTime;

end

