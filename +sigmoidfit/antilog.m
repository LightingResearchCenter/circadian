function l = antilog(x,alpha,beta)
%ANTILOG Summary of this function goes here
%   Detailed explanation goes here

l = exp(beta.*(x-alpha))./(1+exp(beta.*(x-alpha)));

end

