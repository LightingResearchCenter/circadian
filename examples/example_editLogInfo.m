fclose('all');
close all
clear
clc

addpath('C:\Users\jonesg5\Documents\GitHub\circadian');

parameters = struct;
parameters.status = daysimeter12.daysimeterStatus.Standby;
parameters.startDateTime = now;
parameters.loggingInterval = 180;

pathArray = {'log_info1.txt';'log_info2.txt';'log_info3.txt'};

f = @(log_infoPath) daysimeter12.editLogInfo(log_infoPath,parameters);

messages = cellfun(f,pathArray,'UniformOutput',false);