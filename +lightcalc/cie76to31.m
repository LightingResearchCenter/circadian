function [x,y] = cie76to31(uPrime,vPrime)
%CIE76TO31 Convert CIE 1976 chromaticity (uPrime,vPrime) to CIE 1931 (x,y)
%   Detailed explanation goes here
%   
%   EXAMPLE:
%   [x,y] = lightcalc.cie76to31(uPrime,vPrime)

x = 9*uPrime./(6*uPrime - 16*vPrime + 12);
y = 4*vPrime./(6*uPrime - 16*vPrime + 12);

end

