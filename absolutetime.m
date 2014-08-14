classdef absolutetime
    %ABSOLUTETIME Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Constant)
    end
    properties
    end
    properties(Dependent)
        localDateNum
        localDateVec
        localDateTime
        localCdfEpoch
        localExcelDate
        localLabviewDate
        
        utcDateNum
        utcDateVec
        utcDateTime
        utcCdfEpoch
    end
    properties(Access=private)
        privateDateNum
        privateDateVec
        privateDateTime
        privateCdfEpoch
    end
    
    methods
        % Object creation
        function obj = AbsoluteTime(timeArray,timeType)
            timeType = lower(timeType);
            switch timeType
                case 'datenum'
                    obj.DateNum = timeArray;
                    obj.DateVec = datevec(timeArray);
                case 'datevec'
                    obj.DateVec = timeArray;
                    obj.DateNum = datenum(timeArray);
                case 'datetime'
                    obj.DateTime = timeArray;
                case 'cdfepoch'
                    obj.CdfEpoch = timeArray;
                otherwise
                    error('Unknown timeType');
            end % End of switch
        end % End of function
        
        % DateNum get and set
        function datenumArray = get.DateNum(obj)
            datenumArray = obj.privateDateNum;
        end
        function obj = set.DateNum(obj,datenumArray)
            obj.privateDateNum = datenumArray;
            obj.privateDateVec = datevec(datenumArray);
        end
        
        % DateVec get and set
        function datevecArray = get.DateVec(obj)
            datevecArray = obj.privateDateVec;
        end
        function obj = set.DateVec(obj,datevecArray)
            obj.privateDateVec = datevecArray;
            obj.privateDateNum = datenum(datevecArray);
        end
    end
    
end

