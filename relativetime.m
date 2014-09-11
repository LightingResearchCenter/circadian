classdef relativetime
    %RELATIVETIME Stores time relative to an absolute start time.
    %   All time formats are first converted to milliseconds from the start
    %   time and rounded to the nearest second, then converted to all other
    %   units.
    %
    %   Time formats:
    %   cdfepoch	- milliseconds from midnight January 1, 0000 CE
    %   datevec     - Gregorian date vector [Y,MO,D,H,MI,S]
    %   datenum     - days since January 0, 0000 CE
    %   excel       - days since January 0, 1900 CE
    %   labview     - seconds since January 1, 1904 CE
    %
    %   Contructor syntax:
    %   obj = relativetime(time,timeType,utc,offset,offsetUnit);
    %   time        - vertical array of an accepted time type
    %   timeType	- 'cdfepoch','datevec','datenum','excel','labview'
    %   utc         - true (in UTC) or false (in local time)
    %   offset      - offset of local time from UTC
    %   offsetUnit	- 'hours','minutes','seconds','milliseconds'
    %   
    % RELATIVETIME properties:
    %       startTime       - singular ABSOLUTETIME object
    %       days            - relative time in days
    %       hours           - relative time in hours
    %       minutes         - relative time in minutes
    %       seconds         - relative time in seconds
    %       milliseconds	- relative time in milliseconds
    %	
    %   All of the relative time properties are dependent. Setting one of 
    %   the relative time properties will update all the other relative 
    %   time properties. STARTTIME is independent and modifying it will not
    %   update the other properties.
    %
    % EXAMPLES:
    %	relTime = relativetime(timeArray,'datenum',false,-5,'hours');
    %	relativeMinutesArray = relTime.minutes;
    %   startTimeDatenum = relTime.startTime.datenum;
    %   
    % See also ABSOLUTETIME, CDFLIB, DATEVEC, DATENUM.
    
    % Copyright 2014-2014 Rensselaer Polytechnic Institute
    
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
        function obj = relativetime(time,timeType,utc,offset,offsetUnit)
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
                offset,offsetUnit);
            
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

