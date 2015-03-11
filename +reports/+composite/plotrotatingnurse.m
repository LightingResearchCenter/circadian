function textHeight = plotrotatingnurse(plotType,xArray,yArray)
%PLOTROTATINGNURSE Summary of this function goes here
%   plotType = 'magnitude' or 'angle'

import reports.composite.*;

hAxis = gca;

xLimits = get(hAxis,'XLim');
yLimits = get(hAxis,'YLim');
yHeight = yLimits(2) - yLimits(1);

set(hAxis,'Units','normalized');
axisPosition = get(hAxis,'Position');
data2normY = axisPosition(4)/yHeight;

set(hAxis,'XLimMode','manual','YLimMode','manual');

yTop  = 1.02*yHeight + yLimits(1);
yText = 1.06*yHeight + yLimits(1);

nightsWorkedArray       = [1,           2,           3        ];
phasorMagnitudeArray	= [0.296043478, 0.121222222, 0.0480625];
phasorAngleArray        = [1.215217391, 2.319444444, 4.28     ];
% phasorMagnitudeArray	= [0.296043478, 0.121222222, 0.0480625, 0.1185];
% phasorAngleArray      = [1.215217391, 2.319444444, 4.28,      6.72  ];

switch plotType
    case 'magnitude'
        valueArray = phasorMagnitudeArray;
    case 'angle'
        valueArray = phasorAngleArray;
    otherwise
        error('Uknown plotType');
end

for i1 = 1:numel(nightsWorkedArray)
    if valueArray(i1) < xLimits(1) || valueArray(i1) > xLimits(2)
        continue;
    end
    dX = abs(xArray - valueArray(i1));
    [~,idx] = min(dX);
    x = xArray(idx);
    y = yArray(idx);
    
    hLine = line([x,x],[y,yTop],'Color','k');
    set(hLine,'Clipping','off');
    
    noteText = ['*',num2str(nightsWorkedArray(i1))];
    hText = text(x,yText,noteText,'HorizontalAlignment','Center');
    set(hText,'FontUnits','points','FontSize',8);
    
end

% textExtent = get(hText,'Extent');
% yOffset = textExtent(4)*data2normY;
% axisPosition = get(hAxis,'Position');
% axisPosition(4) = axisPosition(4) - yOffset - 0.04*yHeight*data2normY;
% set(hAxis,'Position',axisPosition);

textExtent = get(hText,'Extent');
textHeight = textExtent(2) + textExtent(4) + 0.02*yHeight;

end

