classdef LocationData
    %LOCATIONDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties % (Access = public)
        Country         char
        State_Region    char
        City            char
        Street          char
        BuildingName    char
        Organization    char
        Wing            char
        Floor           char
        Workstation     char
        Lattitude       double
        Longitude       double
    end
    
    methods
        % Class constructor method
        function obj = LocationData(varargin)
            if nargin > 0
                
            end
        end
    end
    
end

