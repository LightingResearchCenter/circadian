classdef DaysimeterData
    %DAYSIMETERDATA Stores data collected by a Daysimeter
    %   Provides processed calibrated data and analysis on demand.
    %   Preferred class construction method is to provide binary files.
    
    % Public properties
    properties
        SerialNumber uint16   % Daysimeter serial number
        Calibration  d12pack.CalibrationData % Calibration values
        CalibrationRatio double % Ratio used when mixing multiple calibration
        Epoch        duration % Logging rate
        
        Time         datetime % Time stamps of readings
        RedCounts    uint16   % Uncalibrated counts from red channel
        GreenCounts  uint16   % Uncalibrated counts from green channel
        BlueCounts   uint16   % Uncalibrated counts from blue channel
        ActivityIndexCounts uint16   % Unconverted counts from activity index
        
        Observation  logical  % True if reading is during observation period
        Error        logical  % True if reading is in error
        Resets       uint16   % Running count of reset flags
        
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
        Red           double % Calibrated red channel readings
        Green         double % Calibrated green channel readings
        Blue          double % Calibrate blue channel readings
        ActivityIndex double % Converted activity index
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
            end
        end % End of set data_log
        % Get data_log
        function data_log = get.data_log(obj)
            data_log = obj.data_logPrivate;
        end % End of get data_log
        
    end
    
    % External public methods
    methods
        t = table(obj)
    end
    
    % External protected methods
    methods (Access = protected)
        s = parseraw(obj,varargin)
        s = parseloginfo(obj,varargin)
    end
    
    % External static private methods
    methods (Static, Access = private)
        
    end
    
    % External static protected methods
    methods (Static, Access = protected)
        log_info = readloginfo(log_info_path)
        data_log = readdatalog(data_log_path)
    end
end

