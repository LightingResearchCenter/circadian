classdef StaticData < d12pack.DaysimeterData
    %STATICDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties % (Access = public)
        Orientation char
        Exposure    char
    end
    
    methods
        % Constructor method
        function obj = StaticData(log_info_path,data_log_path,varargin)
            obj@d12pack.DaysimeterData;
            if nargin > 0
                obj.log_info = obj.readloginfo(log_info_path);
                obj.data_log = obj.readdatalog(data_log_path);
            end
        end % End of constructor method
    end
    
end

