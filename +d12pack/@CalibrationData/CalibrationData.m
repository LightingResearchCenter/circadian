classdef CalibrationData
    %CALIBRATIONDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    % Public properties
    properties
        Red     double = double.empty(1,0);     %
        Green   double = double.empty(1,0);     %
        Blue    double = double.empty(1,0);     %
        Date    datetime = datetime.empty(1,0);	% Date calibration was performed
        Label   char = char.empty(0,1);         % Label describing calibration session
    end
    
    % Internal methods
    methods
        % Class constructor method
        function obj = CalibrationData(Red,Green,Blue,varargin)
            if nargin >= 3
                switch nargin
                    case 3
                        Date = datetime.empty(1,0);
                        Label = char.empty(0,1);
                    case 4
                        Date = varargin{1};
                        Label = char.empty(0,1);
                    case 5
                        Date = varargin{1};
                        Label = varargin{2};
                end
                n = min([numel(Red),numel(Green),numel(Blue)]);
                if numel(Date) < n
                    Date = repmat(Date(1),n,1);
                end
                if ~iscell(Label)
                    Label = {Label};
                end
                if numel(Label) < n
                    Label = repmat(Label(1),n,1);
                end
                
                for iC = n:-1:1
                    obj(iC,1).Red = Red(iC);
                    obj(iC,1).Green = Green(iC);
                    obj(iC,1).Blue = Blue(iC);
                    obj(iC,1).Date = Date(iC);
                    obj(iC,1).Label = Label{iC};
                end
            end
        end % End of constructor method
    end
    
    % External public methods
    methods
        Coefficients = double(obj)
        obj = import(obj,FilePath,SerialNumber)
    end
    
end

