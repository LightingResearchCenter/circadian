classdef utcoffset
    %UTCOFFSET Summary of this class goes here
    %   Detailed explanation goes here
    
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
        function obj = utcoffset(utcOffset,offsetUnit)
            offsetUnit = lower(offsetUnit);
            switch offsetUnit
                case 'hours'
                    obj.hours = utcOffset;
                case 'minutes'
                    obj.minutes = utcOffset;
                case 'seconds'
                    obj.seconds = utcOffset;
                case 'milliseconds'
                    obj.milliseconds = utcOffset;
                otherwise
                    error('Unknown offsetUnit');
            end % End of switch.
        end % End of function.
        
        % Get and set hours.
        function utcOffset = get.hours(obj)
            utcOffset = obj.privateHours;
        end
        function obj = set.hours(obj,utcOffset)
            obj.privateHours = utcOffset;
            obj.privateMinutes = utcOffset*60;
            obj.privateSeconds = utcOffset*60*60;
            obj.privateMilliseconds = utcOffset*60*60*1000;
        end
        
        % Get and set minutes.
        function utcOffset = get.minutes(obj)
            utcOffset = obj.privateMinutes;
        end
        function obj = set.minutes(obj,utcOffset)
            obj.privateHours = utcOffset/60;
            obj.privateMinutes = utcOffset;
            obj.privateSeconds = utcOffset*60;
            obj.privateMilliseconds = utcOffset*60*1000;
        end
        
        % Get and set seconds.
        function utcOffset = get.seconds(obj)
            utcOffset = obj.privateSeconds;
        end
        function obj = set.seconds(obj,utcOffset)
            obj.privateHours = utcOffset/(60*60);
            obj.privateMinutes = utcOffset/60;
            obj.privateSeconds = utcOffset;
            obj.privateMilliseconds = utcOffset*1000;
        end
        
        % Get and set milliseconds.
        function utcOffset = get.milliseconds(obj)
            utcOffset = obj.privateMilliseconds;
        end
        function obj = set.milliseconds(obj,utcOffset)
            obj.privateHours = utcOffset/(60*60*1000);
            obj.privateMinutes = utcOffset/(60*1000);
            obj.privateSeconds = utcOffset/1000;
            obj.privateMilliseconds = utcOffset;
        end
    end
    
end

