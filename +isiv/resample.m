function resampledDataArray = resample(dataArray,epoch,range)
%RESAMPLE Summary of this function goes here
%   dataArrya
%   epoch is object of class samplingrate
%   range is in minutes
%
% See also SAMPLINGRATE.

n = numel(dataArray);
sampleSize = floor(range/epoch.minutes); % Number of data points within a range
nSamples = floor(n/sampleSize); % Number of whole sample ranges of data
% Remove extra data from end
dataArray = dataArray(1:nSamples*sampleSize);
% Reshape data into a matrix
dataMatrix = reshape(dataArray,[sampleSize,nSamples])';
% Take mean to resample data
resampledDataArray = mean(dataMatrix,2);

end

