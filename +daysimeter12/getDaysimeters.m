function daysimeters = getDaysimeters
%GETDAYSIMETERS Get a list of all Daysimeters connected to the computer
%   DAYSIMETERS = GETDAYSIMETERS retuns a cell array that contains strings of
%   the drive names that appear to be daysimters. 
%   
%   *AS OF 3/23/2016*
%   Note: currently this will only work for Windows systems. 

drvs = daysimeter12.getDrives;

tf = cellfun(@daysimeter12.isDaysimeter,drvs);

daysimeters = drvs(tf);

end
