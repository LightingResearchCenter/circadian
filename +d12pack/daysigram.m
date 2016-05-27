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
            obj.Type = 'Daysigram Report';
            if nargin == 0
                nPages = 1;
            else
                src = varargin{1};
                Title = varargin{2};
                if nargin == 4;
                    StartDate = varargin{3};
                    EndDate = varargin{4};
                else
                    StartDate = src.Time(1);
                    EndDate = src.Time(end);
                end
                idxLimits = src.Time >= StartDate & src.Time <= EndDate;
                t = src.Time(idxLimits);
                [y,m,d] = ymd(t);
                Dates = datetime(unique([y(:),m(:),d(:)],'rows'),'TimeZone',src.Time(1).TimeZone);
                nDates = numel(Dates);
                nPages = ceil(nDates/10);
                
                srcClass = class(src);
            end
            
            obj(nPages,1) = obj;
            
            if exist('src','var') == 1
                iDate = 1;
                for iPage = 1:nPages
                    obj(iPage,1).Title = Title;
                    obj(iPage,1).PageNumber = [iPage,nPages];
                    obj(iPage,1).initAxes;
                    obj(iPage,1).initLegend;
                    obj(iPage,1).Type = 'Daysigram Report';
                    
                    while iDate <= iPage*10
                        if iDate <= nDates
                            % Select the axes that will be plotted to
                            iAx = mod(iDate,10);
                            if iAx == 0
                                iAx = 10;
                            end
                            
                            idxDate = src.Time >= Dates(iDate) & src.Time < Dates(iDate) + caldays(1);
                            idx  = idxDate & idxLimits;
                            Time = src.Time(idx);
                            ActivityIndex = src.ActivityIndex(idx);
                            CircadianStimulus = src.CircadianStimulus(idx);
                            Observation = src.Observation(idx);
                            Error = src.Error(idx);
                            
                            switch srcClass
                                case 'd12pack.HumanData'
                                    Compliance = src.Compliance(idx);
                                    InBed = src.InBed(idx);
                                    AtWork = src.AtWork(idx);
                                    
                                    obj(iPage,1).plotDay(...
                                        obj(iPage,1).Axes(iAx),...
                                        obj(iPage,1).SubAxes(iAx),...
                                        Time,...
                                        ActivityIndex,...
                                        CircadianStimulus,...
                                        Observation,...
                                        Error,...
                                        Compliance,...
                                        InBed,...
                                        AtWork);
                                case 'd12pack.MobileData'
                                    obj(iPage,1).plotDay(...
                                        obj(iPage,1).Axes(iAx),...
                                        obj(iPage,1).SubAxes(iAx),...
                                        Time,...
                                        ActivityIndex,...
                                        CircadianStimulus,...
                                        Observation,...
                                        Error);
                                case 'd12pack.StaticData'
                                    obj(iPage,1).plotDay(...
                                        obj(iPage,1).Axes(iAx),...
                                        obj(iPage,1).SubAxes(iAx),...
                                        Time,...
                                        ActivityIndex,...
                                        CircadianStimulus,...
                                        Observation,...
                                        Error);
                                otherwise
                                    error('Class is not supported');
                            end % End of switch
                        end
                        iDate = iDate + 1;
                    end % End of while
                end % End of for
            end % End of if
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
                obj.SubAxes(iAx).Position = [x,y,w,h];
                
                obj.SubAxes(iAx).YLimMode = 'manual';
                obj.SubAxes(iAx).YLim = [0,1];
                obj.SubAxes(iAx).XLimMode = 'manual';
                obj.SubAxes(iAx).XLim = [0,24];
                obj.SubAxes(iAx).Visible = 'off';
                
                obj.Axes(iAx) = axes(obj.Body);
                obj.Axes(iAx).Units = 'pixels';
                obj.Axes(iAx).Position = [x,y,w,h];
                
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
            hBox.LineWidth = 0.5;
            hBoxAxes.Visible = 'off';
        end % End of initAxes
        
        %% Legend
        function initLegend(obj)
            x = 36;
            y = 0;
            w = 468;
            h = 40;
            
            hLegendAxes = axes(obj.Body); % Make a new axes for logo
            hLegendAxes.Visible = 'off'; % Set axes visibility
            hLegendAxes.Units = 'pixels';
            hLegendAxes.Position = [x,y,w,h];
            hLegendAxes.XLimMode = 'manual';
            hLegendAxes.XLim = [0,468];
            hLegendAxes.YLimMode = 'manual';
            hLegendAxes.YLim = [0,36];
            
            w = 13;
            h = 10;
            
            a = 17;
            b = 2;
            
            a2 = 17;
            b2 = -3;
            
            blue   = [180, 211, 227]/255; % circadian stimulus
            grey   = [226, 226, 226]/255; % excluded data
            red    = [255, 215, 215]/255; % error
            yellow = [255, 255, 191]/255; % noncompliance
            purple = [186, 141, 186]/255; % in bed
            green  = [124, 197, 118]/255; % at work
            
            % Circadian Stimulus
            x = 6;
            y = 25;
            dim = [x,y,w,h];
            hRec = rectangle(hLegendAxes,'Position',dim,'FaceColor',blue);
            hTxt = text(hLegendAxes,x+a,y+b,'Circadian Stimulus (CS)');
            hTxt.VerticalAlignment = 'baseline';
            hTxt.FontName = 'Arial';
            hTxt.FontSize = 8;
            
            % Activity Index
            x = 135;
            y = 30;
            hLin = line(hLegendAxes,[x,x+w],[y,y],'LineWidth',1,'Color','black');
            hTxt = text(hLegendAxes,x+a2,y+b2,'Activity Index (AI)');
            hTxt.VerticalAlignment = 'baseline';
            hTxt.FontName = 'Arial';
            hTxt.FontSize = 8;
            
            % Excluded Data
            x = 266;
            y = 25;
            dim = [x,y,w,h];
            hRec = rectangle(hLegendAxes,'Position',dim,'FaceColor',grey);
            hTxt = text(hLegendAxes,x+a,y+b,'Excluded Data');
            hTxt.VerticalAlignment = 'baseline';
            hTxt.FontName = 'Arial';
            hTxt.FontSize = 8;
            
            % Device Error
            x = 396;
            y = 25;
            dim = [x,y,w,h];
            hRec = rectangle(hLegendAxes,'Position',dim,'FaceColor',red);
            hTxt = text(hLegendAxes,x+a,y+b,'Device Error');
            hTxt.VerticalAlignment = 'baseline';
            hTxt.FontName = 'Arial';
            hTxt.FontSize = 8;
            
            % Noncompliance
            x = 6;
            y = 6;
            dim = [x,y,w,h];
            hRec = rectangle(hLegendAxes,'Position',dim,'FaceColor',yellow);
            hTxt = text(hLegendAxes,x+a,y+b,'Noncompliance');
            hTxt.VerticalAlignment = 'baseline';
            hTxt.FontName = 'Arial';
            hTxt.FontSize = 8;
            
            % Reported in Bed
            x = 135;
            y = 6;
            dim = [x,y,w,h];
            hRec = rectangle(hLegendAxes,'Position',dim,'FaceColor',purple);
            hTxt = text(hLegendAxes,x+a,y+b,'Reported in Bed');
            hTxt.VerticalAlignment = 'baseline';
            hTxt.FontName = 'Arial';
            hTxt.FontSize = 8;
            
            % Reported at Work
            x = 266;
            y = 6;
            dim = [x,y,w,h];
            hRec = rectangle(hLegendAxes,'Position',dim,'FaceColor',green);
            hTxt = text(hLegendAxes,x+a,y+b,'Reported at Work');
            hTxt.VerticalAlignment = 'baseline';
            hTxt.FontName = 'Arial';
            hTxt.FontSize = 8;
            
        end % End of initLegend
        
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
                hBed.FaceColor = [186, 141, 186]/255;
                hBed.EdgeColor = 'none';
                hBed.DisplayName = 'Reported in Bed';
                
                % Plot and format at Work
                hWrk = area(hSubAxes,Hours,AtWork);
                hWrk.FaceColor = [124, 197, 118]/255;
                hWrk.EdgeColor = 'none';
                hWrk.DisplayName = 'Reported at Work';
                
                % Plot and format Noncompliance
                hNC = area(hSubAxes,Hours,~Compliance);
                hNC.FaceColor = [255, 255, 191]/255;
                hNC.EdgeColor = 'none';
                hNC.DisplayName = 'Noncompliance';
            end
            
            % Plot and format Excluded Data
            hExc = area(hSubAxes,Hours,~Observation);
            hExc.FaceColor = [226, 226, 226]/255;
            hExc.EdgeColor = 'none';
            hExc.DisplayName = 'Excluded Data';
            
            % Plot and format Device Error
            hErr = area(hSubAxes,Hours,Error);
            hErr.FaceColor = [255, 215, 215]/255;
            hErr.EdgeColor = 'none';
            hErr.DisplayName = 'Device Error';
            
            % Plot and format Circadian Stimulus
            hCS = area(hAxes,Hours,CircadianStimulus);
            hCS.FaceColor = [180, 211, 227]/255;
            hCS.EdgeColor = 'none';
            hCS.DisplayName = 'Circadian Stimulus (CS)';
            
            % Plot and format Activity Index
            hAI = plot(hAxes,Hours,ActivityIndex);
            hAI.Color = 'black';
            hAI.LineWidth = 1;
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

