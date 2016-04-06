function [  ] = quickSetup( handels )
%USECURRENTTIME Prepares the GUI with the quickest starting information 
%   This will change all of the data needed for the daysimeter to be
%   started with the current time and a 30 second logging interval.
datetime = datevec(now);
set(handels.logInfoControl.startMonth,'value',datetime(2)+1)
set(handels.logInfoControl.startDay,'value',datetime(3)+1)
set(handels.logInfoControl.startYear,'value',2)
set(handels.logInfoControl.startHour,'value',datetime(4)+1)
set(handels.logInfoControl.startMinute,'value',datetime(5)+1)
set(handels.logInfoControl.startLogInterval,'value',2)
end