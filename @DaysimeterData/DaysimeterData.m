classdef DaysimeterData
    %DAYSIMETERDATA Stores data collected by a Daysimeter
    %   Provides processed calibrated data and analysis on demand.
    %   Preferred class construction method is to provide binary files.
   
    % Public properties 
    properties
        log_info        char	%
        data_log        uint16	%
        SerialNumber	uint16	%
        Calibration     table	%
        Subject
    end
    
    % Dependent properties
    properties (Dependent)
        
    end
    
    % Internal methods
    methods
        % Class constructor
        function obj = DaysimeterData(log_info_path,data_log_path,varargin)
            if nargin > 0
                
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
    end
end

