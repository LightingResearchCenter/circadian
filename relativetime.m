classdef relativetime
    %RELATIVETIME Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Constant)
    end
    properties
        utcOffsetHours
    end
    properties(Dependent)
        localStartTime
        utcStartTime
        
        days
        hours
        minutes
        seconds
        milliseconds
    end
    properties(Access=private)
        privateLocalStartTime
        privateUtcStartTime
        
        privateDays
        privateHours
        privateMinutes
        privateSeconds
        privateMilliseconds
    end
    
    methods
        % Object creation
        function obj = relativetime(time,timeType,utc,utcOffsetHours)
            timeType = lower(timeType);
            switch timeType
                case 'datenum'
                    nTime = size(time,1);
                    dateNum = time;
                    dateVec = datevec(dateNum);
                    timeVec = [dateVec,zeros(nTime,1)];
                    timeVec(:,7) = (timeVec(:,6) - floor(timeVec(:,6)))*1000;
                    timeVec(:,6) = floor(timeVec(:,6));
                    cdfEpoch = zeros(nTime,1);
                    for iTime = 1:nTime
                        cdfEpoch(iTime) = cdflib.computeEpoch(timeVec(iTime,:));
                    end
                case 'datevec'
                    nTime = size(time,1);
                    dateVec = time;
                    timeVec = [dateVec,zeros(nTime,1)];
                    timeVec(:,7) = (timeVec(:,6) - floor(timeVec(:,6)))*1000;
                    timeVec(:,6) = floor(timeVec(:,6));
                    cdfEpoch = zeros(nTime,1);
                    for iTime = 1:nTime
                        cdfEpoch(iTime) = cdflib.computeEpoch(timeVec(iTime,:));
                    end
                case 'cdfepoch'
                    cdfEpoch = time;
                otherwise
                    error('Unknown timeType');
            end % End of switch
            
            obj.utcOffsetHours = utcOffsetHours;
            obj.milliseconds = cdfEpoch - cdfEpoch(1);
            
            if utc
                obj.utcStartTime = singletime(cdfEpoch(1),'cdfepoch');
            else
                obj.localStartTime = singletime(cdfEpoch(1),'cdfepoch');
            end
            
        end % End of function
        
        % Get and set utcStartTime.
        function time = get.utcStartTime(obj)
            time = obj.privateUtcStartTime;
        end
        function obj = set.utcStartTime(obj,startTime)
            obj.privateUtcStartTime = startTime;
            utcOffsetMilliseconds = obj.utcOffsetHours*60*60*1000;
            localStartTime = startTime.cdfEpoch - utcOffsetMilliseconds;
            obj.privateLocalStartTime = singletime(localStartTime,'cdfepoch');
        end
        
        % Get and set localStartTime.
        function time = get.localStartTime(obj)
            time = obj.privateLocalStartTime;
        end
        function obj = set.localStartTime(obj,startTime)
            obj.privateLocalStartTime = startTime;
            utcOffsetMilliseconds = obj.utcOffsetHours*60*60*1000;
            utcStartTime = startTime.cdfEpoch + utcOffsetMilliseconds;
            obj.privateUtcStartTime = singletime(utcStartTime,'cdfepoch');
        end
        
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

