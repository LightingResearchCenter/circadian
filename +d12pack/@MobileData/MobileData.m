classdef MobileData < d12pack.DaysimeterData
    %MOBILEDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ID  char
    end
    
    properties (Dependent)
        Phasor struct
        InterdailyStability     double
        IntradailyVariability   double
    end
    
    methods
        % Constructor method
        function obj = MobileData(log_info_path,data_log_path,varargin)
            obj@d12pack.DaysimeterData;
            if nargin > 0
                obj.log_info = obj.readloginfo(log_info_path);
                obj.data_log = obj.readdatalog(data_log_path);
            end
        end % End of constructor method
        
        % Get Phasor method
        function Phasor = get.Phasor(obj)
            if isprop(obj,'InBed') && isprop(obj,'PhasorCompliance')
                Phasor = obj.computePhasor(obj.Time,obj.CircadianStimulus,obj.Epoch,obj.ActivityIndex,obj.Observation,obj.PhasorCompliance,obj.InBed);
            elseif isprop(obj,'PhasorCompliance')
                Phasor = obj.computePhasor(obj.Time,obj.CircadianStimulus,obj.Epoch,obj.ActivityIndex,obj.Observation,obj.PhasorCompliance);
            else
                Phasor = obj.computePhasor(obj.Time,obj.CircadianStimulus,obj.Epoch,obj.ActivityIndex,obj.Observation);
            end
        end % End of get Phasor method
    end
    
    methods (Static, Access = protected)
        Phasor = computePhasor(Time,CS,Epoch,ActivityIndex,Observation,varargin)
    end
end

