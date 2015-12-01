function Actigraphy = prep(absTime,epoch,activity,masks)
%PREP Summary of this function goes here
%   Detailed explanation goes here

% Import the phasor package
import isiv.*

time = absTime.localDateNum;
time(~masks.observation) = [];
activity(~masks.observation) = [];

if ~isempty(masks.compliance)
    masks.compliance(~masks.observation) = [];
end

if ~isempty(masks.bed)
    masks.bed(~masks.observation) = [];
    % For testing pendant2wristActivity
    %activity(masks.bed) = 0;
end

masks.observation(~masks.observation) = [];

if ~isempty(masks.compliance) && ~isempty(masks.bed)
    masks.compliance = adjustcrop(time,masks.compliance,masks.bed);
end

if ~isempty(masks.compliance)
    time(~masks.compliance) = [];
    activity(~masks.compliance) = [];
end

Actigraphy = struct;
[Actigraphy.interdailyStability,Actigraphy.intradailyVariability] = isiv.isiv(activity,epoch);

Actigraphy.nDays = floor(epoch.days*numel(time));

end

