function Groups = slicedata2breaks(timeArray,varargin)
%SLICEDATA2BREAKS Separate data into groups if there is a break in sampling
%   Data arrays must be equal in length to the timeArray.
%   Breaks is a struct of structs one for each group containing arrays
%   named the same as they were input.
%
%   Example:
%   Breaks = slicedata2breaks(timeArray,csArray,activityArray);
%   Breaks(1).timeArray     = the first group's timeArray
%   Breaks(1).lightArray    = the first group's lightArray
%   Breaks(1).activityArray = the first group's activityArray

import daysigram.*;

% Check that at least one data array is given
narginchk(2,inf)

% Preallocate the output struct
Groups = struct;

% Detect the sampling epoch
dTimeArray = diff(timeArray);
epoch = mode(dTimeArray);

% Find breaks in the sampled data
breakIdx = dTimeArray > 1.5*epoch;
tempIdx = find(breakIdx);
startIdx = [1;tempIdx(:)+1];
stopIdx = [tempIdx(:);numel(timeArray)];

% The number of groups of data to be binned
nGroups = numel(startIdx);
% The number of variables being binned
nVars = numel(varargin);

for i1 = 1:nGroups
    % Indices of times within the group
	idx = startIdx(i1):stopIdx(i1);
    % Bin the timeArray
    Groups(i1,1).timeArray = timeArray(idx);
    % Bin the other variables
    for j1 = 1:nVars
    	Groups(i1,1).(inputname(j1+1)) = varargin{j1}(idx);
    end
end

end

