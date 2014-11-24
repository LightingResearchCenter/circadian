function immobility = scoreImmobility(activity,baselineActivity)
%SCOREIMMOBILITY Score activity as immobile(1) or mobile(0)
import sleep.*

% Set a threshold as twice the baseline activity
threshold = baselineActivity*2;

% Score immobility
immobility = activity < threshold;

end

