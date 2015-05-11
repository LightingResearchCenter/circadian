function h = hill(x,gamma,m)
%HILL Computes Hill function
%   Detailed explanation goes here

h = (x.^gamma)./(m.^gamma + x.^gamma);

end

