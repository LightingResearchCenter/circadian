function Phasor = prep(absTime,epoch,light,activity,masks)
%PREP Summary of this function goes here
%   Detailed explanation goes here

% Import the phasor package
import phasor.*

time = absTime.localDateNum;
cs = light.cs;

time(~masks.observation) = [];
cs(~masks.observation) = [];
activity(~masks.observation) = [];

if ~isempty(masks.compliance)
    masks.compliance(~masks.observation) = [];
end
masks.observation(~masks.observation) = [];


if ~isempty(masks.bed)
    masks.bed(~masks.observation) = [];
    cs(masks.bed) = 0;
    activity(masks.bed) = 0;
end

if ~isempty(masks.compliance) && ~isempty(masks.bed)
    masks.compliance = adjustcrop(time,masks.compliance,masks.bed);
end

if ~isempty(masks.compliance)
    time(~masks.compliance) = [];
    cs(~masks.compliance) = [];
    activity(~masks.compliance) = [];
end

% Apply gaussian filter to data
filterWindow = ceil(300/epoch.seconds); % approximate number of samples in 5 minutes
cs = gaussian(cs,filterWindow);
activity = gaussian(activity,filterWindow);

Phasor = struct;
[Phasor.vector,Phasor.magnitude,Phasor.angle,...
    Phasor.magnitudeHarmonics,Phasor.firstHarmonic] = ...
    phasor.phasor(time,epoch,cs,activity);

end

function filtered = gaussian(data, window)

%window is number of points on each side of current point that you want to
%consider
window = window*2;
filtered = filtfilt(gausswin(window)/sum(gausswin(window)), 1, data);

end



