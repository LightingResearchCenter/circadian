function timeInBed = inBed(bedTime,getupTime)
%INBED Summary of this function goes here
%   Detailed explanation goes here
import sleep.*

timeInBed = (getupTime - bedTime)*24*60;

end

