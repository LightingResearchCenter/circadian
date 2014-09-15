function sleepEfficiency = efficiency(actualSleepTime,bedTime,getupTime)
%EFFICIENCY Summary of this function goes here
%   Detailed explanation goes here

timeInBed = (getupTime - bedTime)*24*60;
if actualSleepTime > timeInBed
    sleepEfficiency = 1;
else
    sleepEfficiency = actualSleepTime/timeInBed;
end

end

