classdef chromcoord
    %CHROMCOORD Stores chromaticity coordinates in CIE 1931, 1960, and 1976
    %   Store and convert between CIE chromaticity coordinate systems
    %
    % CHROMCOORD properties:
    %   x       - CIE 1931 x coordinate
    %   y       - CIE 1931 y coordinate
    %   z       - CIE 1931 z coordinate
    %   u       - CIE 1960 u coordinate
    %   v       - CIE 1960 v coordinate
    %   uPrime  - CIE 1976 u' coordinate
    %   vPrime  - CIE 1976 v' coordinate
    %
    %   All properties are dependent and modifying one coordinate system 
    %   will update the others. Since z cannot be calculated from (u,v) or 
    %   from (u',v') it is cleared out when either the 1960 or 1976 system
    %   is modified.
    %
    % EXAMPLES:
    %   chromaticity = chromcoord('x',xArray,'y',yArray,'z',zArray);
    %   uArray = chromaticity.u;
    %   chromaticity.vPrime = vPrimeArray;
    %
    % See also LIGHTCALC.CIE31TO60, LIGHTCALC.CIE31TO76,
    %   LIGHTCALC.CIE60TO31, LIGHTCALC.CIE60TO76, LIGHTCALC.CIE76TO31,
    %   LIGHTCALC.CIE76TO60.
    
    % Copyright 2014-2014 Rensselaer Polytechnic Institute
    
    properties(Dependent)
        x
        y
        z
        
        u
        v
        
        uPrime
        vPrime
    end
    properties(Access=private)
        privateX
        privateY
        privateZ
        
        privateU
        privateV
        
        privateUprime
        privateVprime
    end
    
    methods
        function obj = chromcoord(varargin)
        %CHROMCOORD Construct CHROMCOORD object
        %
            
            % Parse the matched pair input.
            p = inputParser;
            defaultValue = [];
            addParameter(p,'x',defaultValue,@isnumeric);
            addParameter(p,'y',defaultValue,@isnumeric);
            addParameter(p,'z',defaultValue,@isnumeric);
            addParameter(p,'u',defaultValue,@isnumeric);
            addParameter(p,'v',defaultValue,@isnumeric);
            addParameter(p,'uPrime',defaultValue,@isnumeric);
            addParameter(p,'vPrime',defaultValue,@isnumeric);
            parse(p,varargin{:});
            
            % Determine what coordinate system was given.
            % CIE 1931 (x, y, and/or z)
            if ~isempty(p.Results.x) && ~isempty(p.Results.y)
                x = p.Results.x;
                y = p.Results.y;
                z = p.Results.z;
                
                [u,v] = lightcalc.cie31to60(x,y);
                [uPrime,vPrime] = lightcalc.cie31to76(x,y);
            % CIE 1960 (u, v)
            elseif ~isempty(p.Results.u) && ~isempty(p.Results.v)
                u = p.Results.u;
                v = p.Results.v;
                
                [x,y] = lightcalc.cie60to31(u,v);
                z = [];
                [uPrime,vPrime] = lightcalc.cie60to76(u,v);
            % CIE 1976 (uPrime, vPrime)
            elseif ~isempty(p.Results.uPrime) && ~isempty(p.Results.vPrime)
                uPrime = p.Results.uPrime;
                vPrime = p.Results.vPrime;
                
                [x,y] = lightcalc.cie76to31(uPrime,vPrime);
                z = [];
                [u,v] = lightcalc.cie76to60(uPrime,vPrime);
            else
                error('Unknown or incomplete chromaticity coordinate system.');
            end
            % Generate properties from parsed input.
            obj.privateX = x;
            obj.privateY = y;
            obj.privateZ = z;
            obj.privateU = u;
            obj.privateV = v;
            obj.privateUprime = uPrime;
            obj.privateVprime = vPrime;
        end
        
        % CIE 1931 Chromaticity Coordinates
        % Get and set x.
        function x = get.x(obj)
            x = obj.privateX;
        end
        function obj = set.x(obj,x)
            obj.privateX = x;
            
            y = obj.privateY;
            [u,v] = lightcalc.cie31to60(x,y);
            [uPrime,vPrime] = lightcalc.cie31to76(x,y);
            
            obj.privateU = u;
            obj.privateV = v;
            obj.privateUprime = uPrime;
            obj.privateVprime = vPrime;
        end
        % Get and set y.
        function y = get.y(obj)
            y = obj.privateY;
        end
        function obj = set.y(obj,y)
            obj.privateY = y;
            
            x = obj.privateX;
            [u,v] = lightcalc.cie31to60(x,y);
            [uPrime,vPrime] = lightcalc.cie31to76(x,y);
            
            obj.privateU = u;
            obj.privateV = v;
            obj.privateUprime = uPrime;
            obj.privateVprime = vPrime;
        end
        % Get and set z.
        function z = get.z(obj)
            z = obj.privateZ;
        end
        function obj = set.z(obj,z)
            obj.privateZ = z;
        end
        
        % CIE 1960 Chromaticity Coordinates
        % Get and set u.
        function u = get.u(obj)
            u = obj.privateU;
        end
        function obj = set.u(obj,u)
            obj.privateU = u;
            
            v = obj.privateV;
            [x,y] = lightcalc.cie60to31(u,v);
            [uPrime,vPrime] = lightcalc.cie60to76(u,v);
            
            obj.privateX = x;
            obj.privateY = y;
            obj.privateUprime = uPrime;
            obj.privateVprime = vPrime;
        end
        % Get and set v.
        function v = get.v(obj)
            v = obj.privateV;
        end
        function obj = set.v(obj,v)
            obj.privateV = v;
            
            u = obj.privateU;
            [x,y] = lightcalc.cie60to31(u,v);
            [uPrime,vPrime] = lightcalc.cie60to76(u,v);
            
            obj.privateX = x;
            obj.privateY = y;
            obj.privateUprime = uPrime;
            obj.privateVprime = vPrime;
        end
        
        % CIE 1976 Chromaticity Coordinates
        % Get and set uPrime.
        function uPrime = get.uPrime(obj)
            uPrime = obj.privateUprime;
        end
        function obj = set.uPrime(obj,uPrime)
            obj.privateUprime = uPrime;
            
            vPrime = obj.privateVprime;
            [x,y] = lightcalc.cie76to31(uPrime,vPrime);
            [u,v] = lightcalc.cie76to60(uPrime,vPrime);
            
            obj.privateX = x;
            obj.privateY = y;
            obj.privateU = u;
            obj.privateV = v;
        end
        % Get and set vPrime.
        function vPrime = get.vPrime(obj)
            vPrime = obj.privateVprime;
        end
        function obj = set.vPrime(obj,vPrime)
            obj.privateVprime = vPrime;
            
            vPrime = obj.privateVprime;
            [x,y] = lightcalc.cie76to31(uPrime,vPrime);
            [u,v] = lightcalc.cie76to60(uPrime,vPrime);
            
            obj.privateX = x;
            obj.privateY = y;
            obj.privateU = u;
            obj.privateV = v;
        end
        
    end
    
end

