function MSFsc = chronotype(tDay,AI,SPrep,GU)
% CHRONOTYPE Calculates the sleep debt corrected free day mid-sleep time
%   t = t in matlab DATENUM format
%   AI = activity index
%   SPrep = local time of preparing to sleep
%   GU = local time of getting out of bed
%   MSFsc = mid-sleep on free days corrected for accumulated sleep dept

%% Eliminate SPrep and GU that are outside of the analysis range
idxElim = SPrep < tDay(1) | SPrep > tDay(end) | ...
             GU < tDay(1) | GU > tDay(end);
SPrep(idxElim) = [];
GU(idxElim) = [];

%% Initialize variables
TD = length(SPrep); % total number of days to be analyzed
SO = zeros(TD,1); % sleep onset in seconds
SE = zeros(TD,1); % sleep end in seconds
SD = zeros(TD,1); % sleep duration in seconds
MS = zeros(TD,1); % basic mid-sleep in seconds
idxW = false(TD,1); % workday logical

%% Calculate basic Roennenberg variables for each day
for i1 = 1:TD
    [SO(i1),SE(i1),SD(i1),MS(i1),idxW(i1)] = ...
        roenneberg(tDay,AI,SPrep(i1),GU(i1));
end

%% Calculate workday variables
WD = sum(idxW); % number of workdays
SDw = mean(SD(idxW)); % sleep duration on workdays in seconds

%% Calculate free day variables
FD = sum(~idxW); % number of free days
SDf = mean(SD(~idxW)); % sleep duration on free days in seconds
SDweek = (SDw*WD + SDf*FD)/TD; % average sleep duration for the week in seconds
MSF = mean(MS(~idxW)); % mid-sleep on free days in seconds
MSFsc = MSF - (SDf - SDweek)/2; % corrected mid-sleep on free days in seconds

%% Convert MSFsc to days
MSFsc = mod(MSFsc/86400,1); % corrected mid-sleep on free days in days

end