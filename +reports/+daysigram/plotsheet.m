function plotsheet(Days,lightMeasure,lightRange,position,nDaysPerSheet,units)
%PLOTSHEET Summary of this function goes here
%   Detailed explanation goes here
%   lightMeasure = 'cs' or 'lux'

import reports.daysigram.*;
import plots.legendflex.*;

nDays = numel(Days);

x = position(1);
width = position(3);
height = position(4)/nDaysPerSheet;
y = position(2) + position(4) - (1:nDays)'*height;

for i1 = 1:min([nDays,nDaysPerSheet])
    axesPosition = [x, y(i1), width, height];
    if numel(Days(i1).timeArray) > 0
        [hAxesLeft,hAxesRight,hAxesMasks,hGroup] = reports.daysigram.plotday(Days(i1),lightMeasure,lightRange,axesPosition,units);
    end
end

xlabel(hAxesRight,'time of day (hours)');
set(hAxesRight,'XTickLabel',0:24);

% hLegend = legend(hAxes(1),'show','Location','South','Orientation','horizontal');
hLegend = legend(hGroup);
hLegend.Location = 'South';
hLegend.Orientation = 'horizontal';
legendEntries = hLegend.String;
hLegend.Visible = 'off';
legendflex(hGroup,legendEntries,'anchor',[6 2],'buffer',[0 -50],'padding',[0 1 10],'nrow',2);
axes(hAxesLeft);
axes(hAxesRight);

% Box in the plots
boxPosition = [x, y(end), width, nDays*height];
hBoxAxes = axes('ActivePositionProperty','position','Units',units,'Position',boxPosition);
set(hBoxAxes,'XLim',[0,1],'XLimMode','manual');
set(hBoxAxes,'YLim',[0,1],'YLimMode','manual');
xBox = [0,1,1,0,0];
yBox = [0,0,1,1,0];
hBox = plot(hBoxAxes,xBox,yBox);
set(hBox,'Color','k','LineWidth',1,'Clipping','off');
set(hBoxAxes,'Visible','off');

end

