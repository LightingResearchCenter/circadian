function TF = isWorkDay(obj,Time)
%ISWORKDAY Summary of this function goes here
%   Detailed explanation goes here

% Initialize true/false array as false
TF = false(size(Time));

if obj.IsFixed
    TimeDateVec = datevec(Time); % Convert Time to datevec
    TimeDateVec(:,4:6) = 0; % Remove time component leaving only date
    UniqueDateVec = unique(TimeDateVec,'rows'); % Find the unique dates
    UniqueDateTime = datetime(UniqueDateVec,'TimeZone',Time.TimeZone); % Convert back to datetime keeping the original time zone
    WeekDays = UniqueDateTime(~isweekend(UniqueDateTime)); % Keep only week days
    WorkDays = WeekDays(~obj.isFedHoliday(WeekDays)); % Exclude U.S. Federal Holidays
else % ~obj.IsFixed
    StartTime = obj.StartTime;
    EndTime = obj.EndTime;
    [y,m,d] = ymd([StartTime;EndTime]);
    WorkDates = datetime(y,m,d,'TimeZone',Time(1).TimeZone);
    WorkDays = unique(WorkDates);
end

% Remove empty or partial
idxNaT = isnat(WorkDays);
idxEmpty = isempty(WorkDays);
WorkDays(idxNaT | idxEmpty,:) = [];

[y,m,d] = ymd(Time);
Dates = datetime(y,m,d,'TimeZone',Time(1).TimeZone);

n = numel(WorkDays);
if n > 0
    TF = ismember(Dates,WorkDays);
end

end

