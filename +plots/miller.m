function hAxes = miller(millerTime,label1,data1,label2,data2,varargin)
%MILLER Summary of this function goes here
%   Detailed explanation goes here
% See also MILLERIZE.MILLERIZE

% Imports
import plots.legendflex.*;

% Parse input
p = inputParser;
addRequired(p,'millerTime');
addRequired(p,'label1',@ischar);
addRequired(p,'data1',@isnumeric);
addRequired(p,'label2',@ischar);
addRequired(p,'data2',@isnumeric);
addOptional(p,'h',[],@ishandle);
addOptional(p,'quality','display',@ischar);
parse(p,millerTime,label1,data1,label2,data2,varargin{:});

% Reassign the quality variable.
quality = lower(p.Results.quality);

% Make axes active or create one.
if isempty(p.Results.h)
    axes;
else
    axes(p.Results.h);
end

% Plot the data
[hAxes,h1,h2] = plotyy(millerTime.hours,data1,millerTime.hours,data2);

% Apply common formatting
commonFormatting(hAxes,h1,h2,label1,data1,label2,data2);

switch quality
    case 'display'
        [hAxes,h1,h2] = displayFormatting(hAxes,h1,h2);
    case 'export'
        [hAxes,h1,h2] = exportFormatting(hAxes,h1,h2);
    otherwise
        warning('Quality mode not recognized. Display quality used.');
        [hAxes,h1,h2] = displayFormatting(hAxes,h1,h2);
end

% Create and format the legend.
% legendflex([h1,h2],{label1,label2},'anchor',[2 6],'buffer',[0 10],'ncol',2,'padding',[0 1 10]);
legendflex([h1,h2],{label1,label2},'anchor',[6 2],'buffer',[0 -45],'ncol',2,'padding',[0 1 10]);

% Fix box
fixBox(hAxes);


end


function commonFormatting(hAxes,h1,h2,label1,data1,label2,data2)

% Format all axes.
for iAxis = 1:2
    set(hAxes(iAxis),'ActivePositionProperty','position');
    set(hAxes(iAxis),'TickDir','out');
    set(hAxes(iAxis),'Box','off');
    set(hAxes(iAxis),'Color','none');
    set(hAxes(iAxis),'YColor','k');
    set(hAxes(iAxis),'Layer','top');
end

% Format data1
set(h1,'DisplayName',label1);

% Format data2
set(h2,'DisplayName',label2);

% Format x-axis
xTick = 0:24;
xTickLabel = {'00:00','','','','','',...
              '06:00','','','','','',...
              '12:00','','','','','',...
              '18:00','','','','','',...
              '24:00'};
set(hAxes(1),'XLim',[0,24]);
set(hAxes(2),'XLim',[0,24]);
% Ticks and labels on first x-axis.
set(hAxes(1),'XTick',xTick);
set(hAxes(1),'XTickLabel',xTickLabel);
% Hide second x-axis.
set(hAxes(2),'XTick',[]);
set(hAxes(2),'XTickLabel','');
% Label x-axis
xlabel(hAxes(1),'Time');

% Format y-axes
yTick = 0:0.1:1;
% First y-axis
if max(data1) <= 1
    set(hAxes(1),'YLim',[0,1]);
    set(hAxes(1),'YTick',yTick);
end
ylabel(hAxes(1),label1);
% Second y-axis
if max(data2) <= 1
    set(hAxes(2),'YLim',[0,1]);
    set(hAxes(2),'YTick',yTick);
end
ylabel(hAxes(2),label2);

end

function [hAxes,h1,h2] = displayFormatting(hAxes,h1,h2)
% Format data1
set(h1,'Color',[180, 211, 227]/256);
set(h1,'LineWidth',2);
h1 = line2area(h1);

% Format data2
set(h2,'Color',[0,0,0]);
set(h2,'LineWidth',2);

end

function [hAxes,h1,h2] = exportFormatting(hAxes,h1,h2)

end

function fixBox(hAxes)
% create new, empty axes with box but without ticks
hBox = axes('Position',get(hAxes(1),'Position'),'box','on','xtick',[],'ytick',[]);
% set original axes as active
for iAxis = 1:numel(hAxes)
    axes(hAxes(iAxis));
end
% link axes in case of zooming
linkaxes([hAxes(1) hAxes(2) hBox])

set(hBox,'Layer','top');
end

function hArea = line2area(hLine)

% Get data and properties of line.
xData = get(hLine,'XData');
yData = get(hLine,'YData');
hParent = get(hLine,'Parent');
displayName = get(hLine,'DisplayName');
color = get(hLine,'Color');

% Add extra points to close area.
xLim = get(hParent,'XLim');
xData2 = [xLim(1),xData,xLim(2)];
yData2 = [0,yData,0];

% Create color data
cData = ones(size(xData2));

% Make correct axes active.
hTemp = gca;
axes(hParent);

% Plot the area
hArea = patch(xData2,yData2,cData);
set(hArea,'DisplayName',displayName);
set(hArea,'FaceColor',color);
set(hArea,'EdgeColor','none');

% Remove the line.
delete(hLine);

axes(hTemp);

end

