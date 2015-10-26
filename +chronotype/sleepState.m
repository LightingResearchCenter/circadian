function [sleep,time,activity] = sleepState(time,activity,epoch,bedTime,getupTime)
%SLEEPSTATE Summary of this function goes here
%   Detailed explanation goes here
import sleep.*

analysisStartTime = bedTime - 20/60/24;
analysisEndTime = getupTime + 20/60/24;

% Perform Sleep Analysis Algorithms
% Find the level of background noise
baselineActivity = findBaseline(activity);

% Trim the data to the analysis period
[time,activity] = trimData(time,activity,analysisStartTime,analysisEndTime);

% Score Immobility
immobility = scoreImmobility(activity,baselineActivity);

% Calculate Time in Bed
param.timeInBed = inBed(bedTime,getupTime);

% Set the threshold for sleep scoring
threshold = autoThreshold(activity,immobility);

% Convert Activity to Total Activity
totalActivity = a2ta(activity,epoch.seconds);

% Score sleep
sleep = scoreSleep(totalActivity,threshold);
end

