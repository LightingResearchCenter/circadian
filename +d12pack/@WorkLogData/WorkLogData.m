classdef WorkLogData
    %WORKLOGDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties % (Access = public)
        StartTime   datetime %
        EndTime     datetime %
        Workstation char     %
    end
    
    % Internal methods
    methods % (Access = public)
        % Class constructior
        function obj = WorkLogData(StartTime,EndTime,varargin)
            if nargin >= 1
                if nargin == 3
                    Workstation = varargin{1};
                else
                    Workstation = '';
                end
                nStart = numel(StartTime);
                nEnd   = numel(EndTime);
                if iscell(Workstation)
                    nWorkstation = numel(Workstation);
                else
                    Workstation = repmat({Workstation},size(StartTime));
                end
                if isequal(nStart,nEnd,nWorkstation)
                    for iWork = nStart:-1:1
                        obj(iWork,1).StartTime  = StartTime(iWork);
                        obj(iWork,1).EndTime = EndTime(iWork);
                        obj(iWork,1).Workstation = Workstation{iWork};
                    end
                else
                    error('Input must be of equal size.')
                end
            end
        end % End of class constructor method
    end
    
    % External methods
    methods % (Access = public)
        obj = import(obj,FilePath,varargin)
        t = table(obj)
        disp(obj)
    end
    
end

