classdef daysigram < d12pack.report
    %DAYSIGRAM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Axes
        SubAxes
    end
    
    methods
        function obj = daysigram(varargin)
            obj@d12pack.report;
            if nargin == 0
                obj.Type = 'Daysigram Report';
            else
                
                obj.initAxes;
            end
        end % End of class constructor
        
        %% initAxes creates 10 axes to plot on
        function obj = initAxes(obj)
            x = 36;
            w = obj.Body.Position(3) - x - 36;
            h = floor((obj.Body.Position(4) - 72)/10);
            
            obj.Axes = gobjects(10,1);
            obj.SubAxes = gobjects(10,1);
            for iAx = 1:10
                y = obj.Body.Position(4) - iAx*h;
                
                obj.SubAxes(iAx) = axes(obj.Body);
                obj.SubAxes(iAx).Units = 'pixels';
                obj.SubAxes(iAx).Position = [x,y,w,h-1];
                
                obj.SubAxes(iAx).YLimMode = 'manual';
                obj.SubAxes(iAx).YLim = [0,1];
                obj.SubAxes(iAx).XLimMode = 'manual';
                obj.SubAxes(iAx).XLim = [0,24];
                obj.SubAxes(iAx).Visible = 'off';
                
                obj.Axes(iAx) = axes(obj.Body);
                obj.Axes(iAx).Units = 'pixels';
                obj.Axes(iAx).Position = [x,y,w,h-1];
                
                obj.Axes(iAx).TickLength = [0,0];
                obj.Axes(iAx).YLimMode = 'manual';
                obj.Axes(iAx).YLim = [0,1];
                obj.Axes(iAx).YTick = .25:.25:.75;
                obj.Axes(iAx).YTickLabel = {'0.25','0.50','0.75'};
                obj.Axes(iAx).YGrid = 'on';
                obj.Axes(iAx).XLimMode = 'manual';
                obj.Axes(iAx).XLim = [0,24];
                obj.Axes(iAx).XTick = 0:2:24;
                obj.Axes(iAx).XTickLabel = '';
                obj.Axes(iAx).XGrid = 'on';
                obj.Axes(iAx).Color = 'none';
                
            end
            obj.Axes(10).XTickLabel = obj.Axes(10).XTick;
            hLabel = xlabel(obj.Axes(10),'Time of Day (hours)');
            
            % Box in the plots
            hBoxAxes = axes(obj.Body);
            hBoxAxes.Units = 'pixels';
            hBoxAxes.Position = [x, y, w, h*10];
            hBoxAxes.XLimMode = 'manual';
            hBoxAxes.XLim = [0,1];
            hBoxAxes.YLimMode = 'manual';
            hBoxAxes.YLim = [0,1];
            xBox = [0,1,1,0,0];
            yBox = [0,0,1,1,0];
            hBox = plot(hBoxAxes,xBox,yBox);
            hBox.Color = 'black';
            hBox.LineWidth = 1;
            hBoxAxes.Visible = 'off';
        end % End of initAxes
        
    end
    
    methods (Static)
        %%
        function plotDay(hAxes,hSubAxes,Time,ActivityIndex,CircadianStimulus,Observation,Error,varargin)
            hold(hSubAxes,'on');
            hold(hAxes,'on');
            
            Hours = hours(timeofday(Time));
            
            
            if nargin == 10
                Compliance = varargin{1};
                InBed = varargin{2};
                AtWork = varargin{3};
                
                % Plot and format in Bed
                hBed = area(hSubAxes,Hours,InBed);
                hBed.FaceColor = [255, 255, 191]/255;
                hBed.EdgeColor = 'none';
                hBed.DisplayName = 'Reported in Bed';
                
                % Plot and format at Work
                hWrk = area(hSubAxes,Hours,AtWork);
                hWrk.FaceColor = [255, 255, 191]/255;
                hWrk.EdgeColor = 'none';
                hWrk.DisplayName = 'Reported at Work';
                
                % Plot and format Noncompliance
                hNC = area(hSubAxes,Hours,Compliance);
                hNC.FaceColor = [230, 230, 230]/255;
                hNC.EdgeColor = 'none';
                hNC.DisplayName = 'Noncompliance';
            end
            
            % Plot and format Excluded Data
            hExc = area(hSubAxes,Hours,~Observation);
            hExc.FaceColor = [255, 215, 215]/255;
            hExc.EdgeColor = 'none';
            hExc.DisplayName = 'Excluded Data';
            
            % Plot and format Device Error
            hErr = area(hSubAxes,Hours,Error);
            hErr.FaceColor = 'magenta';
            hErr.EdgeColor = 'none';
            hErr.DisplayName = 'Device Error';
            
            % Plot and format Circadian Stimulus
            hCS = area(hAxes,Hours,CircadianStimulus);
            hCS.FaceColor = [180, 211, 227]/256;
            hCS.EdgeColor = 'none';
            hCS.DisplayName = 'Circadian Stimulus (CS)';
            
            % Plot and format Activity Index
            hAI = plot(hAxes,Hours,ActivityIndex);
            hAI.Color = 'black';
            hAI.LineWidth = 1.5;
            hAI.DisplayName = 'Activity Index (AI)';
            
            % Add Date label
            hDate = ylabel(hAxes,datestr(Time(1),'yyyy\nmmm dd'));
            hDate.Position(1) = 24;
            hDate.Rotation = 90;
            hDate.HorizontalAlignment = 'center';
            hDate.VerticalAlignment = 'top';
            hDate.FontSize = 8;
            
            hold(hAxes,'off');
            hold(hSubAxes,'off');
        end
    end
    
end

