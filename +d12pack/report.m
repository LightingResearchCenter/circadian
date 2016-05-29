classdef report < matlab.mixin.SetGet
    %REPORT Summary of this class goes here
    %   Detailed explanation goes here
    
    %%
    properties % (Access = public)
        Figure
        Margin = struct('Left',36,'Right',36,'Top',18,'Bottom',36);
        Header
        Footer
        Body
        DateGenerate = datetime('now','TimeZone','local');
        LRClogo
        RPIlogo
    end
    
    properties (SetObservable)
        Type = 'Report';
        PageNumber = [1,1];
    end
    
    properties (Dependent)
        Title
        Units
        HeaderHeight
        FooterHeight
    end
    
    properties (Dependent, SetObservable)
        PaperType
        Orientation
    end
    
    properties (Dependent, GetAccess = public, SetAccess = private)
        Width
        Height
    end
    
    properties (Access = protected)
        DefaultHeaderHeight = 54;
        DefaultFooterHeight = 54;
        TitleBox
        FooterBox
        PageNumBox
    end
    
    %%
    methods
        %% Class constructor
        function obj = report
            addlistener(obj,'Type','PostSet',@obj.footerTextCallback);
            addlistener(obj,'PageNumber','PostSet',@obj.pageNumCallback);
            addlistener(obj,'PaperType','PostSet',@obj.resizeCallback);
            addlistener(obj,'Orientation','PostSet',@obj.resizeCallback);
            
            obj.Figure = figure;
            obj.Figure.Renderer = 'painters';
            obj.Figure.Resize = 'off';
            obj.Figure.ToolBar = 'none';
            obj.Figure.DockControls = 'off';
            obj.Figure.Color = 'white';
            obj.Figure.Units = 'pixels';
            obj.PaperType = 'usletter';
            obj.Orientation = 'portrait';
            
            obj = initHeader(obj);
            obj = initFooter(obj);
            obj = initBody(obj);
        end % End of constructor method
        
        %% Title
        function obj = set.Title(obj,Title)
            if ishandle(obj.TitleBox)
                obj.TitleBox.String = Title;
            end
        end % End of set
        function Title = get.Title(obj)
            if ishandle(obj.TitleBox)
                Title = obj.TitleBox.String;
            end
        end % End of get
        
        %% Units
        function obj = set.Units(obj,Units)
            obj.Figure.Units = Units;
        end % End of set
        function Units = get.Units(obj)
            Units = obj.Figure.Units;
        end % End of get
        
        %% PaperType
        function obj = set.PaperType(obj,PaperType)
            obj.Figure.PaperType = PaperType;
        end % End of set
        function PaperType = get.PaperType(obj)
            PaperType = obj.Figure.PaperType;
        end % End of get
        
        %% Orientation
        function obj = set.Orientation(obj,Orientation)
            obj.Figure.PaperOrientation = Orientation;
        end % End of set
        function Orientation = get.Orientation(obj)
            Orientation = obj.Figure.PaperOrientation;
        end % End of get
        
        %% HeaderHeight
        function obj = set.HeaderHeight(obj,HeaderHeight)
            if ishandle(obj.Header)
                obj.Header.Position(4) = HeaderHeight;
            else
                obj.DefaultHeaderHeight = HeaderHeight;
            end
        end % End of set
        function HeaderHeight = get.HeaderHeight(obj)
            if ishandle(obj.Header)
                HeaderHeight = obj.Header.Position(4);
            else
                HeaderHeight = obj.DefaultHeaderHeight;
            end
        end % End of get
        
        %% FooterHeight
        function obj = set.FooterHeight(obj,FooterHeight)
            if ishandle(obj.Footer)
                obj.Footer.Position(4) = FooterHeight;
            else
                obj.DefaultFooterHeight = FooterHeight;
            end
        end % End of set
        function FooterHeight = get.FooterHeight(obj)
            if ishandle(obj.Footer)
                FooterHeight = obj.Footer.Position(4);
            else
                FooterHeight = obj.DefaultFooterHeight;
            end
        end % End of get
        
        %% Width
        function Width = get.Width(obj)
            Width = obj.Figure.Position(3);
        end % End of get
        
        %% Height
        function Height = get.Height(obj)
            Height = obj.Figure.Position(4);
        end % End of get
        
        %% Header
        function obj = initHeader(obj)
            obj.Header                  = uipanel;
            obj.Header.Tag              = 'header';
            obj.Header.BorderType       = 'none';
            obj.Header.BackgroundColor	= 'white';
            
            obj.TitleBox = annotation(obj.Header,'textbox');
            obj.TitleBox.LineStyle = 'none';
            obj.TitleBox.HorizontalAlignment = 'center';
            obj.TitleBox.VerticalAlignment = 'middle';
            obj.TitleBox.FontUnits = 'pixels';
            obj.TitleBox.FontSize = 16;
            obj.TitleBox.FontName = 'Arial';
            obj.TitleBox.FontWeight = 'bold';
            obj.TitleBox.String = obj.Title;
            
            obj.positionHeader;
        end % End of initHeader
        
        function obj = positionHeader(obj)
            oldUnits = obj.Units;
            obj.Units = 'pixels';
            
            x = obj.Margin.Left;
            h = obj.DefaultHeaderHeight;
            y = obj.Height - obj.Margin.Top - h;
            w = obj.Width - obj.Margin.Left - obj.Margin.Right;
            
            obj.Header.Units	= 'pixels';
            obj.Header.Position	= [x,y,w,h];
            
            obj.TitleBox.Units = 'pixels';
            obj.TitleBox.Position = [0,0,w,h];
            
            obj.Units = oldUnits;
        end % End of positionHeader
        
        %% Footer
        function obj = initFooter(obj)
            obj.Footer          = uipanel;
            obj.Footer.Tag      = 'footer';
            obj.Footer.BorderType = 'none';
            obj.Footer.BackgroundColor = 'white';
                        
            nowStr = datestr(obj.DateGenerate,'yyyy mmmm dd, HH:MM');
            footerStr = {obj.Type;['Generated: ',nowStr]};
            
            obj.FooterBox = annotation(obj.Footer,'textbox');
            obj.FooterBox.LineStyle = 'none';
            obj.FooterBox.HorizontalAlignment = 'center';
            obj.FooterBox.VerticalAlignment = 'top';
            obj.FooterBox.FontUnits = 'pixels';
            obj.FooterBox.FontSize = 16;
            obj.FooterBox.FontName = 'Arial';
            obj.FooterBox.String = footerStr;
            
            obj.PageNumBox = annotation(obj.Footer,'textbox');
            obj.PageNumBox.LineStyle = 'none';
            obj.PageNumBox.HorizontalAlignment = 'center';
            obj.PageNumBox.VerticalAlignment = 'bottom';
            obj.PageNumBox.FontUnits = 'pixels';
            obj.PageNumBox.FontSize = 11;
            obj.PageNumBox.FontName = 'Arial';
            obj.PageNumBox.String = sprintf('%d of %d',obj.PageNumber(1),obj.PageNumber(2));
            
            obj.initLrcLogo;
            obj.initRpiLogo;
            
            obj.positionFooter;
        end % End of initFooter
        
        % LRC logo
        function initLrcLogo(obj)
            [A,map,alpha] = imread('lrcLogo.png'); % Read in our image.
            
            obj.LRClogo = axes(obj.Footer); % Make a new axes for logo
            
            hLogo = image(obj.LRClogo,A);
            hLogo.AlphaData = alpha; % Set alpha channel
            
            obj.LRClogo.DataAspectRatio = [1, 1, 1];
            obj.LRClogo.Visible = 'off'; % Set axes visibility
        end % End of initLrcLogo
        
        % RPI Logo
        function initRpiLogo(obj)
            [A,map,alpha] = imread('rpiLogo.png'); % Read in our image.
            
            obj.RPIlogo = axes(obj.Footer); % Make a new axes for logo
            
            hLogo = image(obj.RPIlogo,A);
            hLogo.AlphaData = alpha; % Set alpha channel
            
            obj.RPIlogo.DataAspectRatio = [1, 1, 1];
            obj.RPIlogo.Visible = 'off'; % Set axes visibility
        end
        
        function positionFooter(obj)
            oldUnits = obj.Units;
            obj.Units = 'pixels';
            
            x = obj.Margin.Left;
            y = obj.Margin.Bottom;
            w = obj.Width - obj.Margin.Left - obj.Margin.Right;
            h = obj.DefaultFooterHeight;
            
            obj.Footer.Units	= 'pixels';
            obj.Footer.Position	= [x,y,w,h];
            
            obj.FooterBox.Units = 'pixels';
            obj.FooterBox.Position = [0,0,w,h];
            
            obj.PageNumBox.Units = 'pixels';
            obj.PageNumBox.Position = [0,0,w,h];
            
            obj.LRClogo.Units = 'pixels';
            x = 0;
            h = 36;
            w = ceil(518*h/150);
            y = floor((obj.Footer.Position(4) - h)/2);
            obj.LRClogo.Position = [x,y,w,h];
            
            obj.RPIlogo.Units = 'pixels';
            h = 17;
            w = 100; %ceil(384*h/71);
            x = obj.Footer.Position(3) - w;
            y = floor((obj.Footer.Position(4) - h)/2);
            obj.RPIlogo.Position = [x,y,w,h];
            
            obj.Units = oldUnits;
        end % End of positionFooter
        
        %% Body
        function obj = initBody(obj)
            obj.Body                    = uipanel;
            obj.Body.BorderType         = 'none';
            obj.Body.BackgroundColor    = 'white';
            
            obj.positionBody;
        end % End of initBody
        
        function obj = positionBody(obj)
            oldUnits = obj.Units;
            obj.Units = 'pixels';
            
            x = obj.Margin.Left;
            y = obj.Footer.Position(2) + obj.Footer.Position(4) + 9;
            w = obj.Width - obj.Margin.Left - obj.Margin.Right;
            h = obj.Header.Position(2) - y;
            
            obj.Body.Units      = 'pixels';
            obj.Body.Position	= [x,y,w,h];
            
            obj.Units = oldUnits;
        end % End of positionBody
        
    end
    
    methods (Static)
        %% Update Footer text on event callback
        function footerTextCallback(src,evnt)
            evnt.AffectedObject.DateGenerate = datetime('now','TimeZone','local');
            nowStr = datestr(evnt.AffectedObject.DateGenerate,'yyyy mmmm dd, HH:MM');
            footerStr = {evnt.AffectedObject.Type;['Generated: ',nowStr]};
            evnt.AffectedObject.FooterBox.String = footerStr;
        end
        
        %% Update Page number on event callback
        function pageNumCallback(src,evnt)
            thisPage = evnt.AffectedObject.PageNumber(1);
            ofPages = evnt.AffectedObject.PageNumber(2);
            pageStr = sprintf('%d of %d',thisPage,ofPages);
            evnt.AffectedObject.PageNumBox.String = pageStr;
        end
        
        %% Resize page callback
        function resizeCallback(src,evnt)
            oldUnits = evnt.AffectedObject.Units;
            oldPaperUnits = evnt.AffectedObject.Figure.PaperUnits;
            evnt.AffectedObject.Units = 'pixels';
            evnt.AffectedObject.Figure.PaperUnits = 'points';
            
            r = groot;
            PaperX = round((r.MonitorPositions(1,3) - evnt.AffectedObject.Figure.PaperSize(1))/2);
            PaperY = round((r.MonitorPositions(1,4) - evnt.AffectedObject.Figure.PaperSize(2))/2);
            evnt.AffectedObject.Figure.Position = [PaperX,PaperY,evnt.AffectedObject.Figure.PaperSize];
            
            dim = evnt.AffectedObject.Figure.PaperSize;
            evnt.AffectedObject.Figure.PaperPosition = [0,1,dim(1)-1,dim(2)-1];
            
            % Reposition Header (if it exists)
            if ishandle(evnt.AffectedObject.Header)
                if isvalid(evnt.AffectedObject.Header)
                    evnt.AffectedObject.positionHeader;
                end
            end
            
            % Reposition Footer (if it exists)
            if ishandle(evnt.AffectedObject.Footer)
                if isvalid(evnt.AffectedObject.Footer)
                    evnt.AffectedObject.positionFooter;
                end
            end
            
            % Reposition Body (if it exists)
            if ishandle(evnt.AffectedObject.Body)
                if isvalid(evnt.AffectedObject.Body)
                    evnt.AffectedObject.positionBody;
                end
            end
            
            evnt.AffectedObject.Units = oldUnits;
            evnt.AffectedObject.Figure.PaperUnits = oldPaperUnits;
        end
    end
end

