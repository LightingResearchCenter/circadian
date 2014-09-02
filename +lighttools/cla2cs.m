function cs = cla2cs(cla)
%CLA2CS Calculate circadian stimulus (CS) from circadian light (CLA)
%   Detailed explanation goes here

cs = 0.7*(1 - (1./(1 + (cla/355.7).^(1.1026))));

end

