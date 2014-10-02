function [hAxes,hGrid,hLabels] = phasoraxes(varargin)
%PHASORAXES Summary of this function goes here
%   Detailed explanation goes here

% Parse input.
p = inputParser;
addOptional(p,'hAxes',[],@ishandle);
addOptional(p,'quality','display',@ischar);
parse(p,varargin{:});

% Reassign the quality variable.
switch lower(p.Results.quality);
    case 'display'
        quality = 'display';
    case 'export'
        quality = 'export';
    otherwise
        warning('Quality mode not recognized. Display quality used.');
        quality = 'display';
end

% Make axes active or create one.
if isempty(p.Results.hAxes)
    hAxes = axes;
else
    hAxes = p.Results.hAxes;
    axes(hAxes);
end

% Make Cartesian axes invisible.
set(hAxes,'Visible','off');

% Prevent unwanted resizing of axes.
set(hAxes,'ActivePositionProperty','position')

% Prevent axes from being erased.
set(hAxes,'NextPlot','add');

% Set limits to 1.
set(hAxes,'XLim',[-1 1]);
set(hAxes,'YLim',[-1 1]);

% Make aspect ratio equal.
set(hAxes,'DataAspectRatio',[1 1 1]);

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

% Plot background
% patch('XData',xunit,'YData',yunit,...
%         'EdgeColor','none',...
%         'FaceColor','w',...
%         'HandleVisibility','off',...
%         'Parent',hGrid);

% Draw radial circles
cos82 = cos(82*pi/180);
sin82 = sin(82*pi/180);
rMin = 0;
rMax = 1;
rTicks = 5;
rInc = (rMax - rMin)/rTicks;
for iTick = (rMin + rInc):rInc:rMax
    hRadial = line(xunit*iTick,yunit*iTick);
    formatGrid(hRadial,hGrid);
    xText = (iTick + rInc/20)*cos82;
    yText = (iTick + rInc/20)*sin82;
    hText = text(xText,yText,['  ' num2str(iTick)]);
    formatMagnitude(hText,hLabels);
end
% Make outer circle balck and solid.
set(hRadial,'Color','k');
set(hRadial,'LineStyle','-');

% Plot spokes.
th = (1:12)*2*pi/12;
cst = cos(th);
snt = sin(th);
cs = [zeros(size(cst)); cst];
sn = [zeros(size(snt)); snt];
hSpoke = line(rMax*cs,rMax*sn);
formatGrid(hSpoke,hGrid);

% Annotate spokes in hours
rt = 1.1 * rMax;
pm = char(177);
hours = {'+2','+4','+6','+8','+10',[pm,'12'],'-10','-8','-6','-4','-2','0'};
for iSpoke = 1:length(th)
    hText = text(rt*cst(iSpoke),rt*snt(iSpoke),hours(iSpoke));
    formatHours(hText,hLabels)
end


    function formatGrid(h,hParent)
    set(h,'LineWidth',0.5);
    set(h,'HandleVisibility','off');
    set(h,'Parent',hParent);

    switch quality
        case 'display'
            set(h,'LineStyle','--');
            set(h,'Color',[0.5,0.5,0.5]);
        case 'export'
            set(h,'LineStyle','-');
            set(h,'Color','k');
    end

    end

    function formatMagnitude(h,hParent)
        set(h,'FontSize',get(0,'DefaultAxesFontSize'));
        set(h,'VerticalAlignment','bottom');
        set(h,'HandleVisibility','off')
        set(h,'Parent',hParent);
    end

    function formatHours(h,hParent)
        set(h,'FontSize',get(0,'DefaultAxesFontSize'));
        set(h,'HorizontalAlignment','center');
        set(h,'HandleVisibility','off');
        set(h,'Parent',hParent);
    end

end