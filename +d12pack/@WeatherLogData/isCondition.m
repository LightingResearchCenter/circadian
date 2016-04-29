function TF = isCondition(obj,Time,TestCondition)
%ISCONDITION Summary of this function goes here
%   Detailed explanation goes here

Date = vertcat(obj.Date);
Condition = {obj.Condition}';

% Find dates of TestCondition
idxCondition = strcmpi(TestCondition,Condition);
Date = Date(idxCondition);

% Remove empty or partial pairs
Date(isnat(Date) | isempty(Date)) = [];

% Convert datetime yo year month day
[y,m,d] = ymd(Date);
Date_ymd = [y,m,d];

[y,m,d] = ymd(Time);
Time_ymd = [y,m,d];

% Test for condition
TF = ismember(Time_ymd,Date_ymd,'rows');

end

