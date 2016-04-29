classdef WeatherLogData
    %WEATHERLOGDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Date datetime
        Condition char
    end
    
    % Internal methods
    methods % (Access = public)
        % Class constructior
        function obj = WeatherLogData(Date,Condition)
            if nargin >= 1
                
                nDate = numel(Date);
                if ~iscell(Condition)
                    Condition = cellstr(Condition);
                end
                nCondition = numel(Condition);
                
                if isequal(nDate,nCondition)
                    for ii = nDate:-1:1
                        obj(ii,1).Date      = Date(ii);
                        obj(ii,1).Condition = Condition{ii};
                    end
                else
                    error('Input must be of equal size.')
                end
            end
        end % End of class constructor method
    end
    
    methods
        disp(obj)
        t = table(obj)
        obj = import(obj,FilePath,varargin)
        TF = isCondition(obj,Time,TestCondition)
    end
    
end

