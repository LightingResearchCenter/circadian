classdef composite < d12pack.report
    %COMPOSITE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        PhasorPanel
        MillerPanel
        TextPanel
        DistributionPanel
    end
    
    methods
        function obj = composite(varargin)
            obj@d12pack.report;
            obj.Type = 'Composite Report';
            obj.Orientation = 'landscape';
            
            obj.initPhasorPanel;
            obj.initMillerPanel;
            obj.initTextPanel;
            obj.initDistributionPanel;
        end % End of class constructor
        
        function obj = initPhasorPanel(obj)
            oldUnits = obj.Body.Units;
            obj.Body.Units = 'pixels';
            
            x = 0;
            w = floor(obj.Body.Position(3)/3);
            h = w;
            y = obj.Body.Position(4) - h;
            
            obj.PhasorPanel = uipanel(obj.Body);
            obj.PhasorPanel.Units = 'pixels';
            obj.PhasorPanel.Position = [x,y,w,h];
            obj.PhasorPanel.TitlePosition = 'centertop';
            obj.PhasorPanel.FontName = 'Arial';
            obj.PhasorPanel.FontUnits = 'pixels';
            obj.PhasorPanel.FontSize = 12;
            obj.PhasorPanel.FontWeight = 'bold';
            obj.PhasorPanel.Title = 'Phasor';
            
            obj.Body.Units = oldUnits;
        end
        
        function obj = initMillerPanel(obj)
            oldUnits = obj.Body.Units;
            obj.Body.Units = 'pixels';
            
            x = obj.PhasorPanel.Position(1) + obj.PhasorPanel.Position(3) + 18;
            w = obj.Body.Position(3) - x;
            h = obj.PhasorPanel.Position(4);
            y = obj.PhasorPanel.Position(2);
            
            obj.MillerPanel = uipanel(obj.Body);
            obj.MillerPanel.Units = 'pixels';
            obj.MillerPanel.Position = [x,y,w,h];
            obj.MillerPanel.TitlePosition = 'centertop';
            obj.MillerPanel.FontName = 'Arial';
            obj.MillerPanel.FontUnits = 'pixels';
            obj.MillerPanel.FontSize = 12;
            obj.MillerPanel.FontWeight = 'bold';
            obj.MillerPanel.Title = 'Average Day';
            
            obj.Body.Units = oldUnits;
        end
        
        function obj = initTextPanel(obj)
            oldUnits = obj.Body.Units;
            obj.Body.Units = 'pixels';
            
            x = obj.PhasorPanel.Position(1);
            w = obj.PhasorPanel.Position(3);
            h = obj.PhasorPanel.Position(2) - 18;
            y = 0;
            
            obj.TextPanel = uipanel(obj.Body);
            obj.TextPanel.Units = 'pixels';
            obj.TextPanel.Position = [x,y,w,h];
            
            obj.Body.Units = oldUnits;
        end
        
        function obj = initDistributionPanel(obj)
            oldUnits = obj.Body.Units;
            obj.Body.Units = 'pixels';
            
            x = obj.MillerPanel.Position(1);
            w = obj.MillerPanel.Position(3);
            h = obj.TextPanel.Position(4);
            y = 0;
            
            obj.DistributionPanel = uipanel(obj.Body);
            obj.DistributionPanel.Units = 'pixels';
            obj.DistributionPanel.Position = [x,y,w,h];
            obj.DistributionPanel.TitlePosition = 'centertop';
            obj.DistributionPanel.FontName = 'Arial';
            obj.DistributionPanel.FontUnits = 'pixels';
            obj.DistributionPanel.FontSize = 12;
            obj.DistributionPanel.FontWeight = 'bold';
            obj.DistributionPanel.Title = 'Normal Porbability Distribution';
            
            obj.Body.Units = oldUnits;
        end
    end
    
    methods (Static)
        
    end
    
end

