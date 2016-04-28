classdef WorkLogData
    %WORKLOGDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties % (Access = public)
        Workstation cell = {''}       %
        IsFixed     logical = false %
    end
    
    properties (Dependent)
        StartTime %
        EndTime   %
    end
    
    properties (Access = private)
        PrivateStartTime_datetime datetime = datetime.empty(1,0)
        PrivateEndTime_datetime   datetime = datetime.empty(1,0)
        
        PrivateStartTime_duration duration = duration.empty(1,0)
        PrivateEndTime_duration   duration = duration.empty(1,0)
    end
    
    % Internal methods
    methods % (Access = public)
        % Class constructior
        function obj = WorkLogData(StartTime,EndTime,varargin)
            if nargin >= 1
                switch nargin
                    case 3
                        IsFixed = varargin{1};
                        Workstation = '';
                    case 4
                        IsFixed = varargin{1};
                        Workstation = varargin{2};
                    otherwise
                        IsFixed = false;
                        Workstation = '';
                end
                obj.IsFixed = IsFixed;
                
                nStart = numel(StartTime);
                nEnd   = numel(EndTime);
                if iscell(Workstation)
                    nWorkstation = numel(Workstation);
                else
                    Workstation = repmat({Workstation},size(StartTime));
                end
                if isequal(nStart,nEnd,nWorkstation)
                    obj.StartTime   = StartTime(:);
                    obj.EndTime     = EndTime(:);
                    obj.Workstation = Workstation(:);
                else
                    error('Input must be of equal size.')
                end
            end
        end % End of class constructor method
        
        % Set StartTime
        function obj = set.StartTime(obj,StartTime)
            if obj.IsFixed && isduration(StartTime)
                obj.PrivateStartTime_duration = StartTime;
            elseif ~(obj.IsFixed) && isdatetime(StartTime)
                obj.PrivateStartTime_datetime = StartTime;
            else
                error('StartTime must be of class duration for fixed work logs or class datetime for non-fixed work logs.');
            end
        end % End of set StartTime
        % Get StartTime
        function StartTime = get.StartTime(obj)
            if obj.IsFixed
                StartTime = obj.PrivateStartTime_duration;
            else
                StartTime = obj.PrivateStartTime_datetime;
            end
        end % End of get StartTime
        
        % Set EndTime
        function obj = set.EndTime(obj,EndTime)
            if obj.IsFixed && isduration(EndTime)
                obj.PrivateEndTime_duration = EndTime;
            elseif ~obj.IsFixed && isdatetime(EndTime)
                obj.PrivateEndTime_datetime = EndTime;
            else
                error('EndTime must be of class duration for fixed work logs or class datetime for non-fixed work logs.');
            end
        end % End of set EndTime
        % Get EndTime
        function EndTime = get.EndTime(obj)
            if obj.IsFixed
                EndTime = obj.PrivateEndTime_duration;
            else
                EndTime = obj.PrivateEndTime_datetime;
            end
        end % End of get StartTime
        
    end
    
    % External methods
    methods % (Access = public)
        obj = import(obj,FilePath,varargin)
        t = table(obj)
        disp(obj)
    end
    
end

