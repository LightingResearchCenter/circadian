function t = table(obj)
%TABLE Summary of this function goes here
%   Detailed explanation goes here

varNames = {'Date','Condition'};
t = table(vertcat(obj.Date),{obj.Condition}','VariableNames',varNames);

end

