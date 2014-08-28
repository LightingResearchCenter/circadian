classdef relativetime
    %RELATIVETIME Summary of this class goes here
    %   Detailed explanation goes here
    
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

