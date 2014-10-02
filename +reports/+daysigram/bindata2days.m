function Days = bindata2days(timeArray,varargin)
% BINDATA2DAYS Takes multiple arrays of data and groups them into days
%   Data arrays must be equal in length to the timeArray.
%   The timeArray must be a vector of MATLAB datenums.
%   Days is a struct of structs one for each day containing arrays named
%   the same as they were input.
%
%   Example:
%   Days = bindata2days(timeArray,csArray,activityArray);
%   Days(1).timeArray     = the first day's timeArray
%   Days(1).lightArray    = the first day's lightArray
%   Days(1).activityArray = the first day's activityArray

import reports.daysigram.*;

% Check that at least one data array is given
narginchk(2,inf)

% Preallocate the output struct
Days = struct;

% Create the dates ranges of the days to be binned
startDateArray = floor(timeArray(1)):floor(timeArray(end));
stopDateArray  = startDateArray + 1;

% The number of days being binned
nDays = numel(startDateArray);
% The number of variables being binned
nVars = numel(varargin);

for i1 = 1:nDays
    % Indices of times within the date range
	idx = timeArray >= startDateArray(i1) & timeArray < stopDateArray(i1);
    % Bin the timeArray
    Days(i1,1).timeArray = timeArray(idx);
    % Bin the other variables
    for j1 = 1:nVars
    	Days(i1,1).(inputname(j1+1)) = varargin{j1}(idx);
    end
end

end