classdef StaticData < d12pack.DaysimeterData
    %STATICDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    %%
    properties % (Access = public)
        Type        char
        Orientation char
        WeatherLog  d12pack.WeatherLogData
    end
    
    %%
    properties (Dependent)
        IsSunny
        IsCloudy
    end
    
    %%
    methods
        % Constructor method
        function obj = StaticData(log_info_path,data_log_path,varargin)
            obj@d12pack.DaysimeterData;
            if nargin > 0
                obj.log_info = obj.readloginfo(log_info_path);
                obj.data_log = obj.readdatalog(data_log_path);
            end
        end % End of constructor method
        
        % Get IsSunny
        function IsSunny = get.IsSunny(obj)
            if isempty(obj.WeatherLog)
                IsSunny = logical.empty(size(obj.Time));
            else
                IsSunny = obj.WeatherLog.isCondition(obj.Time,'Sunny');
            end
        end % End of get IsSunny
        
        % Get IsCloudy
        function IsCloudy = get.IsCloudy(obj)
            if isempty(obj.WeatherLog)
                IsCloudy = logical.empty(size(obj.Time));
            else
                IsCloudy = obj.WeatherLog.isCondition(obj.Time,'Cloudy');
            end
        end % End of get IsCloudy
    end
    
    %%
    methods
        t = analysis(obj)
    end
    
end

