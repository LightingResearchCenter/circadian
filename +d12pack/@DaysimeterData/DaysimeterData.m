classdef DaysimeterData
    %DAYSIMETERDATA Stores data collected by a Daysimeter
    %   Provides processed calibrated data and analysis on demand.
    %   Preferred class construction method is to provide binary files.
    
    % Public properties
    properties
        SerialNumber uint16   % Daysimeter serial number
        Calibration  d12pack.CalibrationData % Calibration values
        CalibrationRatio double % Ratio used when mixing multiple calibration
        CalibrationPath char = '\\root\projects\DaysimeterAndDimesimeterReferenceFiles\recalibration2016\calibration_log.csv';
        Epoch        duration % Logging rate
        
        Time         datetime % Time stamps of readings
        RedCounts    uint16   % Uncalibrated counts from red channel
        GreenCounts  uint16   % Uncalibrated counts from green channel
        BlueCounts   uint16   % Uncalibrated counts from blue channel
        ActivityIndexCounts uint16   % Unconverted counts from activity index
        
        Observation  logical  % True if reading is during observation period
        Error        logical  % True if reading is in error
        Resets       uint16   % Running count of reset flags
        
        Location     d12pack.LocationData
        
        Created      datetime % When the original files were downloaded
        Modified     datetime % When this object was last saved
    end
    
    % Dependent public properties
    properties (Dependent)
        log_info     char     % Unprocessed "log_info.txt" file data
        data_log     uint16   % Unprocessed "data_log.txt" file data
    end
    
    % Dependent read only properties
    properties (Dependent, GetAccess = public, SetAccess = private)
        Red               double % Calibrated red channel readings
        Green             double % Calibrated green channel readings
        Blue              double % Calibrate blue channel readings
        ActivityIndex     double % Converted activity index
        Illuminance       double %
        CircadianLight    double %
        CircadianStimulus double %
    end
    
    % Private properties
    properties (Access = private, Hidden = true)
        log_infoPrivate     char     % Unprocessed "log_info.txt" file data
        data_logPrivate     uint16   % Unprocessed "data_log.txt" file data
    end
    
    % Internal public methods
    methods
        % Class constructor
        function obj = DaysimeterData(log_info_path,data_log_path,varargin)
            if nargin > 0
                obj.log_info = obj.readloginfo(log_info_path);
                obj.data_log = obj.readdatalog(data_log_path);
            end
        end % End of class constructor method
        
        % Set log_info
        function obj = set.log_info(obj,log_info)
            obj.log_infoPrivate = log_info;
            if ~isempty(obj.data_log)
                s = obj.parseraw;
                obj.SerialNumber = s.SerialNumber;
                obj.Epoch = s.Epoch;
                obj.Time = s.Time;
                obj.RedCounts = s.RedCounts;
                obj.GreenCounts = s.GreenCounts;
                obj.BlueCounts = s.BlueCounts;
                obj.ActivityIndexCounts = s.ActivityIndexCounts;
                obj.Resets = s.Resets;
                obj.Calibration = obj.Calibration.import(obj.CalibrationPath,obj.SerialNumber);
            end
        end % End of set log_info
        % Get log_info
        function log_info = get.log_info(obj)
            log_info = obj.log_infoPrivate;
        end % End of get log_info
        
        % Set data_log
        function obj = set.data_log(obj,data_log)
            obj.data_logPrivate = data_log;
            if ~isempty(obj.log_info)
                s = obj.parseraw;
                obj.SerialNumber = s.SerialNumber;
                obj.Epoch = s.Epoch;
                obj.Time = s.Time;
                obj.RedCounts = s.RedCounts;
                obj.GreenCounts = s.GreenCounts;
                obj.BlueCounts = s.BlueCounts;
                obj.ActivityIndexCounts = s.ActivityIndexCounts;
                obj.Resets = s.Resets;
                obj.Calibration = obj.Calibration.import(obj.CalibrationPath,obj.SerialNumber);
            end
        end % End of set data_log
        % Get data_log
        function data_log = get.data_log(obj)
            data_log = obj.data_logPrivate;
        end % End of get data_log
        
        % Get CalibrationRatio
        function CalibrationRatio = get.CalibrationRatio(obj)
            if isempty(obj.Calibration) % If no calibration
                CalibrationRatio = obj.CalibrationRatio;
            elseif isempty(obj.CalibrationRatio) % If no calibration ratio
                CalibrationRatio = zeros(numel(obj.Calibration),1);
                [m,idx] = max(vertcat(obj.Calibration.Date));
                if isempty(m) || isnat(m) % If no date use last entry
                    CalibrationRatio(end) = 1;
                else % Use most recent entry
                    CalibrationRatio(idx) = 1;
                end
            end
            
            if isvector(CalibrationRatio)
                %CalibrationRatio = repmat((CalibrationRatio(:))',numel(obj.Time),1);
                CalibrationRatio = determineRation(obj);
            end
                
        end % End of get CalibrationRatio
        
        % Get Red
        function Red = get.Red(obj)
            c = vertcat(obj.Calibration.Red);
            m = obj.CalibrationRatio;
            v = double(obj.RedCounts(:));
            Red = obj.applyCalibration(v,c,m);
        end % End of get Red
        
        % Get Green
        function Green = get.Green(obj)
            c = vertcat(obj.Calibration.Green);
            m = obj.CalibrationRatio;
            v = double(obj.GreenCounts(:));
            Green = obj.applyCalibration(v,c,m);
        end % End of get Green
        
        % Get Blue
        function Blue = get.Blue(obj)
            c = vertcat(obj.Calibration.Blue);
            m = obj.CalibrationRatio;
            v = double(obj.BlueCounts(:));
            Blue = obj.applyCalibration(v,c,m);
        end % End of get Blue
        
        % Get ActivityIndex
        function ActivityIndex = get.ActivityIndex(obj)
            % convert activity to rms g
            % raw activity is a mean squared value, 1 count = .0039 g's, and the 4 comes
            % from four right shifts in the source code
            ActivityIndex = (sqrt(double(obj.ActivityIndexCounts)))*.0039*4;
        end % End of get ActivityIndex
        
        % Get Observation
        function Observation = get.Observation(obj)
            if isempty(obj.Observation)
                Observation = true(size(obj.Time));
            else
                Observation = obj.Observation;
            end
        end % End of get Observation
        
        % Get Error
        function Error = get.Error(obj)
            if isempty(obj.Error)
                Error = false(size(obj.Time));
            else
                Error = obj.Error;
            end
        end % End of get Error
        
        % Get Illuminance
        function Illuminance = get.Illuminance(obj)
            Illuminance = obj.rgb2lux(obj.Red,obj.Green,obj.Blue);
        end % End of get Illuminance
        
        % Get CircadianLight
        function CircadianLight = get.CircadianLight(obj)
            CircadianLight = obj.rgb2cla(obj.Red,obj.Green,obj.Blue);
        end % End of get CircadianLight
        
        % Get CircadianStimulus
        function CircadianStimulus = get.CircadianStimulus(obj)
            CircadianStimulus = obj.cla2cs(obj.CircadianLight);
        end % End of get CircadianStimulus
    end
    
    % External public methods
    methods
        t = table(obj)
    end
    
    % External public static methods
    methods (Static)
        CalibratedValue = applyCalibration(Value,CalibrationArray,CalibrationRatio)
        Illuminance = rgb2lux(Red,Green,Blue)
        CircadianLight = rgb2cla(Red,Green,Blue)
        CircadianStimulus = cla2cs(CircadianLight)
    end
    
    % External protected methods
    methods (Access = protected)
        s = parseraw(obj,varargin)
        s = parseloginfo(obj,varargin)
        CalibrationRatio = determineRatio(obj)
    end
    
    % External static protected methods
    methods (Static, Access = protected)
        log_info = readloginfo(log_info_path)
        data_log = readdatalog(data_log_path)
    end
end

