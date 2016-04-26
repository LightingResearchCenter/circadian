classdef HumanData < d12pack.MobileData
    %HUMANDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        BedTimes datetime
        RiseTimes datetime
        Compliance logical
    end
    
    properties (Dependent)
        Sleep   struct
        InBed   logical
        PhasorCompliance logical
    end
    
    % Internal public methods
    methods
        % Class constructor
        function obj = HumanData(log_info_path,data_log_path,varargin)
            obj@d12pack.MobileData;
            if nargin > 0
                obj.log_info = obj.readloginfo(log_info_path);
                obj.data_log = obj.readdatalog(data_log_path);
            end
        end % End of constructor method
        
        % Get Compliance
        function Compliance = get.Compliance(obj)
            if isempty(obj.Compliance)
                Compliance = true(size(obj.Time));
            else
                Compliance = obj.Compliance;
            end
        end
        
        % Get PhasorCompliance
        function PhasorCompliance = get.PhasorCompliance(obj)
            if isempty(obj.InBed)
                PhasorCompliance = obj.adjustcompliance(obj.Epoch,obj.Time,obj.Compliance);
            else
                PhasorCompliance = obj.adjustcompliance(obj.Epoch,obj.Time,obj.Compliance,obj.InBed);
            end
        end % End of get PhasorCompliance
        
        % Get InBed
        function InBed = get.InBed(obj)
            if ~isempty(obj.BedTimes) && ~isempty(obj.RiseTimes)
                Temp = false(size(obj.Time));
                for iBed = 1:numel(obj.BedTimes)
                    Temp = Temp | (obj.Time >= obj.BedTimes(iBed) & obj.Time < obj.RiseTimes(iBed));
                end
                InBed = Temp;
            else
                InBed = logical.empty(numel(obj.Time),0);
            end
        end % End of get InBed method
    end
    
    % External static protected methods
    methods (Static, Access = protected)
        PhasorCompliance = adjustcompliance(Epoch,Time,Compliance,varargin)
    end
end

