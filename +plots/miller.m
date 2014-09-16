function h = miller(millerTime,label1,data1,label2,data2,varargin)
%MILLER Summary of this function goes here
%   Detailed explanation goes here
% See also MILLERIZE.MILLERIZE

% Parse input
p = inputParser;
default = [];
addRequired(p,'millerTime');
addRequired(p,'label1',@ischar);
addRequired(p,'data1',@isnumeric);
addRequired(p,'label2',@ischar);
addRequired(p,'data2',@isnumeric);
addOptional(p,'h',default,@ishandle);
parse(p,millerTime,label1,data1,label2,data2,varargin{:});

% Make axis active or create one
if isempty(p.Results.h)
    h = axes;
else
    h = p.Results.h;
    axes(h);
end

% Plot the data
[h,h1,h2] = plotyy(millerTime.hours,data1,millerTime.hours,data2);

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
set(h,'XLim',[0,24]);
% Ticks and labels on first x-axis.
set(h(1),'XTick',xTick);
set(h(1),'XTickLabel',xTickLabel);
% Hide second x-axis.
set(h(2),'XTick',[]);
set(h(2),'XTickLabel','');

% Format y-axes
yTick = 0:0.1:1;
% First y-axis
if max(data1) <= 1
    set(h(1),'YLim',[0,1]);
    set(h(1),'YTick',yTick);
end
ylabel(h(1),label1);
% Second y-axis
if max(data2) <= 1
    set(h(2),'YLim',[0,1]);
    set(h(2),'YTick',yTick);
end
ylabel(h(2),label2);

% Create and format the legend.
hLegend = legend('show');
set(hLegend,'Location','NorthOutside');
set(hLegend,'Orientation','Horizontal');

% Format all axes.
set(h,'TickDir','out');
set(h,'Box','off');
% Create a line on top to close in the axes
yLim = get(h(1),'YLim');
xLim = get(h(1),'XLim');
hLine = line(xLim,[yLim(2),yLim(2)]);
set(hLine,'Clipping','off');
set(hLine,'Color','k');
set(hLine,'DisplayName','');


end

