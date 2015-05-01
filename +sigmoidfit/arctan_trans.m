function r = arctan_trans(t,phi,k,alpha,beta,minR,amp)
%ARCTAN_TRANS Summary of this function goes here
%   Detailed explanation goes here

c = sigmoidfit.cos_trans(t,phi,k);
x = c + 1;
psi = sigmoidfit.arctan(x,alpha,beta);
r = minR + amp.*psi;

end

