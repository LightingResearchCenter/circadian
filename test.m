clear
close all
clc

delta = 30/(60*60*24);
time1 = (now:delta:now+7)';

timeType = 'datenum';
utc = false;
utcOffset = -4;
offsetUnit = 'hours';

time2 = absolutetime(time1,timeType,utc,utcOffset,offsetUnit);

time3 = time2;

time3.utcOffset = utcoffset(-5,'hours'); % EDT to EST