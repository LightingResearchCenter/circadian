function [iv_m,iv_60] = IVm(dataArray,epoch)
%IVm Summary of this function goes here
%   Detailed explanation goes here
%
% See also SAMPLINGRATE.

n1 = numel(dataArray);
if (n1 < 24 || n1*epoch.hours < 24)
    error('Cannot compute statistic because time series is less than 24 hours');
end

if epoch.hours > 1
    error('Cannot compute statistic becasue time increment is larger than one hour');
end

if (rem(1/epoch.hours,1) > eps)
    error('epoch does not divide into an hour without a remainder');
end

% Make sure dataArray spans whole days, remove excess from end
nDay = floor(n1*epoch.minutes/1440);
n2 = floor(nDay*1440/epoch.minutes);
dataArray = dataArray(1:n2);

% Find ranges between 1 and 60 mins
r1 = max([1,epoch.minutes]);
rangeArray = r1:r1:60;
nRange = numel(rangeArray);

iv = zeros(nRange,1); % Preallocated IV array
for iRange = 1:nRange
    % Resample data to the specified range size
    thisRange = rangeArray(iRange);
    resampledDataArray = isiv.resample(dataArray,epoch,thisRange);
    % Find the IV for this range size
    rangeMean = mean(resampledDataArray);
    nSample = numel(resampledDataArray);
    iv(iRange) =	(sum(diff(resampledDataArray).^2)/(nSample-1))...
                    /(sum((resampledDataArray-rangeMean).^2)/nSample);
end

iv_m = mean(iv);
iv_60 = iv(nRange);


end
