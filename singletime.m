classdef singletime
    %SINGLETIME Represents a single date and time in several formats
    %   Detailed explanation goes here
    
    properties(Dependent)
        dateNum
        dateVec
        cdfEpoch
    end
    properties(Access=private)
        privateDateNum
        privateDateVec
        privateCdfEpoch
    end
    
    methods
        % Object creation
        function obj = singletime(time,timeType)
            timeType = lower(timeType);
            switch timeType
                case 'datenum'
                    obj.dateNum = time;
                case 'datevec'
                    obj.dateVec = time;
                case 'cdfepoch'
                    obj.cdfEpoch = time;
                otherwise
                    error('Unknown timeType');
            end % End of switch
        end % End of function
        
        % Get and set dateNum.
        function datenumArray = get.dateNum(obj)
            datenumArray = obj.privateDateNum;
        end
        function obj = set.dateNum(obj,time)
            dateNum = time;
            dateVec = datevec(dateNum);
            % Round to the nearest second
            dateVec(6) = round(dateVec(6));
            dateNum = datenum(dateVec);
            timeVec = [dateVec,0];
            cdfEpoch = cdflib.computeEpoch(timeVec);
            
            obj.privateDateNum = dateNum;
            obj.privateDateVec = dateVec;
            obj.privateCdfEpoch = cdfEpoch;
        end
        
        % Get and set dateVec.
        function datevecArray = get.dateVec(obj)
            datevecArray = obj.privateDateVec;
        end
        function obj = set.dateVec(obj,time)
            dateVec = time;
            % Round to the nearest second
            dateVec(6) = round(dateVec(6));
            dateNum = datenum(dateVec);
            timeVec = [dateVec,0];
            cdfEpoch = cdflib.computeEpoch(timeVec);
            
            obj.privateDateNum = dateNum;
            obj.privateDateVec = dateVec;
            obj.privateCdfEpoch = cdfEpoch;
        end
        
        % Get and set cdfEpoch.
        function datevecArray = get.cdfEpoch(obj)
            datevecArray = obj.privateCdfEpoch;
        end
        function obj = set.cdfEpoch(obj,time)
            cdfEpoch = time;
            % Round to nearest second
            cdfEpoch = round(cdfEpoch*1000)/1000;
            timeVec = cdflib.epochBreakdown(cdfEpoch);
            dateVec = timeVec(1:6);
            dateNum = datenum(dateVec);
            
            obj.privateDateNum = dateNum;
            obj.privateDateVec = dateVec;
            obj.privateCdfEpoch = cdfEpoch;
        end
    end
    
end

