function [interdailyStability,intradailyVariability] = isiv(dataArray,epoch)
% ISIV Calculates interdaily stability (IS) and intradaily variability (IV)
%	Returns the interdaily stability and the intradaily variability 
%   statistic for time series dataArray.
%	dataArray is a column vector and must be in equal time increments
%	given by epoch an object of class samplingrate.
%	Converts data to hourly increments before calculating metric.
%
% EXAMPLE:
%   [interdailyStability,intradailyVariability] = ...
%   isiv.isiv(dataArray,epoch);
%
% See also SAMPLINGRATE.

import shared.nonanmean periodograms.enright;

n = numel(dataArray);
if (n < 24 || n*epoch.hours < 24)
    error('Cannot compute statistic because time series is less than 24 hours');
end

if epoch.hours > 1
    error('Cannot compute statistic becasue time increment is larger than one hour');
end

if (rem(1/epoch.hours,1) > eps)
    warning('epoch does not divide into an hour without a remainder');
end

% Convert to hourly data increments
nHours = floor(n*epoch.hours); % Number of whole hours of data
hourlyDataArray = zeros(nHours,1); % Preallocate Ahourly
for i1 = 1:nHours % 1 to the number of hours of data
    idx = floor((i1-1)/epoch.hours+1):floor(i1/epoch.hours);
    hourlyDataArray(i1) = nonanmean(dataArray(idx));
end

maxPeriod = 24; % maximum period in hours

period = enright(hourlyDataArray,maxPeriod);

interdailyStability = period^2/var(hourlyDataArray,1);

hourlyMean = mean(hourlyDataArray);

intradailyVariability =  (sum(diff(hourlyDataArray).^2)/(nHours-1))...
                        /(sum((hourlyDataArray-hourlyMean).^2)/nHours);


end