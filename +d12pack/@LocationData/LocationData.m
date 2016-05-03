classdef LocationData
    %LOCATIONDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties % (Access = public)
        Country         char
        State_Territory char
        PostalStateAbbreviation char
        City            char
        Street          char
        ZIP             char
        BuildingName    char
        Organization    char
        Wing            char
        Floor           char
        Workstation     char
        WindowProximity char
        Exposure        char
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

