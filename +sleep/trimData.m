function [timeOut,dataOut] = trimData(timeIn,dataIn,startTime,stopTime)
%TRIMDATA shorten data to just the specified time
%   timeIn and dataIn must be column vectors of equal length
%   startTime and stopTime must fall within the bounds of timeIn
import sleep.*

idx = (timeIn >= startTime) & (timeIn <= stopTime);
timeOut = timeIn(idx);
dataOut = dataIn(idx);

end

