function plots(obj,PlotDir)
%PLOTS Summary of this function goes here
%   Detailed explanation goes here

for ii = 1:numel(obj)
    ThisObj = obj(ii);
    [millerTime,millerAI,millerCS] = millerize(ThisObj);
    
end

end


function [millerTime,millerAI,millerCS] = millerize(obj)
%MILLERIZE Summary of this function goes here
%   Detailed explanation goes here

idx = obj.Observation & obj.Complinace;

t  = obj.Time(idx);
ai = obj.ActivityIndex(idx);
cs = obj.CircadianStimulus(idx);

t10 = floor(minute(t)/10)*10; % precise to 10 minutes

millerTimeArray_minutes = unique(t10);

nPoints = numel(millerTimeArray_minutes);

millerAI = zeros(nPoints,1);
millerCS = zeros(nPoints,1);

for i1 = 1:nPoints
    idx = t10 == millerTimeArray_minutes(i1);
    millerAI(i1) = mean(ai(idx));
    millerCS(i1) = mean(cs(idx));
end

millerTime = datetime([repmat(ymd(t(1)),1,nPoints),hms(duration(0,millerTimeArray_minutes,0))],'TimeZone',t.TimeZone);

end
