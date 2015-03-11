function dst = isDST(Date)
% ISDST takes a date as a datenum format and outputs a logical,
%	true if the date is during daylight savings time for that year.
%	See definition of daylight savings time in the USA for 2007 on.

Date = Date(:); % make sure Date is a vertical vector

minDate = floor(min(Date));
minDateVec = datevec(minDate);
maxDate = floor(max(Date));
maxDateVec = datevec(maxDate);

if minDate < datenum(2007,01,01)
    error('isDST only works for dates in the year 2007 forward');
end

% preallocate the dst logical vector (as all false)
dst = false(numel(Date),1);

marchDays = 1:31;
novDays = 1:30;

for year = maxDateVec(1):minDateVec(1)
    % Find the second Sunday in March
    marchDates = datenum(year,3,marchDays,2,0,0);
    marchDoW = weekday(marchDates); % March day of week
    marchSundayIdx = find(marchDoW == 1); % Sunday indexes
    % Date of 2nd Sunday in March for that year
    dstStart = marchDates(marchSundayIdx(2));
    
    % Find the first Sunday in November
    novDates = datenum(year,11,novDays,2,0,0);
    novDoW = weekday(novDates); % November day of week
    novSundayIdx = find(novDoW == 1); % Sunday indexes
    % Date of 1st Sunday in November for that year
    dstStop = novDates(novSundayIdx(1));
    
    % Find dates that occur during DST
    dst = dst | (Date >= dstStart & Date < dstStop);
    
end


end