function TF = isAtWork(obj,Time)
%ISATWORK Summary of this function goes here
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
    StartTime = WorkDays + obj.StartTime;
    EndTime   = WorkDays + obj.EndTime;
else % ~obj.IsFixed
    StartTime = obj.StartTime;
    EndTime = obj.EndTime;
end

% Remove empty or partial pairs
idxNaT = isnat(StartTime) | isnat(EndTime);
idxEmpty = isempty(StartTime) | isempty(EndTime);
StartTime(idxNaT | idxEmpty) = [];
EndTime(idxNaT | idxEmpty) = [];

n = numel(StartTime);
if n > 0
    for iWork = 1:n
        temp = Time >= StartTime(iWork) & Time < EndTime(iWork);
        TF = TF | temp;
    end
end

end

