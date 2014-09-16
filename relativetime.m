classdef relativetime
    %RELATIVETIME Stores time relative to an absolute start time.
    %   All time formats are first converted to milliseconds from the start
    %   time and rounded to the nearest second, then converted to all other
    %   units.
    %
    %   Contructor syntax:
    %   obj = relativetime(time);
    %   obj = relativetime(time,timeType);
    %   time        - absolutetime object or array of an accepted time type
    %   timeType	- 'absolutetime','days','hours','minutes','seconds','milliseconds'
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
    %	relTime = relativetime(absTime);
    %   relTime = relativetime(relTimeInHours,'hours')
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
        function obj = relativetime(time,varargin)
        %RELATIVETIME Method details go here
            
            % Parse the input
            p = inputParser;
            addRequired(p,'time');
            addOptional(p,'timeType','absolutetime',@ischar);
            parse(p,time,varargin{:});
            
            timeType = lower(p.Results.timeType);
            switch timeType
                case 'absolutetime'
                    obj.startTime = time;
                    obj.startTime.utcCdfEpoch = time.utcCdfEpoch(1);
                    obj.milliseconds = time.utcCdfEpoch - time.utcCdfEpoch(1);
                case 'days'
                    obj.days = time;
                case 'hours'
                    obj.hours = time;
                case 'minutes'
                    obj.minutes = time;
                case 'seconds'
                    obj.seconds = time;
                case 'milliseconds'
                    obj.milliseconds = time;
                otherwise
                    error('Unknown timeType');
            end % End of switch
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

