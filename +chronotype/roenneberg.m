function [SO,SE,SD,MS,W] = roenneberg(t,AI,SPrep,GU)
%ROENNENBERG Calculates sleep parameters using Roenneberg method
%   Combines Actiware sleep algorithim with Roennenberg sleep parameters
%   t = t in matlab DATENUM format
%   AI = activity index
%   SPrep = local time of preparing to sleep
%   GU = local time of getting out of bed

%% Find the sleep state (SS)
SS = sleepState(AI,'auto',3);

%% Trim data to within the analysis plus a buffer
buffer = 5/(60*24); % 5 minute buffer
idx = t >= (SPrep - buffer) & t <= (GU + buffer);
t = t(idx);
if numel(t) == 0
    error('sleep prep and get up time out of range');
end
AI = AI(idx);

%% Determine if the analysis ends on a workday
dayNumber = weekday(t(end));
if dayNumber == 1 || dayNumber == 7
    W = false;
else
    W = true;
end

%% Convert time to seconds from start of first day
tSec = (t - floor(t(1)))*86400;

%% Calculate the sampling epoch to the nearest second
tempSec1 = tSec(2:end);
tempSec2 = circshift(tSec,1);
tempSec2(1) = [];
epoch = round(mean(abs(tempSec1-tempSec2)));

%% Find sleep onset (SO) and sleep end (SE)
% Find sleep state in a 10 minute window
n10 = ceil(600/epoch); % Number of points in a 10 minute interval
n5 = floor((n10)/2);
AS = ~SS; % Active state (AS)
AS10 = AS; % Initialize 10 minute active state (AS10)
for i1 = -n5:n5
    AS10 = AS10 + circshift(AS,i1);
end
SS10 = AS10 <= 1; % Create 10 minute sleep state (SS10)
tSec2 = tSec;

% Remove first and last 10 minutes
last = numel(tSec2);
tSec2((last-n5):last) = [];
SS10((last-n5):last) = [];
tSec2(1:n5) = [];
SS10(1:n5) = [];

% Find sleep onset (SO)
idxO = find(SS10,true,'first');
SO = tSec2(idxO);

% Find sleep end (SE)
idxE = find(SS10,true,'last');
SE = tSec2(idxE);

%% Calculate sleep duration (SD) in seconds
SD = abs(SE - SO);

%% Calculate basic mid-sleep (MS) in seconds
MS = mod(SO + SD/2,86400);
% if mid-sleep occurs between midnight and noon add 24 hours
if MS < 43200
    MS = MS + 86400;
end

end