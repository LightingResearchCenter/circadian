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
    end
    
    properties (SetObservable)
        Type = 'Report';
        PageNumber = [1,1];
    end
    
    properties (Dependent)
        Title
        Units
        PaperType
        Orientation
        HeaderHeight
        FooterHeight
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
            obj.resize;
        end % End of set
        function PaperType = get.PaperType(obj)
            PaperType = obj.Figure.PaperType;
        end % End of get
        
        %% Orientation
        function obj = set.Orientation(obj,Orientation)
            obj.Figure.PaperOrientation = Orientation;
            obj.resize;
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
        
        %% Resize
        function obj = resize(obj)
            oldUnits = obj.Units;
            oldPaperUnits = obj.Figure.PaperUnits;
            obj.Units = 'pixels';
            obj.Figure.PaperUnits = 'points';
            
            r = groot;
            PaperX = round((r.MonitorPositions(1,3) - obj.Figure.PaperSize(1))/2);
            PaperY = round((r.MonitorPositions(1,4) - obj.Figure.PaperSize(2))/2);
            obj.Figure.Position = [PaperX,PaperY,obj.Figure.PaperSize];
            
            obj.Figure.PaperPosition = [0,1,obj.Figure.PaperSize(1)-1,obj.Figure.PaperSize(2)-1];
            
            obj.Units = oldUnits;
            obj.Figure.PaperUnits = oldPaperUnits;
        end % End of resize
        
        %% Header
        function obj = initHeader(obj)
            oldUnits = obj.Units;
            obj.Units = 'pixels';
            
            x = obj.Margin.Left;
            y = obj.Height-obj.Margin.Top-obj.HeaderHeight;
            w = obj.Width - obj.Margin.Left - obj.Margin.Right;
            h = obj.HeaderHeight;
            
            obj.Header          = uipanel;
            obj.Header.Tag      = 'header';
            obj.Header.Units	= 'pixels';
            obj.Header.Position	= [x,y,w,h];
            obj.Header.BorderType = 'none';
            obj.Header.BackgroundColor = 'white';
            
            obj.TitleBox = annotation(obj.Header,'textbox');
            obj.TitleBox.Units = 'pixels';
            obj.TitleBox.Position = [0,0,w,h];
            obj.TitleBox.LineStyle = 'none';
            obj.TitleBox.HorizontalAlignment = 'center';
            obj.TitleBox.VerticalAlignment = 'middle';
            obj.TitleBox.FontUnits = 'pixels';
            obj.TitleBox.FontSize = 16;
            obj.TitleBox.FontName = 'Arial';
            obj.TitleBox.FontWeight = 'bold';
            obj.TitleBox.String = obj.Title;
            
            obj.Units = oldUnits;
        end % End of initHeader
        
        %% Footer
        function obj = initFooter(obj)
            oldUnits = obj.Units;
            obj.Units = 'pixels';
            
            x = obj.Margin.Left;
            y = obj.Margin.Bottom;
            w = obj.Width - obj.Margin.Left - obj.Margin.Right;
            h = obj.FooterHeight;
            
            obj.Footer          = uipanel;
            obj.Footer.Tag      = 'footer';
            obj.Footer.Units	= 'pixels';
            obj.Footer.Position	= [x,y,w,h];
            obj.Footer.BorderType = 'none';
            obj.Footer.BackgroundColor = 'white';
            
            obj.initLrcLogo;
            obj.initRpiLogo;
            
            nowStr = datestr(obj.DateGenerate,'yyyy mmmm dd, HH:MM');
            footerStr = {obj.Type;['Generated: ',nowStr]};
            
            obj.FooterBox = annotation(obj.Footer,'textbox');
            obj.FooterBox.Units = 'pixels';
            obj.FooterBox.Position = [0,0,w,h];
            obj.FooterBox.LineStyle = 'none';
            obj.FooterBox.HorizontalAlignment = 'center';
            obj.FooterBox.VerticalAlignment = 'top';
            obj.FooterBox.FontUnits = 'pixels';
            obj.FooterBox.FontSize = 16;
            obj.FooterBox.FontName = 'Arial';
            obj.FooterBox.String = footerStr;
            
            obj.PageNumBox = annotation(obj.Footer,'textbox');
            obj.PageNumBox.Units = 'pixels';
            obj.PageNumBox.Position = [0,0,w,h];
            obj.PageNumBox.LineStyle = 'none';
            obj.PageNumBox.HorizontalAlignment = 'center';
            obj.PageNumBox.VerticalAlignment = 'bottom';
            obj.PageNumBox.FontUnits = 'pixels';
            obj.PageNumBox.FontSize = 11;
            obj.PageNumBox.FontName = 'Arial';
            obj.PageNumBox.String = sprintf('%d of %d',obj.PageNumber(1),obj.PageNumber(2));
            
            obj.Units = oldUnits;
        end % End of initFooter
        
        %% Body
        function obj = initBody(obj)
            oldUnits = obj.Units;
            obj.Units = 'pixels';
            
            x = obj.Margin.Left;
            y = obj.Footer.Position(2) + obj.Footer.Position(4) + 9;
            w = obj.Width - obj.Margin.Left - obj.Margin.Right;
            h = obj.Header.Position(2) - y;
            
            obj.Body            = uipanel;
            obj.Body.Units      = 'pixels';
            obj.Body.Position	= [x,y,w,h];
            obj.Body.BorderType = 'none';
            obj.Body.BackgroundColor = 'white';
            
            obj.Units = oldUnits;
        end % End of initBody
        
        %% LRC logo
        function initLrcLogo(obj)
            [A,map,alpha] = imread('lrcLogo.png'); % Read in our image.
            
            hLogoAxes = axes(obj.Footer); % Make a new axes for logo
            hLogoAxes.Visible = 'off'; % Set axes visibility
            
            hLogoAxes.Units = 'pixels';
            
            x = 0;
            h = 36;
            w = ceil(518*h/150);
            y = floor((obj.Footer.Position(4) - h)/2);
            
            hLogoAxes.Position = [x,y,w,h];
            
            hLogo = imshow(A,map); % Display image
            hLogo.AlphaData = alpha; % Set alpha channel
        end % End of initLrcLogo
        
        %% RPI Logo
        function initRpiLogo(obj)
            [A,map,alpha] = imread('rpiLogo.png'); % Read in our image.
            
            hLogoAxes = axes(obj.Footer); % Make a new axes for logo
            hLogoAxes.Visible = 'off'; % Set axes visibility
            
            hLogoAxes.Units = 'pixels';
            
            h = 17;
            w = 100; %ceil(384*h/71);
            x = obj.Footer.Position(3) - w;
            y = floor((obj.Footer.Position(4) - h)/2);
            
            hLogoAxes.Position = [x,y,w,h];
            
            hLogo = imshow(A,map); % Display image
            hLogo.AlphaData = alpha; % Set alpha channel
        end
        
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
    end
end

