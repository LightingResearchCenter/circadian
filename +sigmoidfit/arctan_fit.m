function [nlm,fStat,pVal,varargout] = arctan_fit(X,y,varargin)
%ARCTAN_FIT Summary of this function goes here
%   Detailed explanation goes here

if nargin > 2
    cm  = varargin{1};
else
    % Fit a cosine curve
    cm = sigmoidfit.cos_fit(X,y);
end

% Get starting coefficient values from cosine fit
min0 = mean(y) - 1.5*cm.amp;
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

if nargout > 3
    varargout{1,1} = cm;
end

end


function y = modelfun(b,X)
%MODELFUN Wrapper for the transformed arctan function
%   Detailed explanation goes here

minR	= b(1); % min (minimum)
amp     = b(2); % amp (amplitude)
phi     = b(3); % phi (acrophase)
alpha	= b(4); % alpha (width parameter)
beta    = b(5); % beta (steepness parameter)

y = sigmoidfit.arctan_trans(X,minR,amp,phi,alpha,beta);

end