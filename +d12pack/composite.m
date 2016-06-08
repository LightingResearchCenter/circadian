classdef composite < d12pack.report
    %COMPOSITE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        PhasorPanel
        PhasorAxes
        MillerPanel
        MillerAxes
        TextPanel
        DistributionPanel
        MagnitudeDistAxes
        AngleDistAxes
        MagnitudeDistCurve
        AngleDistCurve
        MagnitudeDistHist
        Data
    end
    
    properties (Access = protected)
        LRCBlue   = [ 30,  63, 134]/255;
        LightBlue = [180, 211, 227]/255;
    end
    
    methods
        
        function obj = composite(varargin)
            obj@d12pack.report;
            obj.Type = 'Composite Report';
            obj.Orientation = 'landscape';
            obj.PageNumBox.Visible = 'off';
            
            obj.initPhasorPanel;
            obj.initMillerPanel;
            obj.initTextPanel;
            obj.initDistributionPanel;
            
            if nargin > 0
                obj.loadData(varargin{1});
            end
        end % End of class constructor
        
        function obj = loadData(obj,Data)
            obj.Data = Data;
            obj.plotPhasor;
            obj.plotMiller;
            obj.plotText;
            obj.plotDist;
        end
    end
    
    methods (Access = protected)
        %%
        function initPhasorPanel(obj)
            oldUnits = obj.Body.Units;
            obj.Body.Units = 'pixels';
            
            x = 0;
            w = floor(obj.Body.Position(3)/3);
            h = w;
            y = obj.Body.Position(4) - h;
            
            obj.PhasorPanel = uipanel(obj.Body);
            obj.PhasorPanel.BackgroundColor	= 'white';
            obj.PhasorPanel.BorderType = 'none';
            obj.PhasorPanel.Units = 'pixels';
            obj.PhasorPanel.Position = [x,y,w,h];
            
            hTitle = annotation(obj.PhasorPanel,'textbox');
            hTitle.HorizontalAlignment = 'center';
            hTitle.LineStyle = 'none';
            hTitle.Units = 'pixels';
            hTitle.Position = [0,h-23,w,23];
            hTitle.FontName = 'Arial';
            hTitle.FontUnits = 'pixels';
            hTitle.FontSize = 12;
            hTitle.FontWeight = 'bold';
            hTitle.String = 'Phasor';
            
            obj.initPhasorAxes;
            
            obj.Body.Units = oldUnits;
        end
        
        function initPhasorAxes(obj)
            rMin = 0;
            rMax = 0.6;
            rTicks = 6;
            rInc = (rMax - rMin)/rTicks;
            
            % Create Axes
            obj.PhasorAxes = axes(obj.PhasorPanel,'Visible','off');
            obj.PhasorAxes.Units = 'pixels';
            x = 15;
            y = 10;
            w = obj.PhasorPanel.Position(3) - 2*x;
            h = w;
            obj.PhasorAxes.Position = [x y w h];
            hAxes = obj.PhasorAxes;
            
            % Prevent unwanted resizing of axes.
            hAxes.ActivePositionProperty = 'position';
            
            % Prevent axes from being erased.
            hAxes.NextPlot = 'add';
            
            % Make aspect ratio equal.
            hAxes.DataAspectRatio = [1 1 1];
            
            % Create a handle groups.
            hGrid = hggroup;
            set(hGrid,'Parent',hAxes);
            hLabels = hggroup;
            set(hLabels,'Parent',hAxes);
            
            % Define a circle.
            th = 0:pi/100:2*pi;
            xunit = cos(th);
            yunit = sin(th);
            % Now really force points on x/y axes to lie on them exactly.
            inds = 1 : (length(th) - 1) / 4 : length(th);
            xunit(inds(2 : 2 : 4)) = zeros(2, 1);
            yunit(inds(1 : 2 : 5)) = zeros(3, 1);
            
            % Plot spokes.
            th = (1:12)*2*pi/12;
            cst = cos(th);
            snt = sin(th);
            cs = [zeros(size(cst)); cst];
            sn = [zeros(size(snt)); snt];
            hSpoke = line(rMax*cs,rMax*sn);
            for iSpoke = 1:numel(hSpoke)
                hSpoke(iSpoke).HandleVisibility = 'off';
                hSpoke(iSpoke).Parent = hGrid;
                hSpoke(iSpoke).LineStyle = ':';
                hSpoke(iSpoke).Color = [0.5 0.5 0.5];
            end
            
            % Annotate spokes in hours
            rt = rMax + 0.8*rInc;
            pm = char(177);
            hours = {' +2  ',' +4  ',' +6  ',' +8  ','+10  ',[pm,'12  '],'-10  ',' -8  ',' -6  ',' -4  ',' -2  ','  0  '};
            for iSpoke = length(th):-1:1
                hSpokeLbl(iSpoke,1) = text(rt*cst(iSpoke),rt*snt(iSpoke),hours(iSpoke));
                hSpokeLbl(iSpoke,1) .FontName = 'Arial';
                hSpokeLbl(iSpoke,1).FontUnits = 'pixels';
                hSpokeLbl(iSpoke,1).FontSize = 10;
                hSpokeLbl(iSpoke,1).HorizontalAlignment = 'center';
                hSpokeLbl(iSpoke,1).HandleVisibility = 'off';
                hSpokeLbl(iSpoke,1).Parent = hLabels;
            end
            top = hSpokeLbl(3).Extent(2)+hSpokeLbl(3).Extent(4);
            bottom = hSpokeLbl(9).Extent(2);
            left = hSpokeLbl(6).Extent(1);
            right = hSpokeLbl(12).Extent(1)+hSpokeLbl(12).Extent(3);
            outer = max(abs([top,bottom,left,right]));
            hAxes.YLim = [-outer,outer];
            hAxes.XLim = [-outer,outer];
            
            
            % Draw radial circles
            cos105 = cos(105*pi/180);
            sin105 = sin(105*pi/180);
            
            for iTick = (rMin + rInc):rInc:rMax
                hRadial = line(xunit*iTick,yunit*iTick);
                hRadial.Color = [0.5 0.5 0.5];
                hRadial.LineStyle = ':';
                hRadial.HandleVisibility = 'off';
                hRadial.Parent = hGrid;
            end
            % Make outer circle balck and solid.
            hRadial.Color = 'black';
            hRadial.LineStyle = '-';
            for iTick = (rMin + 2*rInc):2*rInc:rMax
                xText = (iTick)*cos105;
                yText = (iTick)*sin105;
                hTickLbl = text(xText,yText,num2str(iTick));
                hTickLbl.FontName = 'Arial';
                hTickLbl.FontUnits = 'pixels';
                hTickLbl.FontSize = 10;
                hTickLbl.VerticalAlignment = 'bottom';
                hTickLbl.HorizontalAlignment = 'center';
                hTickLbl.HandleVisibility = 'off';
                hTickLbl.Rotation = 15;
                hTickLbl.Parent = hLabels;
            end
        end % End of initPhasorAxes
        
        function plotPhasor(obj)
            vector = obj.Data.Phasor.Vector;
            Parent = obj.PhasorAxes;
            
            scale = 1.5;
            
            h = hggroup(Parent);
            
            % Make line slightly shorter than the vector.
            th = angle(vector);
            mag = abs(vector);
            offset = .05*scale;
            [x2,y2] = pol2cart(th,mag-offset);
            % Plot the line.
            hLine = line(Parent,[0,x2],[0,y2]);
            set(hLine,'Parent',h);
            hLine.LineWidth = 2;
            hLine.Color = obj.LightBlue;
            
            % Plot the arrowhead.
            % Constants that define arrowhead proportions
            xC = 0.05;
            yC = 0.02;
            
            % Create arrowhead points
            xx = [1,(1-xC*scale),(1-xC*scale),1].';
            yy = scale.*[0,(yC*scale),(-yC*scale),0].';
            arrow = xx + yy.*1i;
            
            % Calculate new vector with same angle but magnitude of 1
            th = angle(vector);
            [x2,y2] = pol2cart(th,1);
            vector2 = x2 + y2*1i;
            
            % Find difference between vectors
            dVec = vector2 - vector;
            
            % Calculate arrowhead points in transformed space.
            a = arrow * vector2.' - dVec;
            xA = real(a);
            yA = imag(a);
            cA = zeros(size(a));
            
            % Plot and format arrowhead.
            hHead = patch(Parent,xA,yA,cA);
            set(hHead,'EdgeColor','none');
            set(hHead,'FaceColor',get(hLine,'Color'));
            
            set(hHead,'Parent',h);
        end % End of plotPhasor
        
        %%
        function initMillerPanel(obj)
            oldUnits = obj.Body.Units;
            obj.Body.Units = 'pixels';
            
            x = obj.PhasorPanel.Position(1) + obj.PhasorPanel.Position(3) + 18;
            w = obj.Body.Position(3) - x;
            h = obj.PhasorPanel.Position(4);
            y = obj.PhasorPanel.Position(2);
            
            obj.MillerPanel = uipanel(obj.Body);
            obj.MillerPanel.BackgroundColor	= 'white';
            obj.MillerPanel.BorderType = 'none';
            obj.MillerPanel.Units = 'pixels';
            obj.MillerPanel.Position = [x,y,w,h];
            
            obj.initMillerAxes;
            
            hTitle = annotation(obj.MillerPanel,'textbox');
            hTitle.HorizontalAlignment = 'center';
            hTitle.LineStyle = 'none';
            hTitle.Units = 'pixels';
            hTitle.Position = [obj.MillerAxes.Position(1),h-23,obj.MillerAxes.Position(3),23];
            hTitle.FontName = 'Arial';
            hTitle.FontUnits = 'pixels';
            hTitle.FontSize = 12;
            hTitle.FontWeight = 'bold';
            hTitle.String = 'Average Day';
            
            obj.Body.Units = oldUnits;
        end % End of initMillerPanel
        
        function initMillerAxes(obj)
            x = 35;
            y = 30;
            w = 398;
            h = obj.MillerPanel.Position(4) - y - 23;
            
            obj.MillerAxes = axes(obj.MillerPanel);
            obj.MillerAxes.Units = 'pixels';
            obj.MillerAxes.ActivePositionProperty = 'position';
            obj.MillerAxes.Position = [x,y,w,h];
            
            obj.MillerAxes.XColor = 'black';
            obj.MillerAxes.YColor = 'black';
            
            obj.MillerAxes.FontUnits = 'pixels';
            obj.MillerAxes.FontSize = 10;
            obj.MillerAxes.FontName = 'Arial';
            
            obj.MillerAxes.XLim = [0,24];
            obj.MillerAxes.XTick = 0:2:24;
            obj.MillerAxes.YLim = [0,1];
            obj.MillerAxes.YTick = 0:0.1:1;
            
            obj.MillerAxes.TickDir = 'out';
            obj.MillerAxes.XGrid = 'on';
            obj.MillerAxes.YGrid = 'on';
            obj.MillerAxes.GridLineStyle = ':';
            obj.MillerAxes.GridColor = [0.5,0.5,0.5];
            obj.MillerAxes.GridAlpha = 1;
            
            ylabel(obj.MillerAxes,'CS and AI');
            xlabel(obj.MillerAxes,'Time of Day (hours)');
            
        end
        
        function plotMiller(obj)
            hold(obj.MillerAxes,'on');
            
            t = (0:1/6:24)';
            
            CS = obj.Data.MillerCircadianStimulus;
            CS(isnan(CS)) = 0;
            CS = [CS;CS(1)];
            
            AI = obj.Data.MillerActivityIndex;
            AI(isnan(AI)) = 0;
            AI = [AI;AI(1)];
            
            hCS = area(obj.MillerAxes,t,CS);
            hCS.FaceColor = obj.LightBlue;
            hCS.EdgeColor = 'none';
            hCS.DisplayName = 'Circadian Stimulus (CS)';
            
            hAI = plot(obj.MillerAxes,t,AI);
            hAI.Color = 'black';
            hAI.LineWidth = 1;
            hAI.DisplayName = 'Activity Index (AI)';
            
            hLegend = legend(obj.MillerAxes,'show');
            hLegend.Box = 'off';
            hLegend.Orientation = 'horizontal';
            hLegend.Location = 'northoutside';
            hLegend.FontSize = 8;
            
            hLine = plot(obj.MillerAxes,[0,0,24],[1,0,0],'Color','black','LineWidth',0.5);
            
            hold(obj.MillerAxes,'off');
        end
        
        %%
        function initTextPanel(obj)
            oldUnits = obj.Body.Units;
            obj.Body.Units = 'pixels';
            
            x = obj.PhasorPanel.Position(1);
            w = obj.PhasorPanel.Position(3);
            h = obj.PhasorPanel.Position(2) - 18;
            y = 0;
            
            obj.TextPanel = uipanel(obj.Body);
            obj.TextPanel.BorderType = 'none';
            obj.TextPanel.BackgroundColor = 'white';
            obj.TextPanel.Units = 'pixels';
            obj.TextPanel.Position = [x,y,w,h];
            
            hLabel = annotation(obj.TextPanel,'textbox');
            hLabel.LineStyle = 'none';
            hLabel.FitBoxToText = 'off';
            hLabel.Units = 'pixels';
            hLabel.Position = [0,1,120,h-23];
            hLabel.Margin = 0;
            hLabel.FontUnits = 'pixels';
            hLabel.FontSize = 12;
            hLabel.FontName = 'Arial';
            hLabel.HorizontalAlignment = 'right';
            hLabel.VerticalAlignment = 'baseline';
            hLabel.String = {...
                'Phasor Magnitude:';...
                'Phasor Angle:';...
                '';...
                'Interdaily Stability (IS):';...
                'Intradaily Variability (IV):';...
                '';...
                'Mean Waking ';'Activity Index (AI):';...
                '';...
                'Mean Waking ';'Circadian Stimulus (CS):';...
                '';...
                'Geometric Mean Waking ';'Photopic Illuminance:'};
            
            hUnits = annotation(obj.TextPanel,'textbox');
            hUnits.LineStyle = 'none';
            hUnits.FitBoxToText = 'off';
            hUnits.Units = 'pixels';
            hUnits.Position = [175,1,w-175,h-23];
            hUnits.Margin = 0;
            hUnits.FontUnits = 'pixels';
            hUnits.FontSize = 12;
            hUnits.FontName = 'Arial';
            hUnits.HorizontalAlignment = 'left';
            hUnits.VerticalAlignment = 'baseline';
            hUnits.String = {...
                '';...
                'hours';...
                '';...
                '';...
                '';...
                '';...
                '';...
                '';...
                '';...
                '';...
                '';...
                '';...
                '';...
                'lux'};
            
            obj.Body.Units = oldUnits;
        end % End of initTextPanel
        
        function plotText(obj)
            
            h = obj.TextPanel.Position(4);
            
            hText = annotation(obj.TextPanel,'textbox');
            hText.LineStyle = 'none';
            hText.FitBoxToText = 'off';
            hText.Units = 'pixels';
            hText.Position = [135,1,35,h-23];
            hText.Margin = 0;
            hText.FontUnits = 'pixels';
            hText.FontSize = 12;
            hText.FontName = 'Arial';
            hText.HorizontalAlignment = 'right';
            hText.VerticalAlignment = 'baseline';
            hText.String = sprintf('%.2f\n%.2f\n\n%.2f\n%.2f\n\n\n%.2f\n\n\n%.2f\n\n\n%.2f',...
                obj.Data.Phasor.Magnitude,...
                obj.Data.Phasor.Angle.hours,...
                obj.Data.InterdailyStability,...
                obj.Data.IntradailyVariability,...
                obj.Data.MeanWakingActivityIndex,...
                obj.Data.MeanWakingCircadianStimulus,...
                obj.Data.MeanWakingIlluminance);
        end
        
        %%
        function initDistributionPanel(obj)
            oldUnits = obj.Body.Units;
            obj.Body.Units = 'pixels';
            
            x = obj.MillerPanel.Position(1);
            w = obj.MillerPanel.Position(3);
            h = obj.TextPanel.Position(4);
            y = 0;
            
            obj.DistributionPanel = uipanel(obj.Body);
            obj.DistributionPanel.BorderType = 'none';
            obj.DistributionPanel.Units = 'pixels';
            obj.DistributionPanel.Position = [x,y,w,h];
            
            hTitle = annotation(obj.DistributionPanel,'textbox');
            hTitle.HorizontalAlignment = 'center';
            hTitle.LineStyle = 'none';
            obj.DistributionPanel.BackgroundColor = 'white';
            hTitle.Units = 'pixels';
            hTitle.Position = [35,h-23,398,23];
            hTitle.FontName = 'Arial';
            hTitle.FontUnits = 'pixels';
            hTitle.FontSize = 12;
            hTitle.FontWeight = 'bold';
            hTitle.String = 'Normal Probability Distribution';
            
            obj.initMagnitudeDistAxes;
            obj.initAngleDistAxes;
            
            legendObjects = [obj.MagnitudeDistHist,obj.MagnitudeDistCurve];
            hLegend = legend(legendObjects,'Healthy Adults','Normal Fit');
            hLegend.Orientation = 'horizontal';
            hLegend.Box = 'off';
            hLegend.Units = 'pixels';
            xLegend = (398 - hLegend.Position(3))/2 +35;
            hLegend.Position(1) = xLegend;
            hLegend.Position(2) = 145;
            hLegend.FontSize = 8;
            hLegend.FontName = 'Arial';
            
            hFootnote = annotation(obj.DistributionPanel,'textbox');
            hFootnote.HorizontalAlignment = 'center';
            hFootnote.VerticalAlignment = 'baseline';
            hFootnote.LineStyle = 'none';
            hFootnote.Units = 'pixels';
            hFootnote.Position = [35,1,398,20];
            hFootnote.Margin = 0;
            hFootnote.FontName = 'Arial';
            hFootnote.FontUnits = 'pixels';
            hFootnote.FontSize = 10;
            hFootnote.String = '*Rotating shift nurses working 1, 2, & 3 nights per week.';
            
            
            obj.Body.Units = oldUnits;
        end % End of initDistributionPanel
        
        function initMagnitudeDistAxes(obj)
            % Load data
            Input = load('combinedPhasorResults.mat');
            
            phasorMagnitudeArray = Input.phasorMagnitudeArray;
            
            x = 35;
            y = 45;
            w = 190;
            h = 100;
            
            % Create axes to plot on
            obj.MagnitudeDistAxes = axes(obj.DistributionPanel);
            obj.MagnitudeDistAxes.Units = 'pixels';
            obj.MagnitudeDistAxes.ActivePositionProperty = 'position';
            obj.MagnitudeDistAxes.Position = [x,y,w,h];
            obj.MagnitudeDistAxes.XLim = [0,1];
            obj.MagnitudeDistAxes.YLim = [0,5];
            obj.MagnitudeDistAxes.XTick = 0:.25:1;
            obj.MagnitudeDistAxes.YTick = 0:1:5;
            obj.MagnitudeDistAxes.TickDir = 'out';
            obj.MagnitudeDistAxes.Layer = 'top';
            obj.MagnitudeDistAxes.FontUnits = 'pixels';
            obj.MagnitudeDistAxes.FontSize = 10;
            obj.MagnitudeDistAxes.FontName = 'Arial';
            
            obj.MagnitudeDistAxes.XColor = 'black';
            obj.MagnitudeDistAxes.YColor = 'black';
            
            hold(obj.MagnitudeDistAxes,'on');
            
            % Plot normalized histogram
            nBins = floor(sqrt(numel(phasorMagnitudeArray)));
            [nElements,xCenters] = hist(phasorMagnitudeArray,nBins);
            deltaX = xCenters(2) - xCenters(1);
            obj.MagnitudeDistHist = bar(xCenters,nElements/sum(nElements*deltaX),1);
            set(obj.MagnitudeDistHist,'FaceColor',obj.LightBlue,'EdgeColor','w');
            
            
            % Plot density curve
            load('magnitudeCurve.mat','xArray','yArray');
            obj.MagnitudeDistCurve = plot(xArray,yArray,'Color','black','LineWidth',1);
            
            % Label axes
            xlabel('Phasor Magnitude');
            ylabel('Density');
            
            phasorMagnitudeArray	= [0.296043478, 0.121222222, 0.0480625];
            for iN = 1:3
                xLine = [phasorMagnitudeArray(iN),phasorMagnitudeArray(iN)];
                yLine = [0,obj.MagnitudeDistAxes.YLim(2)];
                hLine = plot(obj.MagnitudeDistAxes,xLine,yLine);
                hLine.Color = [0.5,0.5,0.5];
                hLine.LineWidth = 0.5;
                hLine.LineStyle = ':';
                uistack(hLine,'bottom');
                
                str = sprintf('*%i ',iN);
                yLabel = 1.03*yLine(2);
                hLabel = text(obj.MagnitudeDistAxes,xLine(1),yLabel,str);
                hLabel.FontName = 'Arial';
                hLabel.FontUnits = 'pixels';
                hLabel.FontSize = 10;
                hLabel.VerticalAlignment = 'baseline';
                hLabel.HorizontalAlignment = 'center';
            end
            
            hold(obj.MagnitudeDistAxes,'off');
        end
        
        function initAngleDistAxes(obj)
            % Load data
            Input = load('combinedPhasorResults.mat');
            
            phasorAngleArray = Input.phasorAngleArray;
            
            x = 243;
            y = 45;
            w = 190;
            h = 100;
            
            % Create axes to plot on
            obj.AngleDistAxes = axes(obj.DistributionPanel);
            obj.AngleDistAxes.Units = 'pixels';
            obj.AngleDistAxes.ActivePositionProperty = 'position';
            obj.AngleDistAxes.Position = [x,y,w,h];
            obj.AngleDistAxes.YAxisLocation = 'right';
            obj.AngleDistAxes.XLim = [-6,6];
            obj.AngleDistAxes.YLim = [0,0.5];
            obj.AngleDistAxes.XTick = -6:3:6;
            obj.AngleDistAxes.YTick = 0:0.1:0.5;
            obj.AngleDistAxes.TickDir = 'out';
            obj.AngleDistAxes.Layer = 'top';
            obj.AngleDistAxes.FontUnits = 'pixels';
            obj.AngleDistAxes.FontSize = 10;
            obj.AngleDistAxes.FontName = 'Arial';
            
            obj.AngleDistAxes.XColor = 'black';
            obj.AngleDistAxes.YColor = 'black';
            
            hold(obj.AngleDistAxes,'on');
            
            % Plot normalized histogram
            nBins = floor(sqrt(numel(phasorAngleArray)));
            [nElements,xCenters] = hist(phasorAngleArray,nBins);
            deltaX = xCenters(2) - xCenters(1);
            hBar = bar(xCenters,nElements/sum(nElements*deltaX),1);
            set(hBar,'FaceColor',obj.LightBlue,'EdgeColor','w');
            
            % Plot density curve
            load('angleCurve.mat','xArray','yArray');
            obj.AngleDistCurve = plot(xArray,yArray,'Color','black','LineWidth',1);
            
            % Label axes
            xlabel('Phasor Angle (hours)');
            ylabel('Density');
            
            phasorAngleArray = [1.215217391, 2.319444444, 4.28];
            for iN = 1:3
                xLine = [phasorAngleArray(iN),phasorAngleArray(iN)];
                yLine = [0,obj.AngleDistAxes.YLim(2)];
                hLine = plot(obj.AngleDistAxes,xLine,yLine);
                hLine.Color = [0.5,0.5,0.5];
                hLine.LineWidth = 0.5;
                hLine.LineStyle = ':';
                uistack(hLine,'bottom');
                
                str = sprintf('*%i ',iN);
                yLabel = 1.03*yLine(2);
                hLabel = text(obj.AngleDistAxes,xLine(1),yLabel,str);
                hLabel.FontName = 'Arial';
                hLabel.FontUnits = 'pixels';
                hLabel.FontSize = 10;
                hLabel.VerticalAlignment = 'baseline';
                hLabel.HorizontalAlignment = 'center';
            end
            
            hold(obj.AngleDistAxes,'off');
        end % End of initAngleDistAxes
        
        function plotDist(obj)
            obj.plotOnCurve(obj.MagnitudeDistAxes,obj.Data.Phasor.Magnitude,'Subject',obj.MagnitudeDistCurve.XData,obj.MagnitudeDistCurve.YData);
            obj.plotOnCurve(obj.AngleDistAxes,obj.Data.Phasor.Angle.hours,'Subject',obj.AngleDistCurve.XData,obj.AngleDistCurve.YData);
        end
    end
    
    methods (Static, Access = protected)
        function plotOnCurve(hAxis,yValue,noteText,xArray,yArray)
            hold(hAxis,'on');
            
            xLimits = get(hAxis,'XLim');
            yLimits = get(hAxis,'YLim');
            
            axisPosition = getpixelposition(hAxis,true);
            pixels2dataY = (yLimits(2) - yLimits(1))/axisPosition(4);
            pixels2dataX = (xLimits(2) - xLimits(1))/axisPosition(3);
            
            dX = abs(xArray - yValue);
            [~,idx] = min(dX);
            x = yValue;
            y = yArray(idx);
            
            color = 'red';
            
            % Plot a dot
            markerSize = 6;
            plot(hAxis,x,y,'o','Color',color,'MarkerSize',markerSize,'LineWidth',1.5);
            
            markerOffsetY = markerSize*pixels2dataY;
            markerOffsetX = markerSize*pixels2dataX;
            
            % Plot text
            hText = text(hAxis,x,y,noteText,'Color',color);
            hText.FontName = 'Arial';
            hText.FontUnits = 'pixels';
            hText.FontSize = 12;
            hText.FontWeight = 'bold';
            
            [~,yMaxIdx] = max(yArray);
            xPeakY = xArray(yMaxIdx);
            
            if x < xPeakY
                hText.HorizontalAlignment = 'Right';
                xT = x - markerOffsetX;
                yT = y + markerOffsetY;
            elseif x > xPeakY
                set(hText,'HorizontalAlignment','Left')
                xT = x + markerOffsetX;
                yT = y + markerOffsetY;
            else
                set(hText,'HorizontalAlignment','Center')
                xT = x;
                yT = y + markerOffsetY;
            end
            hText.Position(1) = xT;
            hText.Position(2) = yT;
            
            hold(hAxis,'off');
        end
        
    end
    
end

