function phasorangdist(subjectPhasorAngle,position,units)
%PHASORANGDIST Summary of this function goes here
%   Detailed explanation goes here

import reports.composite.*;

% Load data
Input = load('combinedPhasorResults.mat');

phasorAngleArray = Input.phasorAngleArray;

% Set options
distribution = 'Normal';

% angMin = min(phasorAngleArray);
% angMax = max(phasorAngleArray);
% angStDev = std(phasorAngleArray);
% 
% xBuffer = 2*angStDev;
% xMin = angMin - xBuffer;
% if xMin < -12
%     xMin = -12;
% end
% xMax = angMax + xBuffer;
% if xMax > 12
%     xMax = 12;
% end
% xStep = (xMax-xMin)/1000;
% xArray = xMin:xStep:xMax;

% pd = fitdist(phasorAngleArray,distribution);

% yArray = pdf(pd,xArray);

% Create axes to plot on
hAxes = axes;
set(hAxes,'Units',units);
set(hAxes,'ActivePositionProperty','position');
set(hAxes,'Position',position);
set(hAxes,'Units','normalized'); % Return to default
hold('on');

% Plot normalized histogram
nBins = floor(sqrt(numel(phasorAngleArray)));
[nElements,xCenters] = hist(phasorAngleArray,nBins);
deltaX = xCenters(2) - xCenters(1);
hBar = bar(xCenters,nElements/sum(nElements*deltaX),1);
set(hBar,'FaceColor',[180, 211, 227]/256,'EdgeColor','w');
hold('on');

% Plot density curve
load('angleCurve.mat','xArray','yArray');
plot(xArray,yArray,'Color','k','LineWidth',2)

if subjectPhasorAngle > 6
    newXMax = ceil(subjectPhasorAngle);
    xlim([-6,newXMax])
elseif subjectPhasorAngle < -6
    newXMin = floor(subjectPhasorAngle);
    xlim([newXMin,6])
else
    xlim([-6,6]);
end

% Create full title
plotTitle = [distribution,' Probability Distribution'];
hTitle = title(plotTitle);

% Label axes
xlabel('Phasor Angle (hours)');
ylabel('Density');

% Remove Y-ticks
% set(hAxes,'YTick',[]);
% set(hAxes,'YTickLabel','');

plotsubjectonhist(subjectPhasorAngle,{'Subject''s';'Phasor';'Angle'},xArray,yArray);

nurseHeight = plotrotatingnurse('angle',xArray,yArray);

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

% % Eliminate excess white space
% set(gca, 'Position', get(gca, 'OuterPosition') - ...
%     get(gca, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);

end

