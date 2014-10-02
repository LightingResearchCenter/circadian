function Average = daysimeteraverages(csArray,illuminanceArray,activityArray)
%DAYSIMETERAVERAGES Summary of this function goes here
%   Detailed explanation goes here

import reports.composite.*;

% Preallocate output
Average = struct(...
    'cs'         , {[]},...
    'illuminance', {[]},...
    'activity'   , {[]});

% Average data
Average.cs          = nonzeromean(csArray);
Average.illuminance = logmean(illuminanceArray);
Average.activity    = nonzeromean(activityArray);

end

