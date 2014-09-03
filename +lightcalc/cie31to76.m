function [uPrime,vPrime] = cie31to76(x,y)
%CIE31TO76 Convert CIE 1931 chromaticity (x,y) to CIE 1976 (uPrime,vPrime)
%   Detailed explanation goes here
%   
%   EXAMPLE:
%   [uPrime,vPrime] = lightcalc.cie31to76(x,y)

uPrime = 4*x./(12*y - 2*x + 3);
vPrime = 9*y./(12*y - 2*x + 3);

end

