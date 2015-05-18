function [is_m,is_60] = ISm(dataArray,epoch)
%ISM Summary of this function goes here
%   Detailed explanation goes here
%
% See also SAMPLINGRATE.

% Check validity of input
n = numel(dataArray);
if (n < 24 || n*epoch.hours < 24)
    error('Cannot compute statistic because time series is less than 24 hours');
end

if epoch.hours > 1
    error('Cannot compute statistic becasue time increment is larger than one hour');
end

if (rem(1/epoch.hours,1) > eps)
    error('epoch does not divide into an hour without a remainder');
end

% Find divisors of 1440 that are multiples of the sampling rate
N = 1440;
k1 = max([1,epoch.minutes]);
K = k1:k1:N;
divisorArray = K(rem(N,K)==0);
divisorArray = divisorArray(divisorArray <= 60);

% Make sure dataArray spans whole days, remove excess from end
nDay = floor(n*epoch.minutes/1440);
n2 = floor(nDay*1440/epoch.minutes);
dataArray = dataArray(1:n2);

nDivisor = numel(divisorArray);
is = zeros(nDivisor,1); % Preallocated IS array
for iRange = 1:nDivisor
    thisRange = divisorArray(iRange);
    pDay = 1440/thisRange;
    % Resample data to the specified range size
    resampledDataArray = isiv.resample(dataArray,epoch,thisRange);
    
    nSample = numel(resampledDataArray);
    % Find the IS for this range size
    resampledDataMatrix = reshape(resampledDataArray,[pDay,nDay]);
    timeMean = mean(resampledDataMatrix,2);
    rangeMean = mean(resampledDataArray);
    numerator = nSample*sum((timeMean - rangeMean).^2);
    denominator = pDay*sum((resampledDataArray - rangeMean).^2);
    
    is(iRange) = numerator/denominator;
end

is_m = mean(is);
is_60 = is(nDivisor);

end

