function phasormagdist(subjectPhasorMagnitude,position,units)
%PHASORMAGDIST Summary of this function goes here
%   Detailed explanation goes here

import reports.composite.*;

% Load data
Input = load('combinedPhasorResults.mat');

phasorMagnitudeArray = Input.phasorMagnitudeArray;

% Set options
distribution = 'Normal';

% magMin = min(phasorMagnitudeArray);
% magMax = max(phasorMagnitudeArray);
% magStDev = std(phasorMagnitudeArray);
% 
% xBuffer = 2*magStDev;
% xMin = magMin - xBuffer;
% if xMin < 0
%     xMin = 0;
% end
% xMax = magMax + xBuffer;
% if xMax > 1
%     xMax = 1;
% end
% xStep = (xMax-xMin)/10000;
% xArray = xMin:xStep:xMax;
% 
% pd = fitdist(phasorMagnitudeArray,distribution);
% 
% yArray = pdf(pd,xArray);

% Create axes to plot on
hAxes = axes;
set(hAxes,'Units',units);
set(hAxes,'ActivePositionProperty','position');
set(hAxes,'Position',position);
set(hAxes,'Units','normalized'); % Return to default
hold('on');

% Plot normalized histogram
nBins = floor(sqrt(numel(phasorMagnitudeArray)));
[nElements,xCenters] = hist(phasorMagnitudeArray,nBins);
deltaX = xCenters(2) - xCenters(1);
hBar = bar(xCenters,nElements/sum(nElements*deltaX),1);
set(hBar,'FaceColor',[180, 211, 227]/256,'EdgeColor','w');


% Plot density curve
load('magnitudeCurve.mat','xArray','yArray');
plot(xArray,yArray,'Color','k','LineWidth',2)

xlim([0,1]);

% Create full title
plotTitle = [distribution,' Probability Distribution'];
hTitle = title(plotTitle);

% Label axes
xlabel('Phasor Magnitude');
ylabel('Density');

% Remove Y-ticks
% set(hAxes,'YTick',[]);
% set(hAxes,'YTickLabel','');

plotsubjectonhist(subjectPhasorMagnitude,{'Subject''s';'Phasor';'Magnitude'},xArray,yArray);

nurseHeight = plotrotatingnurse('magnitude',xArray,yArray);

% Move title up
titlePosition = get(hTitle,'Position');
titlePosition(2) = nurseHeight;
set(hTitle,'Position',titlePosition);

% Make box pretty
set(gca,'TickDir','out');

box('off')

xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');
hLine1 = line([xLimits(1),xLimits(2)],[yLimits(1),yLimits(1)],'Color','k');
hLine2 = line([xLimits(1),xLimits(2)],[yLimits(2),yLimits(2)],'Color','k');
hLine3 = line([xLimits(2),xLimits(2)],[yLimits(1),yLimits(2)],'Color','k');

set(hLine1,'Clipping','off');
set(hLine2,'Clipping','off');
set(hLine3,'Clipping','off');

% Eliminate excess white space
% set(gca, 'Position', get(gca, 'OuterPosition') - ...
%     get(gca, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);


end

