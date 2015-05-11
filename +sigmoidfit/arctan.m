function psi = arctan(x,alpha,beta)
%ARCTAN Summary of this function goes here
%   Detailed explanation goes here

psi = atan(beta.*(x-alpha))./pi + 0.5;

end

