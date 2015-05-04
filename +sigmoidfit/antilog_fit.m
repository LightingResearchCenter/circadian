function [nlm,fStat,pVal,cm] = antilog_fit(X,y)
%ANTILOG_FIT Summary of this function goes here
%   Detailed explanation goes here

% Fit a cosine curve
cm = sigmoidfit.cos_fit(X,y);

% Get starting coefficient values from cosine fit
min0 = mean(y) - cm.amp;
amp0 = cm.amp;
phi0 = cm.phi;
alpha0 = 0;
beta0 = 2;

% Assign coefficients
coefNames = {'min', 'amp', 'phi', 'alpha', 'beta'};
b0 = [min0, amp0, phi0, alpha0, beta0]; % min, amp, phi, alpha, beta

% Fit nonlinear model
nlm = fitnlm(X,y,@modelfun,b0,'CoefficientNames',coefNames);

% Calculate F-statistic and p-value
[fStat,pVal,emptyNullModel,hasIntercept] = sigmoidfit.ftest(nlm);

end


function y = modelfun(b,X)
%MODELFUN Wrapper for the transformed antilog function
%   Detailed explanation goes here

minR	= b(1); % min (minimum)
amp     = b(2); % amp (amplitude)
phi     = b(3); % phi (acrophase)
alpha	= b(4); % alpha (width parameter)
beta    = b(5); % beta (steepness parameter)

y = sigmoidfit.antilog_trans(X,minR,amp,phi,alpha,beta);

end