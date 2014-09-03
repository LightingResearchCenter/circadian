function [uPrime,vPrime] = cie60to76(u,v)
%CIE60TO76 Convert CIE 1960 chromaticity (u,v) to CIE 1976 (uPrime,vPrime)
%   Detailed explanation goes here
%   
%   EXAMPLE:
%   [uPrime,vPrime] = lightcalc.cie60to76(u,v)

uPrime = u;
vPrime = 3*v/2;

end

