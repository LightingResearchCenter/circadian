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
    
    methods
        
        % Get PhasorCompliance
        function PhasorCompliance = get.PhasorCompliance(obj)
            PhasorCompliance = obj.adjustcompliance(obj.Epoch,obj.Time,obj.Compliance);
        end % End of get PhasorCompliance
        
        % Get Phasor
        function Phasor = get.Phasor(obj)
            
        end % End of get Phasor
    end
    
    methods (Access = protected)
        PhasorCompliance = adjustcompliance(Epoch,Time,Compliance,InBed)
    end
end

