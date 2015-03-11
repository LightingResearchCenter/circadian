function [sleepBouts,wakeBouts,meanSleepBoutTime,meanWakeBoutTime] = boutsSleepWake(time,sleep,sleepStart,sleepEnd,actualSleepTime,actualWakeTime)
%BOUTS Summary of this function goes here
%   Detailed explanation goes here
import sleep.*

% Trim data to the assumed sleep period
[~,sleep] = trimData(time,sleep,sleepStart,sleepEnd);

% Find Sleep Bouts and Wake Bouts
D = diff(sleep);
if sleep(1)
    sleepBouts = numel(D(D == 1)) + 1;
    wakeBouts = numel(D(D == -1));
else
    sleepBouts = numel(D(D == 1));
    wakeBouts = numel(D(D == -1)) + 1;
end

% Calculate Mean Sleep Bout Time in minutes
if sleepBouts == 0
    meanSleepBoutTime = 0;
else
    meanSleepBoutTime = actualSleepTime/sleepBouts;
end

% Claculate Mean Wake Bout Time in minutes
if wakeBouts == 0
    meanWakeBoutTime = 0;
else
    meanWakeBoutTime = actualWakeTime/wakeBouts;
end

end

