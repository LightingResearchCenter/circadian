function [nlm,fStat,pVal,varargout] = hill_fit(X,y,varargin)
%HILL_FIT Summary of this function goes here
%   Detailed explanation goes here

if nargin > 2
    cm  = varargin{1};
else
    % Fit a cosine curve
    cm = sigmoidfit.cos_fit(X,y);
end

% Get starting coefficient values from cosine fit
min0   = mean(y) - cm.amp;
amp0   = cm.amp;
phi0   = cm.phi;
m0     = 0.5;
gamma0 = 1.4;

% Assign coefficients
coefNames = {'min', 'amp', 'phi', 'm', 'gamma'};
b0 = [min0, amp0, phi0, m0, gamma0]; % min, amp, phi, m, gamma

% Fit nonlinear model
nlm = fitnlm(X,y,@modelfun,b0,'CoefficientNames',coefNames);

% Calculate F-statistic and p-value
[fStat,pVal,emptyNullModel,hasIntercept] = sigmoidfit.ftest(nlm);

if nargout > 3
    varargout{1,1} = cm;
end

end


function y = modelfun(b,X)
%MODELFUN Wrapper for the transformed Hill function
%   Detailed explanation goes here

minR	= b(1); % min (minimum)
amp     = b(2); % amp (amplitude)
phi     = b(3); % phi (acrophase)
m       = b(4); % alpha (width parameter)
gamma	= b(5); % beta (steepness parameter)

y = sigmoidfit.hill_trans(X,minR,amp,phi,m,gamma);

end