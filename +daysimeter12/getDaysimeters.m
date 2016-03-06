function daysimeters = getDaysimeters
%GETDAYSIMETERS Summary of this function goes here
%   Detailed explanation goes here

drvs = getDrives;

tf = cellfun(@isDaysimeter,drvs);

daysimeters = drvs(tf);

end

