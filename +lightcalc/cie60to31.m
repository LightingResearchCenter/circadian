function [x,y] = cie60to31(u,v)
%CIE60TO31 Convert CIE 1960 chromaticity (u,v) to CIE 1931 (x,y)
%   Detailed explanation goes here
%   
%   EXAMPLE:
%   [x,y] = lightcalc.cie60to31(u,v)

x = 3*u./(2*u - 8*v + 4);
y = 2*v./(2*u - 8*v + 4);

end

