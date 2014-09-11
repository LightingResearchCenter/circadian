classdef eventmasks
    %EVENTMASKS Logical arrays to mark certain events.
    %   All properties should be entered as logicals, those not entered as
    %   logicals will attempt to be converted using LOGICAL. Properties
    %   that are not supplied will be intiallized with an empty logical.
    %   The logical arrays should be the same size as the rest of your time
    %   series data.
    %
    % EVENTMASKS properties:
    %   observation	- Subject is under observation.
    %   compliance  - Subject complied with protocol.
    %   bed         - Subject reported as in bed attempting to sleep.
    %
    %	All properties are independent and modifying one will not change 
    %   the others.
    %
    % EXAMPLES:
    %   masks = eventmasks('observation',observationArray);
    %   masks = eventmasks('observation',observationArray,...
    %       'compliance',complianceArray,'bed',bedArray);
    %   bedArray = masks.bed;
    %
    % See also LOGICAL, DAYSIMETER12.CONVERTCDF.
    
    % Copyright 2014-2014 Rensselaer Polytechnic Institute
    
    
    properties(Dependent)
        observation
        compliance
        bed
    end
    properties(Access=private)
        privateObservation
        privateCompliance
        privateBed
    end
    
    methods
        function obj = eventmasks(varargin)
            % Parse the matched pair input.
            p = inputParser;
            defaultValue = logical([]);
            % WARNING addParamValue is being depricated switch to
            % addParameter (supported in 2014a and newer) when nolonger
            % necessary to support older versions
            addParamValue(p,'observation',defaultValue);
            addParamValue(p,'compliance',defaultValue);
            addParamValue(p,'bed',defaultValue);
            parse(p,varargin{:});
            
            % Generate properties from parsed input.
            obj.observation = p.Results.observation;
            obj.compliance = p.Results.compliance;
            obj.bed = p.Results.bed;
        end
        
        % Get and set observation.
        function observation = get.observation(obj)
            observation = obj.privateObservation;
        end
        function obj = set.observation(obj,observation)
            if ~islogical(observation)
                warning('Input for observation was not a logical array. It will be converted.');
                observation = logical(observation);
            end
            obj.privateObservation = observation;
        end
        
        % Get and set compliance.
        function compliance = get.compliance(obj)
            compliance = obj.privateCompliance;
        end
        function obj = set.compliance(obj,compliance)
            if ~islogical(compliance)
                warning('Input for compliance was not a logical array. It will be converted.');
                compliance = logical(compliance);
            end
            obj.privateCompliance = compliance;
        end
        
        % Get and set bed.
        function bed = get.bed(obj)
            bed = obj.privateBed;
        end
        function obj = set.bed(obj,bed)
            if ~islogical(bed)
                warning('Input for bed was not a logical array. It will be converted.');
                bed = logical(bed);
            end
            obj.privateBed = bed;
        end
        
    end
    
end

