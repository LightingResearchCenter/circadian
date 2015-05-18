function [IS,IV] = isiv(dataArray,epoch)
% ISIV Calculates interdaily stability (IS) and intradaily variability (IV)
%	Returns the interdaily stability and the intradaily variability 
%   statistic for time series dataArray.
%	dataArray is a column vector and must be in equal time increments
%	given by epoch an object of class samplingrate.
%	Converts data to hourly increments before calculating metric.
%
% EXAMPLE:
%   [IS,IV] = isiv.isiv(dataArray,epoch);
%
% See also SAMPLINGRATE.

import shared.nonanmean periodograms.enright;

n1 = numel(dataArray);
if (n1 < 24 || n1*epoch.hours < 24)
    error('Cannot compute statistic because time series is less than 24 hours');
end

if epoch.hours > 1
    error('Cannot compute statistic becasue time increment is larger than one hour');
end

if (rem(1/epoch.hours,1) > eps)
    warning('epoch does not divide into an hour without a remainder');
end

% Make sure dataArray spans whole days, remove excess from end
nDay = floor(n1*epoch.minutes/1440);
n2 = floor(nDay*1440/epoch.minutes);
dataArray = dataArray(1:n2);

% Resample data to hourly increments
X_i = isiv.resample(dataArray,epoch,60);
% Number of samples
n = numel(X_i);
% Number of samples per day
p = 24;
% Average of samples at each time of day
Xmat = reshape(X_i,[p,nDay]);
Xbar_h = mean(Xmat,2);
% Average of all samples
Xbar = mean(X_i);

% Calculate Interdaily Stability
IS = (n*sum((Xbar_h - Xbar).^2))/(p*sum((X_i - Xbar).^2));
% Calculate Intradail Variability
IV = (n*sum(diff(X_i).^2))/((n-1)*sum((X_i-Xbar).^2));



end