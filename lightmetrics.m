classdef lightmetrics
    %LIGHTMETRICS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        illuminance
    end
    properties(Dependent)
        cla
        cs
        
        chromaticity
        cct
    end
    properties(Access=private)
        privateCla
        privateCs
        
        privateChromaticity
        privateCct
    end
    
    methods
        function obj = lightmetrics(varargin)
            % Parse the matched pair input.
            p = inputParser;
            defaultValue = [];
            % WARNING addParamValue is being depricated switch to
            % addParameter (supported in 2014a and newer) when nolonger
            % necessary to support older versions
            addParamValue(p,'illuminance',defaultValue,@isnumeric);
            addParamValue(p,'cla',defaultValue,@isnumeric);
            addParamValue(p,'cs',defaultValue,@isnumeric);
            addParamValue(p,'chromaticity',defaultValue);
            addParamValue(p,'cct',defaultValue,@isnumeric);
            parse(p,varargin{:});
            
            % Generate properties from parsed input.
            % If illuminance is given.
            if ~isempty(p.Results.illuminance)
                obj.illuminance = p.Results.illuminance;
            end
            
            % If cla and cs are given.
            if ~isempty(p.Results.cla) && ~isempty(p.Results.cs)
                obj.privateCla = p.Results.cla;
                obj.privateCs = p.Results.cs;
            % If cla and NOT cs are given.
            elseif ~isempty(p.Results.cla) && isempty(p.Results.cs)
                obj.cla = p.Results.cla;
            % If cs and NOT cla are given.
            elseif isempty(p.Results.cla) && ~isempty(p.Results.cs)
                obj.cs = p.Results.cs;
            end
            
            % If chromaticity and cct are given.
            if ~isempty(p.Results.chromaticity) && ~isempty(p.Results.cct)
                obj.privateChromaticity = p.Results.chromaticity;
                obj.privateCct = p.Results.cct;
            % If chromaticity and NOT cct are given.
            elseif ~isempty(p.Results.chromaticity) && isempty(p.Results.cct)
                obj.chromaticity = p.Results.chromaticity;
            % If cct and NOT chromaticity are given.
            elseif isempty(p.Results.chromaticity) && ~isempty(p.Results.cct)
                obj.cct = p.Results.cct;
            end
            
        end % End of function.
        
        % Get and set cla
        function cla = get.cla(obj)
            cla = obj.privateCla;
        end
        function obj = set.cla(obj,cla)
            obj.privateCla = cla;
            cs = lightcalc.cla2cs(cla);
            obj.privateCs = cs;
        end
        
        % Get and set cs
        function cs = get.cs(obj)
            cs = obj.privateCs;
        end
        function obj = set.cs(obj,cs)
            obj.privateCs = cs;
            % Set cla to be empty as it is no longer valid.
            obj.privateCla = [];
        end
        
        % Get and set chromaticity
        function chromaticity = get.chromaticity(obj)
            chromaticity = obj.privateChromaticity;
        end
        function obj = set.chromaticity(obj,chromaticity)
            obj.privateChromaticity = chromaticity;
            u = chromaticity.u;
            v = chromaticity.v;
            obj.privateCct = lightcalc.chrom2cct(u,v);
        end
        
        % Get and set cct
        function cct = get.cct(obj)
            cct = obj.privateCct;
        end
        function obj = set.cct(obj,cct)
            obj.privateCct = cct;
            % Set chromaticity to be empty as it is no longer valid.
            obj.privateChromaticity = [];
        end
        
    end % End of methods.
    
end

