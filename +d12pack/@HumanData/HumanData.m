classdef HumanData < d12pack.MobileData
    %HUMANDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Compliance logical
        BedLog     d12pack.BedLogData
        WorkLog    d12pack.WorkLogData
    end
    %%
    properties (Dependent)
        Sleep            struct
        
        AtWork           logical
        InBed            logical
        PhasorCompliance logical
        PostWork         logical
        PreWork          logical
        
        WakingCoverage                    duration
        MeanWakingActivityIndex           double
        MeanWakingIlluminance             double
        MeanWakingCircadianLight          double
        MeanWakingCircadianStimulus       double
        GeometricMeanWakingIlluminance    double
        GeometricMeanWakingCircadianLight double
        
        AtWorkCoverage                    duration
        MeanAtWorkActivityIndex           double
        MeanAtWorkIlluminance             double
        MeanAtWorkCircadianLight          double
        MeanAtWorkCircadianStimulus       double
        GeometricMeanAtWorkIlluminance    double
        GeometricMeanAtWorkCircadianLight double
        
        PreWorkCoverage                    duration
        MeanPreWorkActivityIndex           double
        MeanPreWorkIlluminance             double
        MeanPreWorkCircadianLight          double
        MeanPreWorkCircadianStimulus       double
        GeometricMeanPreWorkIlluminance    double
        GeometricMeanPreWorkCircadianLight double
        
        PostWorkCoverage                    duration
        MeanPostWorkActivityIndex           double
        MeanPostWorkIlluminance             double
        MeanPostWorkCircadianLight          double
        MeanPostWorkCircadianStimulus       double
        GeometricMeanPostWorkIlluminance    double
        GeometricMeanPostWorkCircadianLight double
    end
    
    %% Internal public methods
    methods
        % Class constructor
        function obj = HumanData(log_info_path,data_log_path,varargin)
            obj@d12pack.MobileData;
            if nargin > 0
                obj.log_info = obj.readloginfo(log_info_path);
                obj.data_log = obj.readdatalog(data_log_path);
            end
        end % End of constructor method
        
        %%
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
                AtWork = obj.WorkLog.isAtWork(obj.Time);
            else
                AtWork = false(size(obj.Time));
            end
        end % End of get InBed method
        
        % Get PostWork
        function PostWork = get.PostWork(obj)
            PostWork = false(size(obj.Time));
            if ~isempty(obj.WorkLog) && ~isempty(obj.BedLog)
                BedTime = vertcat(obj.BedLog.BedTime);
                if isdatetime(obj.WorkLog.EndTime)
                    EndTime = obj.WorkLog.EndTime;
                elseif isduration(obj.WorkLog.EndTime)
                    TimeDateVec = datevec(obj.Time); % Convert Time to datevec
                    TimeDateVec(:,4:6) = 0; % Remove time component leaving only date
                    UniqueDateVec = unique(TimeDateVec,'rows'); % Find the unique dates
                    UniqueDateTime = datetime(UniqueDateVec,'TimeZone',obj.Time.TimeZone); % Convert back to datetime keeping the original time zone
                    WeekDays = UniqueDateTime(~isweekend(UniqueDateTime)); % Keep only week days
                    WorkDays = WeekDays(~obj.WorkLog.isFedHoliday(WeekDays)); % Exclude U.S. Federal Holidays
                    EndTime  = WorkDays + obj.WorkLog.EndTime;
                end
                
                for ii = 1:numel(EndTime)
                    thisWorkEnd = EndTime(ii);
                    idxAfter = BedTime > thisWorkEnd;
                    closestBedTime = min(BedTime(idxAfter));
                    if hours(closestBedTime-thisWorkEnd) < 12
                        idxTemp = obj.Time >= thisWorkEnd & obj.Time < closestBedTime;
                        PostWork = PostWork | idxTemp;
                    end
                end
            end
        end % End of get PostWork
        
        % Get PreWork
        function PreWork = get.PreWork(obj)
            PreWork = false(size(obj.Time));
            if ~isempty(obj.WorkLog) && ~isempty(obj.BedLog)
                RiseTime = vertcat(obj.BedLog.RiseTime);
                if isdatetime(obj.WorkLog.StartTime)
                    StartTime = obj.WorkLog.StartTime;
                elseif isduration(obj.WorkLog.StartTime)
                    TimeDateVec = datevec(obj.Time); % Convert Time to datevec
                    TimeDateVec(:,4:6) = 0; % Remove time component leaving only date
                    UniqueDateVec  = unique(TimeDateVec,'rows'); % Find the unique dates
                    UniqueDateTime = datetime(UniqueDateVec,'TimeZone',obj.Time.TimeZone); % Convert back to datetime keeping the original time zone
                    WeekDays  = UniqueDateTime(~isweekend(UniqueDateTime)); % Keep only week days
                    WorkDays  = WeekDays(~obj.WorkLog.isFedHoliday(WeekDays)); % Exclude U.S. Federal Holidays
                    StartTime = WorkDays + obj.WorkLog.StartTime;
                end
                
                for ii = 1:numel(StartTime)
                    thisWorkStart = StartTime(ii);
                    idxBefore = RiseTime < thisWorkStart;
                    closestRiseTime = max(RiseTime(idxBefore));
                    if hours(closestRiseTime-thisWorkStart) < 12
                        idxTemp = obj.Time >= closestRiseTime & obj.Time < thisWorkStart;
                        PreWork = PreWork | idxTemp;
                    end
                end
            end
        end % End of get PostWork
        
        %%
        % Get WakingCoverage
        function WakingCoverage = get.WakingCoverage(obj)
            idx = ~obj.InBed & obj.Compliance & obj.Observation;
            WakingCoverage = obj.Epoch*sum(idx);
        end % End of get WakingCoverage
        
        % Get MeanWakingActivityIndex
        function MeanWakingActivityIndex = get.MeanWakingActivityIndex(obj)
            idx = ~obj.InBed & obj.Compliance & obj.Observation;
            MeanWakingActivityIndex = mean(obj.ActivityIndex(idx));
        end % End of get MeanWakingActivityIndex
        
        % Get MeanWakingIlluminance
        function MeanWakingIlluminance = get.MeanWakingIlluminance(obj)
            idx = ~obj.InBed & obj.Compliance & obj.Observation;
            MeanWakingIlluminance = mean(obj.Illuminance(idx));
        end % End of get MeanWakingIlluminance
        
        % Get MeanWakingCircadianLight
        function MeanWakingCircadianLight = get.MeanWakingCircadianLight(obj)
            idx = ~obj.InBed & obj.Compliance & obj.Observation;
            MeanWakingCircadianLight = mean(obj.CircadianLight(idx));
        end % End of get MeanWakingCircadianLight
        
        % Get MeanWakingCircadianStimulus
        function MeanWakingCircadianStimulus = get.MeanWakingCircadianStimulus(obj)
            idx = ~obj.InBed & obj.Compliance & obj.Observation;
            MeanWakingCircadianStimulus = mean(obj.CircadianStimulus(idx));
        end % End of get MeanWakingCircadianStimulus
        
        % Get GeometricMeanWakingIlluminance
        function GeometricMeanWakingIlluminance = get.GeometricMeanWakingIlluminance(obj)
            idx = ~obj.InBed & obj.Compliance & obj.Observation;
            GeometricMeanWakingIlluminance = geomean(obj.Illuminance(idx));
        end % End of get GeometricMeanWakingIlluminance
        
        % Get GeometricMeanWakingCircadianLight
        function GeometricMeanWakingCircadianLight = get.GeometricMeanWakingCircadianLight(obj)
            idx = ~obj.InBed & obj.Compliance & obj.Observation;
            GeometricMeanWakingCircadianLight = geomean(obj.CircadianLight(idx));
        end % End of get GeometricMeanWakingCircadianLight
        
        %% Mean at work gets
        % Get AtWorkCoverage
        function AtWorkCoverage = get.AtWorkCoverage(obj)
            idx = obj.AtWork & obj.Compliance & obj.Observation;
            AtWorkCoverage = obj.Epoch*sum(idx);
        end % End of get AtWorkCoverage
        
        % Get MeanAtWorkActivityIndex
        function MeanAtWorkActivityIndex = get.MeanAtWorkActivityIndex(obj)
            idx = obj.AtWork & obj.Compliance & obj.Observation;
            MeanAtWorkActivityIndex = mean(obj.ActivityIndex(idx));
        end % End of get MeanAtWorkActivityIndex
        
        % Get MeanAtWorkIlluminance
        function MeanAtWorkIlluminance = get.MeanAtWorkIlluminance(obj)
            idx = obj.AtWork & obj.Compliance & obj.Observation;
            MeanAtWorkIlluminance = mean(obj.Illuminance(idx));
        end % End of get MeanAtWorkIlluminance
        
        % Get MeanAtWorkCircadianLight
        function MeanAtWorkCircadianLight = get.MeanAtWorkCircadianLight(obj)
            idx = obj.AtWork & obj.Compliance & obj.Observation;
            MeanAtWorkCircadianLight = mean(obj.CircadianLight(idx));
        end % End of get MeanAtWorkCircadianLight
        
        % Get MeanAtWorkCircadianStimulus
        function MeanAtWorkCircadianStimulus = get.MeanAtWorkCircadianStimulus(obj)
            idx = obj.AtWork & obj.Compliance & obj.Observation;
            MeanAtWorkCircadianStimulus = mean(obj.CircadianStimulus(idx));
        end % End of get MeanAtWorkCircadianStimulus
        
        % Get GeometricMeanAtWorkIlluminance
        function GeometricMeanAtWorkIlluminance = get.GeometricMeanAtWorkIlluminance(obj)
            idx = obj.AtWork & obj.Compliance & obj.Observation;
            GeometricMeanAtWorkIlluminance = geomean(obj.Illuminance(idx));
        end % End of get GeometricMeanAtWorkIlluminance
        
        % Get GeometricMeanAtWorkCircadianLight
        function GeometricMeanAtWorkCircadianLight = get.GeometricMeanAtWorkCircadianLight(obj)
            idx = obj.AtWork & obj.Compliance & obj.Observation;
            GeometricMeanAtWorkCircadianLight = geomean(obj.CircadianLight(idx));
        end % End of get GeometricMeanAtWorkCircadianLight
        
        %% PreWork gets
        % Get PreWorkCoverage
        function PreWorkCoverage = get.PreWorkCoverage(obj)
            idx = obj.PreWork & obj.Compliance & obj.Observation;
            PreWorkCoverage = obj.Epoch*sum(idx);
        end % End of get PreWorkCoverage
        
        % Get MeanPreWorkActivityIndex
        function MeanPreWorkActivityIndex = get.MeanPreWorkActivityIndex(obj)
            idx = obj.PreWork & obj.Compliance & obj.Observation;
            MeanPreWorkActivityIndex = mean(obj.ActivityIndex(idx));
        end % End of get MeanPreWorkActivityIndex
        
        % Get MeanPreWorkIlluminance
        function MeanPreWorkIlluminance = get.MeanPreWorkIlluminance(obj)
            idx = obj.PreWork & obj.Compliance & obj.Observation;
            MeanPreWorkIlluminance = mean(obj.Illuminance(idx));
        end % End of get MeanPreWorkIlluminance
        
        % Get MeanPreWorkCircadianLight
        function MeanPreWorkCircadianLight = get.MeanPreWorkCircadianLight(obj)
            idx = obj.PreWork & obj.Compliance & obj.Observation;
            MeanPreWorkCircadianLight = mean(obj.CircadianLight(idx));
        end % End of get MeanPreWorkCircadianLight
        
        % Get MeanPreWorkCircadianStimulus
        function MeanPreWorkCircadianStimulus = get.MeanPreWorkCircadianStimulus(obj)
            idx = obj.PreWork & obj.Compliance & obj.Observation;
            MeanPreWorkCircadianStimulus = mean(obj.CircadianStimulus(idx));
        end % End of get MeanPreWorkCircadianStimulus
        
        % Get GeometricMeanPreWorkIlluminance
        function GeometricMeanPreWorkIlluminance = get.GeometricMeanPreWorkIlluminance(obj)
            idx = obj.PreWork & obj.Compliance & obj.Observation;
            GeometricMeanPreWorkIlluminance = geomean(obj.Illuminance(idx));
        end % End of get GeometricMeanPreWorkIlluminance
        
        % Get GeometricMeanPreWorkCircadianLight
        function GeometricMeanPreWorkCircadianLight = get.GeometricMeanPreWorkCircadianLight(obj)
            idx = obj.PreWork & obj.Compliance & obj.Observation;
            GeometricMeanPreWorkCircadianLight = geomean(obj.CircadianLight(idx));
        end % End of get GeometricMeanPreWorkCircadianLight
        
        %% PostWork gets
        % Get PostWorkCoverage
        function PostWorkCoverage = get.PostWorkCoverage(obj)
            idx = obj.PostWork & obj.Compliance & obj.Observation;
            PostWorkCoverage = obj.Epoch*sum(idx);
        end % End of get PostWorkCoverage
        
        % Get MeanPostWorkActivityIndex
        function MeanPostWorkActivityIndex = get.MeanPostWorkActivityIndex(obj)
            idx = obj.PostWork & obj.Compliance & obj.Observation;
            MeanPostWorkActivityIndex = mean(obj.ActivityIndex(idx));
        end % End of get MeanPostWorkActivityIndex
        
        % Get MeanPostWorkIlluminance
        function MeanPostWorkIlluminance = get.MeanPostWorkIlluminance(obj)
            idx = obj.PostWork & obj.Compliance & obj.Observation;
            MeanPostWorkIlluminance = mean(obj.Illuminance(idx));
        end % End of get MeanPostWorkIlluminance
        
        % Get MeanPostWorkCircadianLight
        function MeanPostWorkCircadianLight = get.MeanPostWorkCircadianLight(obj)
            idx = obj.PostWork & obj.Compliance & obj.Observation;
            MeanPostWorkCircadianLight = mean(obj.CircadianLight(idx));
        end % End of get MeanPostWorkCircadianLight
        
        % Get MeanPostWorkCircadianStimulus
        function MeanPostWorkCircadianStimulus = get.MeanPostWorkCircadianStimulus(obj)
            idx = obj.PostWork & obj.Compliance & obj.Observation;
            MeanPostWorkCircadianStimulus = mean(obj.CircadianStimulus(idx));
        end % End of get MeanPostWorkCircadianStimulus
        
        % Get GeometricMeanPostWorkIlluminance
        function GeometricMeanPostWorkIlluminance = get.GeometricMeanPostWorkIlluminance(obj)
            idx = obj.PostWork & obj.Compliance & obj.Observation;
            GeometricMeanPostWorkIlluminance = geomean(obj.Illuminance(idx));
        end % End of get GeometricMeanPostWorkIlluminance
        
        % Get GeometricMeanPostWorkCircadianLight
        function GeometricMeanPostWorkCircadianLight = get.GeometricMeanPostWorkCircadianLight(obj)
            idx = obj.PostWork & obj.Compliance & obj.Observation;
            GeometricMeanPostWorkCircadianLight = geomean(obj.CircadianLight(idx));
        end % End of get GeometricMeanPostWorkCircadianLight
    end
    
    % External public methods
    methods % (Access = public)
        t = analysis(obj)
    end
    
    % External static protected methods
    methods (Static, Access = protected)
        PhasorCompliance = adjustcompliance(Epoch,Time,Compliance,varargin)
    end
end

