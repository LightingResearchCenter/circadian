function sleepLatency = latency(bedTime,sleepStart,epoch)
%LATENCY Summary of this function goes here
%   Detailed explanation goes here

sleepLatencySec = (sleepStart - bedTime)*24*60*60; % Sleep Latency in seconds

% Round sleep latency to precision of epoch and convert to minutes
sleepLatency = round(sleepLatencySec/epoch)*epoch/60;

end

