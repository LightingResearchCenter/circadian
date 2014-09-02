classdef chromcoord
    %CHROMCOORD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x
        y
        z
    end
    
    methods
        function obj = chromcoord(varargin)
            % Parse the matched pair input.
            p = inputParser;
            defaultValue = [];
            % WARNING addParamValue is being depricated switch to
            % addParameter (supported in 2014a and newer) when nolonger
            % necessary to support older versions
            addParamValue(p,'x',defaultValue);
            addParamValue(p,'y',defaultValue);
            addParamValue(p,'z',defaultValue);
            parse(p,varargin{:});
            
            % Generate properties from parsed input.
            obj.x = p.Results.x;
            obj.y = p.Results.y;
            obj.z = p.Results.z;
        end
    end
    
end

