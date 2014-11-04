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

Phasor = struct;
[Phasor.vector,Phasor.magnitude,Phasor.angle,...
    Phasor.magnitudeHarmonics,Phasor.firstHarmonic] = ...
    phasor.phasor(time,epoch,cs,activity);

end

