function Average = daysimeteraverages(csArray,illuminanceArray,activityArray)
%DAYSIMETERAVERAGES Summary of this function goes here
%   Detailed explanation goes here

import reports.composite.*

% Preallocate output
Average = struct(...
    'cs'         , {[]},...
    'illuminance', {[]},...
    'activity'   , {[]});

% Average data
Average.cs          = centraltendency(csArray);
Average.illuminance = centraltendency(illuminanceArray);
Average.activity    = centraltendency(activityArray);

end

