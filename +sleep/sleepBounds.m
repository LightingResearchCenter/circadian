function [sleepStart,sleepEnd,sleepStartStr,sleepEndStr] = sleepBounds(time,immobility,bedTime,getupTime,epoch)
%SLEEPBOUNDS Summary of this function goes here
%   Detailed explanation goes here

% Determine the number of epochs that makes a 10 minute window
n = ceil(600/epoch);

% Summarize mobility for a 10 minute moving window
mobility = ~immobility;
firstMobile10 = mobility;
for i1 = -n+1:-1
    firstMobile10 = firstMobile10 + circshift(mobility,i1);
end
firstImmobile10 = firstMobile10 <= 1;
lastImmobile10 = circshift(firstImmobile10,n-1);

% Trim to time in bed
[time2,firstImmobile10] = trimData(time,firstImmobile10,bedTime,getupTime);
[time3,lastImmobile10] = trimData(time,lastImmobile10,bedTime,getupTime);

% Find Sleep Start
idxStart = find(firstImmobile10,true,'first');
sleepStart = time2(idxStart);

% Find Sleep End
idxEnd = find(lastImmobile10,true,'last');
sleepEnd = time3(idxEnd);

% Check if sleep bounds were detected
if isempty(sleepStart) || isempty(sleepEnd)
    error('Sleep bounds not found.');
end

% Create string versions in local format
formatOut = 'mm/dd/yyyy HH:MM:SS';
sleepStartStr = datestr(sleepStart,formatOut,'local');
sleepEndStr = datestr(sleepEnd,formatOut,'local');


end

