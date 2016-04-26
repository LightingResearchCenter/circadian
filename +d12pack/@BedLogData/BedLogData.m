classdef BedLogData
    %BEDLOGDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    % Public properties
    properties
        BedTime  datetime %
        RiseTime datetime %
    end
    
    % Internal public methods
    methods
        % Class constructior
        function obj = BedLogData(BedTime,RiseTime)
            if nargin >= 1
                nBed  = numel(BedTime);
                nRise = numel(RiseTime);
                if nBed == nRise
                    for iBed = nBed:-1:1
                        obj(iBed,1).BedTime  = BedTime(iBed);
                        obj(iBed,1).RiseTime = RiseTime(iBed);
                    end
                else
                    error('BedTime and RiseTime must be of equal size.')
                end
            end
        end % End of class constructor method
    end
    
    % External public methods
    methods
        obj = import(obj,FilePath,varargin)
        t = table(obj)
        disp(obj)
    end
    
end

