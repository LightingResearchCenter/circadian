function average = logmean(data)
%LOGMEAN Transform data to log space take the mean and untransform
%   data is a vector of real numbers

import reports.composite.*;

nonZeroIdx = data >= 0.01;
nonZeroData = data(nonZeroIdx);
logData = log(nonZeroData);
averageLog = mean(logData);
average = exp(averageLog);

end

