classdef lamp < matlab.mixin.SetGet
    %LAMP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetObservable)
        Value = 'on';
    end
    
    properties
        OnState
        OffState
    end
    
    properties (Dependent)
        Position
    end
    
    properties (Access = protected)
        Axes
    end
    
    properties (Constant, Access = protected)
        x = cos(0:0.01:2*pi);
        y = sin(0:0.01:2*pi);
    end
    
    methods
        function obj = lamp(varargin)
            addlistener(obj,'Value','PostSet',@d12pack.lamp.ValueChangedCallback);
            
            if nargin == 0
                Parent = gcf;
            else
                Parent = varargin{1};
                if ~ishandle(Parent)
                    Parent = gcf;
                elseif ~isvalid(Parent)
                    Parent = gcf;
                end
            end
            obj.Axes = axes(Parent);
            hold(obj.Axes,'on');
            obj.Axes.Visible = 'off';
            obj.Axes.Units = 'pixels';
            obj.Axes.XLim = [-1 1];
            obj.Axes.YLim = [-1 1];
            obj.Axes.DataAspectRatioMode = 'manual';
            obj.Axes.DataAspectRatio = [1 1 1];
            
            obj.OnState = area(obj.x,obj.y);
            obj.OnState.EdgeColor = 'none';
            obj.OnState.FaceColor = 'green';
            
            obj.OffState = area(obj.x,obj.y);
            obj.OffState.EdgeColor = 'none';
            obj.OffState.FaceColor = [.3 .3 .3];
            
            switch obj.Value
                case 'on'
                    obj.OnState.Visible = 'on';
                    obj.OffState.Visible = 'off';
                case 'off'
                    obj.OnState.Visible = 'off';
                    obj.OffState.Visible = 'on';
                otherwise
                    error('Lamp value not a recognized state.');
            end
            
            hold(obj.Axes,'off');
        end
        
        function Position = get.Position(obj)
            Position = obj.Axes.Position;
        end
        function obj = set.Position(obj,Position)
            obj.Axes.Position = Position;
        end
        
    end
    
    methods (Static)
        function ValueChangedCallback(src,evnt)
            switch evnt.AffectedObject.Value
                case 'on'
                    evnt.AffectedObject.OnState.Visible = 'on';
                    evnt.AffectedObject.OffState.Visible = 'off';
                case 'off'
                    evnt.AffectedObject.OnState.Visible = 'off';
                    evnt.AffectedObject.OffState.Visible = 'on';
                otherwise
                    error('Lamp value not a recognized state.');
            end
        end
    end
    
end

