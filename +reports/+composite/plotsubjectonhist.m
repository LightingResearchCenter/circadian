function plotsubjectonhist(value,noteText,xArray,yArray)
%PLOTSUBJECT Summary of this function goes here
%   

import reports.composite.*;

hAxis = gca;

xLimits = get(hAxis,'XLim');
yLimits = get(hAxis,'YLim');

set(hAxis,'Units','points');
axisPosition = get(hAxis,'Position');
points2dataY = (yLimits(2) - yLimits(1))/axisPosition(4);
points2dataX = (xLimits(2) - xLimits(1))/axisPosition(3);

set(hAxis,'Units','normalized');

set(hAxis,'XLimMode','manual','YLimMode','manual');

yBottom  = 0;

dX = abs(xArray - value);
[~,idx] = min(dX);
x = value;
y = yArray(idx);

color = 'r';

% Plot a dot
markerSize = 6;
plot(x,y,'o','Color',color,'MarkerSize',markerSize,'LineWidth',2);

markerOffsetY = 0.5*markerSize*points2dataY;
markerOffsetX = 0.5*markerSize*points2dataX;

% Plot a line
hLine = line([x,x],[yBottom,y-markerOffsetY],'Color',color,'LineWidth',2);
set(hLine,'Clipping','off');

% Plot text
hText = text(x,y,noteText,'Color',color,'FontWeight','bold');
textPosition = get(hText,'Position');

[~,yMaxIdx] = max(yArray);
xPeakY = xArray(yMaxIdx);

if x < xPeakY
    set(hText,'HorizontalAlignment','Right')
    textPosition(1) = textPosition(1) - 3*markerOffsetX;
    set(hText,'Position',textPosition);
elseif x > xPeakY
    set(hText,'HorizontalAlignment','Left')
    textPosition(1) = textPosition(1) + 3*markerOffsetX;
    set(hText,'Position',textPosition);
else
    set(hText,'HorizontalAlignment','Center')
    textPosition(2) = textPosition(2) + 3*markerOffsetY;
    set(hText,'Position',textPosition);
end


end

