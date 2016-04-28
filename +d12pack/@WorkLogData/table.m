function t = table(obj)
%TABLE Summary of this function goes here
%   Detailed explanation goes here

varNames = {'StartTime','EndTime','Workstation'};
t = table(obj.StartTime,obj.EndTime,obj.Workstation,'VariableNames',varNames);

end

