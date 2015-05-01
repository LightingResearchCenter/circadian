function mdl = antilog_fit(X,y)
%ANTILOG_FIT Summary of this function goes here
%   Detailed explanation goes here

coeNames = {'min', 'amp', 'phi', 'alpha', 'beta'};
beta0 = [0.02, 0.8, 170, 0, 2]; % min, amp, phi, alpha, beta

mdl = fitnlm(X,y,@modelfun,beta0,'CoefficientNames',coeNames);

end


function y = modelfun(b,X)
%MODELFUN Summary of this function goes here
%   Detailed explanation goes here

minR	= b(1); % min (minimum)
amp     = b(2); % amp (amplitude)
phi     = b(3); % phi (acrophase)
alpha	= b(4); % alpha (width parameter)
beta    = b(5); % beta (steepness parameter)

y = sigmoidfit.antilog_trans(X,minR,amp,phi,alpha,beta);

end