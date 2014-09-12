classdef utcoffset
    %UTCOFFSET Offset of local time from UTC in several units.
    %
    %   Constructor syntax:
    %   obj = utcoffset(offset,offsetUnit)
    %   offset      - Offset from UTC as a numeric array the size of your time array
    %   offsetUnit	- 'hours','minutes','seconds','milliseconds'
    %
    % UTCOFFSET properties:
    %   hours           - Offset from UTC in hours
    %   minutes         - Offset from UTC in minutes
    %   seconds         - Offset from UTC in seconds
    %   milliseconds	- Offset from UTC in milliseconds
    %
    %   All properties are dependent. Changing one property will update all
    %   the others.
    %
    % EXAMPLES:
    %   offsetArray = repmat(-5,size(timeArray));
    %   offset = utcoffset(offsetArray,'hours');
    %   offsetInMilliseconds = offset.milliseconds;
    %
    % See also ABSOLUTETIME.
    
    % Copyright 2014-2014 Rensselaer Polytechnic Institute
    
    properties(Dependent)
        hours
        minutes
        seconds
        milliseconds
    end
    properties(Access=private)
        privateHours
        privateMinutes
        privateSeconds
        privateMilliseconds
    end
    
    methods
        % Object creation
        function obj = utcoffset(offset,offsetUnit)
            offsetUnit = lower(offsetUnit);
            switch offsetUnit
                case 'hours'
                    obj.hours = offset;
                case 'minutes'
                    obj.minutes = offset;
                case 'seconds'
                    obj.seconds = offset;
                case 'milliseconds'
                    obj.milliseconds = offset;
                otherwise
                    error('Unknown offsetUnit');
            end % End of switch.
        end % End of function.
        
        % Get and set hours.
        function offset = get.hours(obj)
            offset = obj.privateHours;
        end
        function obj = set.hours(obj,offset)
            obj.privateHours = offset;
            obj.privateMinutes = offset*60;
            obj.privateSeconds = offset*60*60;
            obj.privateMilliseconds = offset*60*60*1000;
        end
        
        % Get and set minutes.
        function offset = get.minutes(obj)
            offset = obj.privateMinutes;
        end
        function obj = set.minutes(obj,offset)
            obj.privateHours = offset/60;
            obj.privateMinutes = offset;
            obj.privateSeconds = offset*60;
            obj.privateMilliseconds = offset*60*1000;
        end
        
        % Get and set seconds.
        function offset = get.seconds(obj)
            offset = obj.privateSeconds;
        end
        function obj = set.seconds(obj,offset)
            obj.privateHours = offset/(60*60);
            obj.privateMinutes = offset/60;
            obj.privateSeconds = offset;
            obj.privateMilliseconds = offset*1000;
        end
        
        % Get and set milliseconds.
        function offset = get.milliseconds(obj)
            offset = obj.privateMilliseconds;
        end
        function obj = set.milliseconds(obj,offset)
            obj.privateHours = offset/(60*60*1000);
            obj.privateMinutes = offset/(60*1000);
            obj.privateSeconds = offset/1000;
            obj.privateMilliseconds = offset;
        end
    end
    
end

