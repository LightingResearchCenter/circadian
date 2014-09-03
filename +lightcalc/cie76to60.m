function [u,v] = cie76to60(uPrime,vPrime)
%CIE76TO60 Convert CIE 1976 chromaticity (uPrime,vPrime) to CIE 1960 (u,v)
%   Detailed explanation goes here
%   
%   EXAMPLE:
%   [u,v] = lightcalc.cie76to60(uPrime,vPrime)

u = uPrime;
v = 2*vPrime/3;

end

