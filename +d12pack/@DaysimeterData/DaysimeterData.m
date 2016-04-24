classdef DaysimeterData
    %DAYSIMETERDATA Stores data collected by a Daysimeter
    %   Provides processed calibrated data and analysis on demand.
    %   Preferred class construction method is to provide binary files.
   
    % Public properties 
    properties
        log_info        char        % Unprocessed "log_info.txt" file data
        data_log        uint16      % Unprocessed "data_log.txt" file data
        SerialNumber	uint16      % Daysimeter serial number
        Calibration     table       % Calibration values (red,green,blue,date,label)
        Subject         struct      % Subject metadata
        Location        struct      % Location metadata
        Created         datetime    % When the original files were downloaded
        Modified        datetime    % When this object was last saved
    end
    
    % Dependent properties
    properties (Dependent)
        
    end
    
    % Internal methods
    methods
        % Class constructor
        function obj = DaysimeterData(log_info_path,data_log_path,varargin)
            if nargin > 0
                obj.log_info = obj.readloginfo(log_info_path);
                obj.data_log = obj.readdatalog(data_log_path);
            end
        end % End of class constructor method
        
    end
    
    % External private methods
    methods (Access = private)
        s = saveobj(obj)
    end
    
    % External static private methods
    methods (Static, Access = private)
        obj = loadobj(s)
        log_info = readloginfo(log_info_path)
        data_log = readdatalog(data_log_path)
    end
end

