classdef absolutetime
    %ABSOLUTETIME Stores absolute local and UTC time in several formats.
    %   All time formats are first converted to the CDF Epoch format
    %   (milliseconds from midnight January 1, 0000 CE) the time is rounded
    %   to the nearest seconds and then converted to all other formats.
    %
    %   Time formats:
    %   cdfepoch	- milliseconds from midnight January 1, 0000 CE
    %   datevec     - Gregorian date vector [Y,MO,D,H,MI,S]
    %   datenum     - days since January 0, 0000 CE
    %   excel       - days since January 0, 1900 CE
    %   labview     - seconds since January 1, 1904 CE
    %
    %   Contructor syntax:
    %   obj = absolutetime(time,timeType,utc,offset,offsetUnit);
    %   time        - vertical array of an accepted time type
    %   timeType	- 'cdfepoch','datevec','datenum','excel','labview'
    %   utc         - true (in UTC) or false (in local time)
    %   offset      - offset of local time from UTC
    %   offsetUnit	- 'hours','minutes','seconds','milliseconds'
    %
    % ABSOLUTETIME Properties:
    %	offset          - a utcoffset object
    %	utcCdfEpoch     - UTC time in CDF Epoch
    %	utcDateVec      - UTC time in MATLAB datevec
    %	utcDateNum      - UTC time in MATLAB datenum
    %	utcExcel        - UTC time in MS Excel serial date
    %	utcLabview      - UTC time in LabVIEW timestamp
    %	localCdfEpoch   - Local time in CDF Epoch
    %	localDateVec    - Local time in MATLAB datevec
    %	localDateNum    - Local time in MATLAB datenum
    %	localExcel      - Local time in MS Excel serial date
    %	localLabview    - Local time in LabVIEW timestamp
    %	
    %   Modifying any of the time properties will update all the other time
    %   properties. Modifying any of the UTC offsets will update the local
    %   time properties.
    %
    % EXAMPLES:
    %	absTime = absolutetime(time,'datenum',false,-5,'hours');
    %	absTime.offset.hours = utcoffset(-4,'hours');
    %	localCdfEpoch = absTime.localCdfEpoch;
    %
    % See also UTCOFFSET, CDFLIB, DATEVEC, DATENUM.
    
    % Copyright 2014-2014 Rensselaer Polytechnic Institute
    
    properties(Dependent)
        offset
        
        utcCdfEpoch
        utcDateVec
        utcDateNum
        utcExcel
        utcLabview
        
        localCdfEpoch
        localDateVec
        localDateNum
        localExcel
        localLabview
    end
    properties(Access=private)
        privateOffset
        privateConstantOffset
        
        privateUtcCdfEpoch
        privateUtcDateVec
        privateUtcDateNum
        privateUtcExcel
        privateUtcLabview
        
        privateLocalCdfEpoch
        privateLocalDateVec
        privateLocalDateNum
        privateLocalExcel
        privateLocalLabview
    end
    
    methods
        % Object creation
        function obj = absolutetime(time,timeType,utc,offset,offsetUnit)
        %ABSOLUTETIME Construct absolutetime object.
        %   Constructor syntax:
        %   obj = absolutetime(time,timeType,utc,offset,offsetUnit)
        %   time        - vertical array of an accepted time type
        %   timeType	- 'cdfepoch','datevec','datenum','excel','labview'
        %   utc         - true (in UTC) or false (in local time)
        %   offset      - offset of local time from UTC
        %   offsetUnit	- 'hours','minutes','seconds','milliseconds'
            
            
            % Determine if offset is constant.
            if (numel(offset) == 1)
                nTime = size(time,1);
                offset = repmat(offset,nTime,1);
            end
            % Set offset
            obj.offset = utcoffset(offset,offsetUnit);
            
            timeType = lower(timeType);
            switch timeType
                case 'cdfepoch'
                    if utc
                        obj.utcCdfEpoch = time;
                    else
                        obj.localCdfEpoch = time;
                    end
                case 'datevec'
                    if utc
                        obj.utcDateVec = time;
                    else
                        obj.localDateVec = time;
                    end
                case 'datenum'
                    if utc
                        obj.utcDateNum = time;
                    else
                        obj.localDateNum = time;
                    end
                case 'excel'
                    if utc
                        obj.utcExcel = time;
                    else
                        obj.localExcel = time;
                    end
                case 'labview'
                    if utc
                        obj.utcLabview = time;
                    else
                        obj.localLabview = time;
                    end
                otherwise
                    error('Unknown timeType');
            end % End of switch
        end % End of function
        
        % Get and set offset
        function offset = get.offset(obj)
            if obj.privateConstantOffset
                offsetMs = obj.privateOffset.milliseconds(1);
                offset = utcoffset(offsetMs,'milliseconds');
            else
                offset = obj.privateOffset;
            end
        end
        function obj = set.offset(obj,offset)
            offsetMs = offset.milliseconds;
            
            if (numel(offsetMs) == 1)
                if ~isempty(obj.privateUtcCdfEpoch)
                    [mTime,nTime] = size(obj.privateUtcCdfEpoch);
                    offsetMs = repmat(offsetMs,mTime,nTime);
                end
                obj.privateConstantOffset = true;
            else
                diffOffset = offsetMs - offsetMs(1);
                if any(diffOffset)
                    obj.privateConstantOffset = false;
                else
                    obj.privateConstantOffset = true;
                end
            end
            
            obj.privateOffset = utcoffset(offsetMs,'milliseconds');
            
            % Update the local time if utcCdfEpoch exists
            if ~isempty(obj.utcCdfEpoch)
                obj.localCdfEpoch = obj.utcCdfEpoch + offsetMs;
            end
        end
        
        % Get and set utcCdfEpoch
        function time = get.utcCdfEpoch(obj)
            time = obj.privateUtcCdfEpoch;
        end
        function obj = set.utcCdfEpoch(obj,time)
            % Round time to the nearest second
            utcCdf   = round(time/1000)*1000;
            localCdf = utcCdf + obj.offset.milliseconds;
            
            utcTimeVec   = (cdflib.epochBreakdown(utcCdf))';
            localTimeVec = (cdflib.epochBreakdown(localCdf))';
            
            utcDateVec   = utcTimeVec(:,1:6);
            localDateVec = localTimeVec(:,1:6);
            
            utcDateNum   = datenum(utcDateVec);
            localDateNum = datenum(localDateVec);
            
            utcExcel = datenum2excel(utcDateNum);
            localExcel = datenum2excel(localDateNum);
            
            utcLabview = cdfepoch2labview(utcCdf);
            localLabview = cdfepoch2labview(localCdf);
            
            obj.privateUtcCdfEpoch = utcCdf;
            obj.privateUtcDateVec  = utcDateVec;
            obj.privateUtcDateNum  = utcDateNum;
            obj.privateUtcExcel    = utcExcel;
            obj.privateUtcLabview  = utcLabview;
            
            obj.privateLocalCdfEpoch = localCdf;
            obj.privateLocalDateVec  = localDateVec;
            obj.privateLocalDateNum  = localDateNum;
            obj.privateLocalExcel    = localExcel;
            obj.privateLocalLabview  = localLabview;
        end
        
        % Get and set localCdfEpoch
        function time = get.localCdfEpoch(obj)
            time = obj.privateLocalCdfEpoch;
        end
        function obj = set.localCdfEpoch(obj,time)
            % Round time to the nearest second
            localCdf   = round(time/1000)*1000;
            utcCdf = localCdf - obj.offset.milliseconds;
            
            utcTimeVec   = (cdflib.epochBreakdown(utcCdf))';
            localTimeVec = (cdflib.epochBreakdown(localCdf))';
            
            utcDateVec   = utcTimeVec(:,1:6);
            localDateVec = localTimeVec(:,1:6);
            
            utcDateNum   = datenum(utcDateVec);
            localDateNum = datenum(localDateVec);
            
            utcExcel = datenum2excel(utcDateNum);
            localExcel = datenum2excel(localDateNum);
            
            utcLabview = cdfepoch2labview(utcCdf);
            localLabview = cdfepoch2labview(localCdf);
            
            obj.privateUtcCdfEpoch = utcCdf;
            obj.privateUtcDateVec  = utcDateVec;
            obj.privateUtcDateNum  = utcDateNum;
            obj.privateUtcExcel    = utcExcel;
            obj.privateUtcLabview  = utcLabview;
            
            obj.privateLocalCdfEpoch = localCdf;
            obj.privateLocalDateVec  = localDateVec;
            obj.privateLocalDateNum  = localDateNum;
            obj.privateLocalExcel    = localExcel;
            obj.privateLocalLabview  = localLabview;
        end
        
        % Get and set utcDateVec
        function time = get.utcDateVec(obj)
            time = obj.privateUtcDateVec;
        end
        function obj = set.utcDateVec(obj,time)
            nTime = size(time,1);
            dateVec = time;
            timeVec = [dateVec,zeros(nTime,1)];
            % Extract milliseconds from fractional seconds
            timeVec(:,7) = (timeVec(:,6) - floor(timeVec(:,6)))*1000;
            timeVec(:,6) = floor(timeVec(:,6));
            cdfEpoch = (cdflib.computeEpoch(timeVec'))';
            
            obj.utcCdfEpoch = cdfEpoch;
        end
        
        % Get and set localDateVec
        function time = get.localDateVec(obj)
            time = obj.privateLocalDateVec;
        end
        function obj = set.localDateVec(obj,time)
            nTime = size(time,1);
            dateVec = time;
            timeVec = [dateVec,zeros(nTime,1)];
            % Extract milliseconds from fractional seconds
            timeVec(:,7) = (timeVec(:,6) - floor(timeVec(:,6)))*1000;
            timeVec(:,6) = floor(timeVec(:,6));
            cdfEpoch = (cdflib.computeEpoch(timeVec'))';
            
            obj.localCdfEpoch = cdfEpoch;
        end
        
        % Get and set utcDateNum
        function time = get.utcDateNum(obj)
            time = obj.privateUtcDateNum;
        end
        function obj = set.utcDateNum(obj,time)
            nTime = numel(time);
            dateNum = time;
            dateVec = datevec(dateNum);
            timeVec = [dateVec,zeros(nTime,1)];
            % Extract milliseconds from fractional seconds
            timeVec(:,7) = (timeVec(:,6) - floor(timeVec(:,6)))*1000;
            timeVec(:,6) = floor(timeVec(:,6));
            cdfEpoch = (cdflib.computeEpoch(timeVec'))';
            
            obj.utcCdfEpoch = cdfEpoch;
        end
        
        % Get and set localDateNum
        function time = get.localDateNum(obj)
            time = obj.privateLocalDateNum;
        end
        function obj = set.localDateNum(obj,time)
            nTime = numel(time);
            dateNum = time;
            dateVec = datevec(dateNum);
            timeVec = [dateVec,zeros(nTime,1)];
            % Extract milliseconds from fractional seconds
            timeVec(:,7) = (timeVec(:,6) - floor(timeVec(:,6)))*1000;
            timeVec(:,6) = floor(timeVec(:,6));
            cdfEpoch = (cdflib.computeEpoch(timeVec'))';
            
            obj.localCdfEpoch = cdfEpoch;
        end
        
        % Get and set utcExcel
        function time = get.utcExcel(obj)
            time = obj.privateUtcExcel;
        end
        function obj = set.utcExcel(obj,time)
            nTime = numel(time);
            excel = time;
            dateNum = excel2datenum(excel);
            dateVec = datevec(dateNum);
            timeVec = [dateVec,zeros(nTime,1)];
            % Extract milliseconds from fractional seconds
            timeVec(:,7) = (timeVec(:,6) - floor(timeVec(:,6)))*1000;
            timeVec(:,6) = floor(timeVec(:,6));
            cdfEpoch = (cdflib.computeEpoch(timeVec'))';
            
            obj.utcCdfEpoch = cdfEpoch;
        end
        
        % Get and set localExcel
        function time = get.localExcel(obj)
            time = obj.privateLocalExcel;
        end
        function obj = set.localExcel(obj,time)
            nTime = numel(time);
            excel = time;
            dateNum = excel2datenum(excel);
            dateVec = datevec(dateNum);
            timeVec = [dateVec,zeros(nTime,1)];
            % Extract milliseconds from fractional seconds
            timeVec(:,7) = (timeVec(:,6) - floor(timeVec(:,6)))*1000;
            timeVec(:,6) = floor(timeVec(:,6));
            cdfEpoch = (cdflib.computeEpoch(timeVec'))';
            
            obj.localCdfEpoch = cdfEpoch;
        end
        
        % Get and set utcExcel
        function time = get.utcLabview(obj)
            time = obj.privateUtcLabview;
        end
        function obj = set.utcLabview(obj,time)
            labview = time;
            cdfEpoch = labview2cdfepoch(labview);
            
            obj.utcCdfEpoch = cdfEpoch;
        end
        
        % Get and set localExcel
        function time = get.localLabview(obj)
            time = obj.privateLocalLabview;
        end
        function obj = set.localLabview(obj,time)
            labview = time;
            cdfEpoch = labview2cdfepoch(labview);
            
            obj.localCdfEpoch = cdfEpoch;
        end
        
    end % End of methods.
    
end % End of classdef.


function labviewTime = cdfepoch2labview(cdfTime)
%CDFEPOCH2LABVIEW Summary of this function goes here
%   Detailed explanation goes here

labviewPivot = cdflib.computeEpoch([1904,1,1,0,0,0,0]');
labviewTime = (cdfTime - labviewPivot)/1000; 

end


function cdfTime = labview2cdfepoch(labviewTime)
%LABVIEW2CDFEPOCH Summary of this function goes here
%   Detailed explanation goes here

labviewPivot = cdflib.computeEpoch([1904,1,1,0,0,0,0]');
cdfTime = labviewTime*1000 + labviewPivot;

end


function excelTime = datenum2excel(datenumTime)
%DATENUM2EXCEL Summary of this function goes here
%   Detailed explanation goes here

excelPivot = 693960;
excelTime = datenumTime - excelPivot;

end


function datenumTime = excel2datenum(excelTime)
%EXCEL2DATENUM Summary of this function goes here
%   Detailed explanation goes here

excelPivot = 693960;
datenumTime = excelTime + excelPivot;

end