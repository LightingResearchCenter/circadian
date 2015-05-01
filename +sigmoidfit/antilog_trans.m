function r = antilog_trans(t,phi,k,alpha,beta,minR,amp)
%ANTILOG_TRANS Summary of this function goes here
%   Detailed explanation goes here

c = sigmoidfit.cos_trans(t,phi,k);
x = c + 1;
l = sigmoidfit.antilog(x,alpha,beta);
r = minR + amp.*l;

end

