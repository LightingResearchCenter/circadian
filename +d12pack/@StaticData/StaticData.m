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
        
        SunnyHourlyMeanIlluminance
        SunnyHourlyMeanCircadianLight
        SunnyHourlyMeanCircadianStimulus
        
        SunnyHourlyGeometricMeanIlluminance
        SunnyHourlyGeometricMeanCircadianLight
        SunnyHourlyGeometricMeanCircadianStimulus
        
        CloudyHourlyMeanIlluminance
        CloudyHourlyMeanCircadianLight
        CloudyHourlyMeanCircadianStimulus
        
        CloudyHourlyGeometricMeanIlluminance
        CloudyHourlyGeometricMeanCircadianLight
        CloudyHourlyGeometricMeanCircadianStimulus
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
        
        %%
        % Get SunnyHourlyMeanIlluminance
        function SunnyHourlyMeanIlluminance = get.SunnyHourlyMeanIlluminance(obj)
            SunnyHourlyMeanIlluminance = hourly(obj,obj.Illuminance,'mean',obj.IsSunny);
        end % End of get SunnyHourlyMeanIlluminance
        
        % Get SunnyHourlyMeanCircadianLight
        function SunnyHourlyMeanCircadianLight = get.SunnyHourlyMeanCircadianLight(obj)
            SunnyHourlyMeanCircadianLight = hourly(obj,obj.CircadianLight,'mean',obj.IsSunny);
        end % End of get SunnyHourlyMeanCircadianLight
        
        % Get SunnyHourlyMeanCircadianStimulus
        function SunnyHourlyMeanCircadianStimulus = get.SunnyHourlyMeanCircadianStimulus(obj)
            SunnyHourlyMeanCircadianStimulus = hourly(obj,obj.CircadianStimulus,'mean',obj.IsSunny);
        end % End of get SunnyHourlyMeanCircadianStimulus
        
        %%
        % Get SunnyHourlyGeometricMeanIlluminance
        function SunnyHourlyGeometricMeanIlluminance = get.SunnyHourlyGeometricMeanIlluminance(obj)
            SunnyHourlyGeometricMeanIlluminance = hourly(obj,obj.Illuminance,'geomean',obj.IsSunny);
        end % End of get SunnyHourlyGeometricMeanIlluminance
        
        % Get SunnyHourlyGeometricMeanCircadianLight
        function SunnyHourlyGeometricMeanCircadianLight = get.SunnyHourlyGeometricMeanCircadianLight(obj)
            SunnyHourlyGeometricMeanCircadianLight = hourly(obj,obj.CircadianLight,'geomean',obj.IsSunny);
        end % End of get SunnyHourlyGeometricMeanCircadianLight
        
        % Get SunnyHourlyGeometricMeanCircadianStimulus
        function SunnyHourlyGeometricMeanCircadianStimulus = get.SunnyHourlyGeometricMeanCircadianStimulus(obj)
            SunnyHourlyGeometricMeanCircadianStimulus = hourly(obj,obj.CircadianStimulus,'geomean',obj.IsSunny);
        end % End of get SunnyHourlyGeometricMeanCircadianStimulus
        
        %%
        % Get CloudyHourlyMeanIlluminance
        function CloudyHourlyMeanIlluminance = get.CloudyHourlyMeanIlluminance(obj)
            CloudyHourlyMeanIlluminance = hourly(obj,obj.Illuminance,'mean',obj.IsCloudy);
        end % End of get CloudyHourlyMeanIlluminance
        
        % Get CloudyHourlyMeanCircadianLight
        function CloudyHourlyMeanCircadianLight = get.CloudyHourlyMeanCircadianLight(obj)
            CloudyHourlyMeanCircadianLight = hourly(obj,obj.CircadianLight,'mean',obj.IsCloudy);
        end % End of get CloudyHourlyMeanCircadianLight
        
        % Get CloudyHourlyMeanCircadianStimulus
        function CloudyHourlyMeanCircadianStimulus = get.CloudyHourlyMeanCircadianStimulus(obj)
            CloudyHourlyMeanCircadianStimulus = hourly(obj,obj.CircadianStimulus,'mean',obj.IsCloudy);
        end % End of get CloudyHourlyMeanCircadianStimulus
        
        %%
        % Get CloudyHourlyGeometricMeanIlluminance
        function CloudyHourlyGeometricMeanIlluminance = get.CloudyHourlyGeometricMeanIlluminance(obj)
            CloudyHourlyGeometricMeanIlluminance = hourly(obj,obj.Illuminance,'geomean',obj.IsCloudy);
        end % End of get CloudyHourlyGeometricMeanIlluminance
        
        % Get CloudyHourlyGeometricMeanCircadianLight
        function CloudyHourlyGeometricMeanCircadianLight = get.CloudyHourlyGeometricMeanCircadianLight(obj)
            CloudyHourlyGeometricMeanCircadianLight = hourly(obj,obj.CircadianLight,'geomean',obj.IsCloudy);
        end % End of get CloudyHourlyGeometricMeanCircadianLight
        
        % Get CloudyHourlyGeometricMeanCircadianStimulus
        function CloudyHourlyGeometricMeanCircadianStimulus = get.CloudyHourlyGeometricMeanCircadianStimulus(obj)
            CloudyHourlyGeometricMeanCircadianStimulus = hourly(obj,obj.CircadianStimulus,'geomean',obj.IsCloudy);
        end % End of get CloudyHourlyGeometricMeanCircadianStimulus
    end
    
    %%
    methods
        t = analysis(obj)
    end
    
end

