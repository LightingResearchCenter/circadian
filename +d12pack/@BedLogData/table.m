function t = table(obj)
%TABLE Summary of this function goes here
%   Detailed explanation goes here

varNames = {'BedTime','RiseTime'};
t = table(vertcat(obj.BedTime),vertcat(obj.RiseTime),'VariableNames',varNames);

end

