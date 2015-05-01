function r = hill_trans(t,phi,k,gamma,m,minR,amp)
%HILL_TRANS Computes sigmoidally transformed Hill function
%   Detailed explanation goes here

c = sigmoidfit.cos_trans(t,phi,k);
x = c + 1;
h = sigmoidfit.hill(x,gamma,m);
r = minR + amp.*h;

end

