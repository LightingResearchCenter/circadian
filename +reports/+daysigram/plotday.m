function [hAxesLeft,hAxesRight,hAxesMasks,hGroup] = plotday(Day,lightMeasure,lightLim,position,units)
%PLOTDAY Summary of this function goes here
%   Detailed explanation goes here
%   lightMeasure = 'cs' or 'lux'

import reports.daysigram.*;

% Dole out variables
timeArray = Day.timeArray;
activityArray = Day.activityArray;
lightArray = Day.lightArray;
excludedData = Day.excludedData;
notInUse = Day.notInUse;
inBed = Day.inBed;


% Normalize activity if needed
% maxActivity = max(activityArray);
% if maxActivity > 1
%     activityArray = activityArray/maxActivity;
% end

% Separate unevenly sampled data into groups
Groups = reports.daysigram.slicedata2breaks(timeArray,activityArray,lightArray,excludedData,notInUse,inBed);

% Create the axes
hAxesMasks = axes('ActivePositionProperty','position','Units',units,'Position',position);
hAxesLeft = axes('ActivePositionProperty','position','Units',units,'Position',position);
hAxesRight = axes('ActivePositionProperty','position','Units',units,'Position',position);

xLim = [floor(timeArray(1)),ceil(timeArray(end))];

% Plot the data
for i1 = 1:numel(Groups)
    
    hInBed = area(hAxesMasks,Groups(i1).timeArray,Groups(i1).inBed);
    if i1 == 1
        hold(hAxesMasks,'on');
        hold(hAxesLeft,'on');
        hold(hAxesRight,'on');
    end
    hNotInUse = area(hAxesMasks,Groups(i1).timeArray,Groups(i1).notInUse);
    hExcluded = area(hAxesMasks,Groups(i1).timeArray,Groups(i1).excludedData);
    
    switch lightMeasure
        case {'lux','Lux','LUX'}
            Groups(i1).lightArray(Groups(i1).lightArray < lightLim(1)) = lightLim(1);
            hLight = area(hAxesLeft,Groups(i1).timeArray,Groups(i1).lightArray);
            hAxesLeft.YScale = 'log';
            hActivity = plot(hAxesRight,Groups(i1).timeArray,Groups(i1).activityArray);
            isLog = true;
        case {'cs','CS','Cs','cS'}
            hLight = area(hAxesLeft,Groups(i1).timeArray,Groups(i1).lightArray);
            hActivity = plot(hAxesRight,Groups(i1).timeArray,Groups(i1).activityArray);
            isLog = false;
        otherwise
            error('Unknown light measure.');
    end
    formatinbed(hInBed);
    formatnotinuse(hNotInUse);
    formatexcluded(hExcluded);
    formatactivity(hActivity);
    formatlight(hLight,lightMeasure);
    
    hideaxes(hAxesMasks);
    hideaxes(hAxesLeft);
    hideaxes(hAxesRight);
end

hold off;
formatxaxes(hAxesMasks,xLim);
hAxesMasks.YLimMode = 'manual';
hAxesMasks.YLim = [0 1];
hAxesMasks.Visible = 'off';
formatxaxes(hAxesLeft,xLim);
formatxaxes(hAxesRight,xLim);
formatlightaxes(hAxesLeft,lightLim,isLog);
formatactivityaxes(hAxesRight);

hLabel = ylabel(hAxesLeft(1),datestr(xLim(1),'mm/dd/yyyy'));
set(hLabel,'Rotation',0,'HorizontalAlignment','right');

axes(hAxesRight);

hGroup = [hLight;hActivity;hExcluded;hNotInUse;hInBed];

end


function formatlight(h,lightMeasure)
switch lightMeasure
    case {'cs','CS','Cs','cS'}
        set(h,...
            'FaceColor'   , [180, 211, 227]/256,...
            'EdgeColor'   , 'none');
        set(h,'DisplayName' , 'Circadian Stimulus (CS)');
    case {'lux','Lux','LUX'}
        set(h,'DisplayName' , 'Illuminance (lux)');
%         set(h,'Color'   , [180, 211, 227]/256);
        set(h,...
            'FaceColor'   , [180, 211, 227]/256,...
            'EdgeColor'   , 'none');
%         set(h,'LineWidth' , 1.5);
    otherwise
        set(h,'DisplayName' , 'Light');
        set(h,...
            'FaceColor'   , [180, 211, 227]/256,...
            'EdgeColor'   , 'none');
end


end


function formatactivity(h)
set(h,...
    'Color'     , 'k',...
    'LineWidth' , 1.5,...
    'DisplayName' , 'Activity Index (AI)');
end

function formatexcluded(h)
set(h,...
    'FaceColor'   , [255, 215, 215]/255,...
    'EdgeColor'   , 'none',...
    'DisplayName' , 'Excluded Data');
end

function formatnotinuse(h)
set(h,...
    'FaceColor'   , [230, 230, 230]/255,...
    'EdgeColor'   , 'none',...
    'DisplayName' , 'Not In Use');
end

function formatinbed(h)
set(h,...
    'FaceColor'   , [255, 255, 191]/255,...
    'EdgeColor'   , 'none',...
    'DisplayName' , 'Reported In Bed');
end

function hideaxes(h)

for i1 = 1:numel(h)
    set(h(i1),'Visible','off');
    h(i1).Color = 'none';
end

end


function formatxaxes(h,xLim)
h.Visible = 'on';
xTick = xLim(1):1/24:xLim(2);
set(h,'XLimMode','manual','XLim',xLim);
set(h,'XTick',xTick,'XTickLabel','');
set(h,'Box','off','XGrid','on');

end

function formatlightaxes(h,lightLim,isLog)

if lightLim(1) < 1 && lightLim(2) > 1
    yTick = [lightLim(1),1,lightLim(2)];
else
    yTick = lightLim;
end

h.YLimMode = 'manual';
h.YLim = lightLim;
h.YTick = yTick;
h.YTickLabel = '';
h.YColor = 'k';

plotyticklabels(h,yTick,'left',isLog);
end

function formatactivityaxes(h)

yLim = [0,1];
yTick = yLim;

h.YLimMode = 'manual';
h.YLim = yLim;
h.YTick = yTick;
h.YTickLabel = '';
h.YColor = 'k';
plotyticklabels(h,yTick,'right',false);
end

function plotyticklabels(h,yTick,side,isLog)
% Make the axis active
axes(h);

xLim = get(h,'XLim');
switch side
    case {'left','Left','LEFT'}
        x = xLim(1);
        offset = -8; % pixels
        horizontalAlignment = 'right';
    case {'right','Right','RIGHT'}
        x = xLim(2);
        offset = 8; % pixels
        horizontalAlignment = 'left';
end

for i1 = 1:numel(yTick)
    % Plot the label
    if isLog
        labelStr = ['10^{',num2str(log10(yTick(i1))),'}'];
    else
        labelStr = num2str(yTick(i1));
    end
    hTickLabel = text(x,yTick(i1),labelStr);
    
    % Position the label next to the axis
    set(hTickLabel,'HorizontalAlignment',horizontalAlignment);
    units = get(hTickLabel,'Units');
    set(hTickLabel,'Units','pixels');
    position = get(hTickLabel,'Position');
    position(1) = position(1) + offset;
    set(hTickLabel,'Position',position);
    set(hTickLabel,'Units',units);
    
    % Set the vertical position
    if i1 == 1
        set(hTickLabel,'VerticalAlignment','baseline');
    elseif i1 == numel(yTick)
        set(hTickLabel,'VerticalAlignment','cap');
    else
        set(hTickLabel,'VerticalAlignment','middle');
    end
end
    
end

