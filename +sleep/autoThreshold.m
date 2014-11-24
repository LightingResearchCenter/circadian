function threshold = autoThreshold(activity,immobility)
%AUTOTHRESHOLD Calculate a threshold
import sleep.*

% Find the mean score in active periods
meanScoreActivePeriods = sum(activity)/numel(activity(~immobility));

% Calculate the threshold
K = 8/9; % threshold factor constant
threshold = meanScoreActivePeriods*K;

% Round the threshold to two decimal places
threshold = round(threshold*100)/100;

% Account for NaN results
if isnan(threshold)
    threshold = 0;
end

end

