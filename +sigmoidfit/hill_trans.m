function r = hill_trans(t,minR,amp,phi,m,gamma)
%HILL_TRANS Computes sigmoidally transformed Hill function
%   Detailed explanation goes here

c = sigmoidfit.cos_trans(t,phi);
x = c + 1;
h = sigmoidfit.hill(x,gamma,m);
r = minR + amp.*h;

end

