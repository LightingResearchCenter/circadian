function cct = chrom2cct(u,v)
%CHROM2CCT Calculate CCT from CIE 1960 chromaticity coordinates (u,v)
%	Calculates the correlated color temperature (CCT) from CIE u, v values.
%	Uses method by Allen Robertson as references in W&S (1982).
%	Needs file 'isoTempLines.mat' for isotemperature lines from W&S (1982) 
%   or similarly calculated.
%   
%	Inputs:
%       u = CIE 1960 u value
%       v = CIE 1960 v value
%   
%   Output:
%       cct = correlated color temperature in degrees Kelvin
%   
%   EXAMPLE:
%       cct = lightclac.chrom2cct(u,v)
%   
%    See also: CIE31TO60, and CIE76TO60

load(['+lightcalc',filesep,'isoTempLines.mat'],'T','ut','vt','tt');

us = u(:);
vs = v(:);

nPoint = numel(u);
cct = NaN(nPoint,1);

for iPoint = 1:nPoint
    % Find adjacent lines to (us,vs)
	d = ((vs(iPoint)-vt) - tt.*(us(iPoint)-ut))./sqrt(1+tt.*tt);
    
    d1 = d(1:end-1); % Distance from point to iso lines 1 to end-1
    d2 = d(2:end);   % Distance from point to iso lines 2 to end
    
    ratioD = d1./d2; % Ratio of distances to iso lines
    
    lessThan0 = ratioD < 0; % Negative ratios (between these lines)
    equalTo0 = d == 0;      % Zero distance (directly on a line)
    
    % Directly on a line
    if any(equalTo0)
        cct(iPoint) = T(equalTo0);
    % Between two lines
    elseif any(lessThan0)
        iClosest = find(lessThan0,true,'first');
        % Calculate CCT by interpolation between isotemperature lines
        D1 = d1(iClosest);
        D2 = d2(iClosest);
        Tj = T(iClosest);
        Tj1 = T(iClosest+1);
        cct(iPoint) = 1/(1/Tj+D1/(D1-D2)*(1/Tj1-1/Tj));
    end
    % Otherwise not able to calculate CCT, u,v coordinates outside range.
    % No value will be written to cct(iPoint) and will remain NaN
end

end

