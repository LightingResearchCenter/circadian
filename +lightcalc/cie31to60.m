function [u,v] = cie31to60(x,y)
%CIE31TO60 Convert CIE 1931 chromaticity (x,y) to CIE 1960 (u,v)
%   Uses MacAdam's method
%   
%   EXAMPLE:
%   [u,v] = lightcalc.cie31to60(x,y)

u = 4*x./(12*y - 2*x + 3);
v = 6*y./(12*y - 2*x + 3);

end

