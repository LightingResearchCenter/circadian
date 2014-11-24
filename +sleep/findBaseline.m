function baselineActivity = findBaseline(activity)
%FINDBASELINE Find the level of background noise
%   Detailed explanation goes here
import sleep.*

% Find half of the maximum activity
halfMax = 0.5*max(activity);

% Round activity to 3 significant figures
activity = roundsd(activity,3);

% Find activity greater than zero and less than half of the maximum
% Index of activity that matches the criteria
idx = (activity < halfMax) & (activity > 0);
% Array of activity that matches the criteria
nonzeroHalfActivity = activity(idx);

% Find the mode of the rounded activity less than 50% of the max
baselineActivity = mode(nonzeroHalfActivity);

end

