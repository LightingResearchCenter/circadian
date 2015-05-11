function [nlm,fStat,pVal] = cos_fit_nlm(X,y)
%COS_FIT_NLM Summary of this function goes here
%   Detailed explanation goes here

% Fit a cosine curve
cm = sigmoidfit.cos_fit(X,y);

% Get starting coefficient values from cosine fit
min0 = mean(y) - cm.amp;
amp0 = cm.amp;
phi0 = cm.phi;

% Assign coefficients
coefNames = {'min', 'amp', 'phi'};
b0 = [min0, amp0, phi0]; % min, amp, phi

% Fit nonlinear model
nlm = fitnlm(X,y,@modelfun,b0,'CoefficientNames',coefNames);

% Calculate F-statistic and p-value
[fStat,pVal,emptyNullModel,hasIntercept] = sigmoidfit.ftest(nlm);

end


function y = modelfun(b,X)
%MODELFUN Wrapper for the transformed cosine function
%   Detailed explanation goes here

minR	= b(1); % min (minimum)
amp     = b(2); % amp (amplitude)
phi     = b(3); % phi (acrophase)

y = minR + amp.*sigmoidfit.cos_trans(X,phi);

end