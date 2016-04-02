function [  ] = quickSetup( handels )
%USECURRENTTIME Summary of this function goes here
%   Detailed explanation goes here

datetime = datevec(now);
set(handels.logInfoControl.startMonth,'value',datetime(2)+1)
set(handels.logInfoControl.startDay,'value',datetime(3)+1)
set(handels.logInfoControl.startYear,'value',2)
set(handels.logInfoControl.startHour,'value',datetime(4)+1)
set(handels.logInfoControl.startMinute,'value',datetime(5)+1)
set(handels.logInfoControl.startLogInterval,'value',2)
end