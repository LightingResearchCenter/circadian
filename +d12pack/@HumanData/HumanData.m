classdef HumanData < d12pack.MobileData
    %HUMANDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Compliance logical
        BedLog     d12pack.BedLogData
        WorkLog    d12pack.WorkLogData
    end
    
    properties (Dependent)
        Sleep            struct
        
        AtWork           logical
        InBed            logical
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
            if ~isempty(obj.BedLog)
                Temp = false(size(obj.Time));
                for iBed = 1:numel(obj.BedLog)
                    if (isdatetime(obj.BedLog(iBed).BedTime) && ~isnat(obj.BedLog(iBed).BedTime)) && (isdatetime(obj.BedLog(iBed).RiseTime) && ~isnat(obj.BedLog(iBed).RiseTime))
                        Temp = Temp | (obj.Time >= obj.BedLog(iBed).BedTime & obj.Time < obj.BedLog(iBed).RiseTime);
                    end
                end
                InBed = Temp;
            else
                InBed = logical.empty(numel(obj.Time),0);
            end
        end % End of get InBed method
        
        % Get AtWork
        function AtWork = get.AtWork(obj)
            if ~isempty(obj.WorkLog)
                Temp = false(size(obj.Time));
                for iBed = 1:numel(obj.WorkLog)
                    if (isdatetime(obj.WorkLog(iBed).StartTime) && ~isnat(obj.WorkLog(iBed).StartTime)) && (isdatetime(obj.WorkLog(iBed).EndTime) && ~isnat(obj.WorkLog(iBed).EndTime))
                        Temp = Temp | (obj.Time >= obj.WorkLog(iBed).StartTime & obj.Time < obj.WorkLog(iBed).RiseTime);
                    end
                end
                AtWork = Temp;
            else
                AtWork = logical.empty(numel(obj.Time),0);
            end
        end % End of get InBed method
    end
    
    % External static protected methods
    methods (Static, Access = protected)
        PhasorCompliance = adjustcompliance(Epoch,Time,Compliance,varargin)
    end
end

