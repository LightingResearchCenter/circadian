function [interdailyStability,intradailyVariability] = isivcalc(dataArray,epochSec)
% ISIVCALC 
%	Returns the interdaily stability (IS) and the
%	intradaily variability (IV) statistic for time series A.
%	dataArray is a column vector and must be in equal time increments
%	given by scalar epochSec in units of seconds.
%	Converts data to hourly increments before calculating metric.

n = numel(dataArray);
if (n < 24 || n*epochSec < 24*3600)
    error('Cannot compute statistic because time series is less than 24 hours');
end

if epochSec>3600
    error('Cannot compute statistic becasue time increment is larger than one hour');
end

epochHrs = epochSec/3600; % Convert time increment from seconds to hours

if (rem(1/epochHrs,1) > eps)
    warning('epoch does not divide into an hour without a remainder');
end

% Convert to hourly data increments
nHours = floor(n*epochHrs); % Number of whole hours of data
hourlyDataArray = zeros(nHours,1); % Preallocate Ahourly
for i1 = 1:nHours % 1 to the number of hours of data
    idx = floor((i1-1)/epochHrs+1):floor(i1/epochHrs);
    hourlyDataArray(i1) = nonanmean(dataArray(idx));
end

maxPeriod = 24; % maximum period in hours

period = enrightperiodogram(hourlyDataArray,maxPeriod);

interdailyStability = period^2/var(hourlyDataArray,1);

hourlyMean = mean(hourlyDataArray);

intradailyVariability =  (sum(diff(hourlyDataArray).^2)/(nHours-1))...
                        /(sum((hourlyDataArray-hourlyMean).^2)/nHours);


end