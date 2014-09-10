classdef relativetime
    %RELATIVETIME Stores time relative to an absolute start time.
    %   All time formats are first converted to milliseconds from the start
    %   time and rounded to the nearest second, then converted to all other
    %   units.
    %   
    %   Initial object creation follows the following format
    %   obj = relative(time,timeType,utc,utcOffsetHours)
    %   where,
    %   
    %   time: is a vertical array of one of the five accepted time types
    %   timeType: is a string indicating the type of time being input
    %   utc: is true or false, true meaning the input time is in UTC time,
    %   false meaning the input time is in local time
    %   utcOffset: is the offset of local time from UTC in one of the
    %   accepted offset units
    %   offsetUnit: is a string indicating the unit of utcOffset
    %   
    %   offsetUnit = 'hours', 'minutes', 'seconds', 'milliseconds'
    %   
    %   timeType = 'cdfepoch', 'datevec', 'datenum', 'excel', or 'labview
    %   cdfepoch: is the milliseconds format not to be confused with a
    %   cdfepoch object
    %   datevec: is the MATLAB datevec format of [Y,MO,D,H,MI,S]
    %   datenum: is the MATLAB datenum format of days since
    %   January 0, 0000 CE
    %   excel: is the modern MS Excel serial date format of days since
    %   January 0, 1900 CE
    %   labview: is the Labview timestamp format of seconds since
    %   January 1, 1904 CE
    %   
    %   The properties of relativetime are:
    %       startTime       (singular absolutetime object)
    %       days            (relative time in days)
    %       hours           (relative time in hours)
    %       minutes         (relative time in minutes)
    %       seconds         (relative time in seconds)
    %       milliseconds	(relative time in milliseconds)
    %	
    %   All of the relative time properties are dependent. Setting one of 
    %   the relative time properties will update all the other relative 
    %   time properties. STARTTIME is independent and modifying it will not
    %   update the other properties.
    %   
    %   EXAMPLES:
    %   
    %	relTime = relativetime(timeArray,'datenum',false,-5,'hours')
    %	
    %	relativeMinutesArray = relTime.minutes
    %   
    %   startTimeDatenum = relTime.startTime.datenum
    %   
    %   See also ABSOLUTETIME, CDFLIB, DATEVEC, and DATENUM
    
    properties
        startTime
    end
    properties(Dependent)
        days
        hours
        minutes
        seconds
        milliseconds
    end
    properties(Access=private)
        privateDays
        privateHours
        privateMinutes
        privateSeconds
        privateMilliseconds
    end
    
    methods
        % Object creation
        function obj = relativetime(time,timeType,utc,utcOffset,offsetUnit)
            timeType = lower(timeType);
            switch timeType
                case 'datenum'
                    nTime = size(time,1);
                    dateNum = time;
                    dateVec = datevec(dateNum);
                    timeVec = [dateVec,zeros(nTime,1)];
                    timeVec(:,7) = (timeVec(:,6) - floor(timeVec(:,6)))*1000;
                    timeVec(:,6) = floor(timeVec(:,6));
                    cdfEpoch = cdflib.computeEpoch(timeVec');
                    cdfEpoch = cdfEpoch';
                case 'datevec'
                    nTime = size(time,1);
                    dateVec = time;
                    timeVec = [dateVec,zeros(nTime,1)];
                    timeVec(:,7) = (timeVec(:,6) - floor(timeVec(:,6)))*1000;
                    timeVec(:,6) = floor(timeVec(:,6));
                    cdfEpoch = cdflib.computeEpoch(timeVec');
                    cdfEpoch = cdfEpoch';
                case 'cdfepoch'
                    cdfEpoch = time;
                otherwise
                    error('Unknown timeType');
            end % End of switch
            
            obj.milliseconds = cdfEpoch - cdfEpoch(1);
            
            obj.startTime = absolutetime(cdfEpoch(1),'cdfepoch',utc,...
                utcOffset,offsetUnit);
            
        end % End of function
        
        % Get and set milliseconds.
        function time = get.milliseconds(obj)
            time = obj.privateMilliseconds;
        end
        function obj = set.milliseconds(obj,time)
            milliseconds = round(time/1000)*1000;
            seconds      = milliseconds/1000;
            minutes      = seconds/60;
            hours        = seconds/(60*60);
            days         = seconds/(60*60*24);
            
            obj.privateMilliseconds	= milliseconds;
            obj.privateSeconds      = seconds;
            obj.privateMinutes      = minutes;
            obj.privateHours        = hours;
            obj.privateDays         = days;
        end
        
        % Get and set seconds.
        function time = get.seconds(obj)
            time = obj.privateSeconds;
        end
        function obj = set.seconds(obj,time)
            seconds      = round(time);
            milliseconds = seconds*1000;
            minutes      = seconds/60;
            hours        = seconds/(60*60);
            days         = seconds/(60*60*24);
            
            obj.privateMilliseconds	= milliseconds;
            obj.privateSeconds      = seconds;
            obj.privateMinutes      = minutes;
            obj.privateHours        = hours;
            obj.privateDays         = days;
        end
        
        % Get and set minutes.
        function time = get.minutes(obj)
            time = obj.privateMinutes;
        end
        function obj = set.minutes(obj,time)
            minutes      = time;
            seconds      = round(minutes*60);
            milliseconds = seconds*1000;
            minutes      = seconds/60;
            hours        = seconds/(60*60);
            days         = seconds/(60*60*24);
            
            obj.privateMilliseconds	= milliseconds;
            obj.privateSeconds      = seconds;
            obj.privateMinutes      = minutes;
            obj.privateHours        = hours;
            obj.privateDays         = days;
        end
        
        % Get and set hours.
        function time = get.hours(obj)
            time = obj.privateHours;
        end
        function obj = set.hours(obj,time)
            hours        = time;
            seconds      = round(hours*60*60);
            milliseconds = seconds*1000;
            minutes      = seconds/60;
            hours        = seconds/(60*60);
            days         = seconds/(60*60*24);
            
            obj.privateMilliseconds	= milliseconds;
            obj.privateSeconds      = seconds;
            obj.privateMinutes      = minutes;
            obj.privateHours        = hours;
            obj.privateDays         = days;
        end
        
        % Get and set days.
        function time = get.days(obj)
            time = obj.privateDays;
        end
        function obj = set.days(obj,time)
            days         = time;
            seconds      = round(days*24*60*60);
            milliseconds = seconds*1000;
            minutes      = seconds/60;
            hours        = seconds/(60*60);
            days         = seconds/(60*60*24);
            
            obj.privateMilliseconds	= milliseconds;
            obj.privateSeconds      = seconds;
            obj.privateMinutes      = minutes;
            obj.privateHours        = hours;
            obj.privateDays         = days;
        end
        
    end
    
end

