function [totalActivityScore,meanActivityScore,meanScoreActivePeriods] = meanScore(time,activityCounts,sleepStart,sleepEnd)
%MEANSCORE Summary of this function goes here
%   Detailed explanation goes here

% Trim the data to the assumed sleep time
[time,activityCounts] = trimData(time,activityCounts,sleepStart,sleepEnd);

% Calculate the Total Activity Score
totalActivityScore = sum(activityCounts);

% Calculate the Mean Activity Score
if numel(activityCounts) > 0
    meanActivityScore = totalActivityScore/numel(activityCounts);
else
    meanActivityScore = 0;
end

% Calculate the Mean Score in Active Periods
activePeriods = time(activityCounts > 0);
if numel(activePeriods) > 0
    meanScoreActivePeriods = totalActivityScore/numel(activePeriods);
else
    meanScoreActivePeriods = 0;
end

end

