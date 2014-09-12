classdef samplingrate
    %SAMPLINGRATE Data collection sampling rate in several units.
    %   All input is rounded to the nearest second before being converted
    %   to other units.
    %
    %   Constructor syntax:
    %   obj = samplingrate(epoch,units)
    %   epoch	- A single numeric value of the sampling rate
    %   units   - 'days','hours','minutes','seconds','hertz'
    %
    % SAMPLINGRATE properties:
    %   days	- sampling rate in days
    %   hours	- sampling rate in hours
    %   minutes	- sampling rate in minutes
    %   seconds	- sampling rate in seconds
    %   hertz	- sampling rate in hertz
    %
    %   All properties are dependent. Changing one property will update all
    %   the others.
    %
    % EXAMPLES:
    %   epoch = samplingrate(30,'seconds');
    %   rateInHertz = epoch.hertz;
    %
    % See also DAYSIMETER12.CONVERTCDF.
    
    % Copyright 2014-2014 Rensselaer Polytechnic Institute
    
    properties(Dependent)
        days
        hours
        minutes
        seconds
        hertz
    end
    properties(Access=private)
        privateDays
        privateHours
        privateMinutes
        privateSeconds
        privateHertz
    end
    
    methods
        % Object creation
        function obj = samplingrate(epoch,units)
            units = lower(units);
            switch units
                case 'days'
                    obj.days = epoch;
                case 'hours'
                    obj.hours = epoch;
                case 'minutes'
                    obj.minutes = epoch;
                case 'seconds'
                    obj.seconds = epoch;
                case 'hertz'
                    obj.hertz = epoch;
                otherwise
                    error('Unknown units');
            end % End of switch
        end % End of function
        
        % Get and set days.
        function epoch = get.days(obj)
            epoch = obj.privateDays;
        end
        function obj = set.days(obj,epoch)
            obj.privateDays = epoch;
            % Round to whole seconds.
            seconds = round(epoch*24*60*60);
            obj.privateHours   = seconds/(60*60);
            obj.privateMinutes = seconds/60;
            obj.privateSeconds = seconds;
            obj.privateHertz   = 1/seconds;
        end
        
        % Get and set hours.
        function epoch = get.hours(obj)
            epoch = obj.privateHours;
        end
        function obj = set.hours(obj,epoch)
            obj.privateHours = epoch;
            % Round to whole seconds.
            seconds = round(epoch*60*60);
            obj.privateDays    = seconds/(24*60*60);
            obj.privateMinutes = seconds/60;
            obj.privateSeconds = seconds;
            obj.privateHertz   = 1/seconds;
        end
        
        % Get and set minutes.
        function epoch = get.minutes(obj)
            epoch = obj.privateMinutes;
        end
        function obj = set.minutes(obj,epoch)
            obj.privateMinutes = epoch;
            % Round to whole seconds.
            seconds = round(epoch*60);
            obj.privateDays    = seconds/(24*60*60);
            obj.privateHours   = seconds/(60*60);
            obj.privateSeconds = seconds;
            obj.privateHertz   = 1/seconds;
        end
        
        % Get and set seconds.
        function epoch = get.seconds(obj)
            epoch = obj.privateSeconds;
        end
        function obj = set.seconds(obj,epoch)
            % Round to whole seconds.
            seconds = round(epoch);
            obj.privateSeconds = seconds;
            obj.privateDays    = seconds/(24*60*60);
            obj.privateHours   = seconds/(60*60);
            obj.privateMinutes = seconds/60;
            obj.privateHertz   = 1/seconds;
        end
        
        % Get and set hertz.
        function epoch = get.hertz(obj)
            epoch = obj.privateHertz;
        end
        function obj = set.hertz(obj,epoch)
            obj.privateHertz   = epoch;
            % Round to whole seconds.
            seconds = round(1/epoch);
            obj.privateDays    = seconds/(24*60*60);
            obj.privateHours   = seconds/(60*60);
            obj.privateMinutes = seconds/60;
            obj.privateSeconds = seconds;
        end
    end
    
end

