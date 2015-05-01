function r = arctan_trans(t,minR,amp,phi,alpha,beta)
%ARCTAN_TRANS Summary of this function goes here
%   Detailed explanation goes here

c = sigmoidfit.cos_trans(t,phi);
x = c + 1;
psi = sigmoidfit.arctan(x,alpha,beta);
r = minR + amp.*psi;

end

