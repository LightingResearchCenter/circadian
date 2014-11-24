function assumedSleepTime = assumedSleep(sleepStart,sleepEnd)
%ASSUMEDSLEEP returns assumed sleep time in minutes
%   Detailed explanation goes here
import sleep.*

assumedSleepTime = (sleepEnd - sleepStart)*24*60;

end

