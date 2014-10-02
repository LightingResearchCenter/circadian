function hAxes = plotday(Day,lightMeasure,lightLim,position,units)
%PLOTDAY Summary of this function goes here
%   Detailed explanation goes here
%   lightMeasure = 'cs' or 'lux'

import reports.daysigram.*;

% Dole out variables
timeArray = Day.timeArray;
activityArray = Day.activityArray;
lightArray = Day.lightArray;

% Normalize activity if needed
% maxActivity = max(activityArray);
% if maxActivity > 1
%     activityArray = activityArray/maxActivity;
% end

% Separate unevenly sampled data into groups
Groups = slicedata2breaks(timeArray,activityArray,lightArray);

% Create the axes
hAxes = axes('ActivePositionProperty','position','Units',units,'Position',position);

xLim = [floor(timeArray(1)),ceil(timeArray(end))];

% Plot the data
for i1 = 1:numel(Groups)
    switch lightMeasure
        case {'lux','Lux','LUX'}
            if i1 == 1
                [hAxes,hActivity,hLight] = plotyy(Groups(i1).timeArray,Groups(i1).activityArray,...
                    Groups(i1).timeArray,Groups(i1).lightArray,'area','semilogy');
                    for i2 = 1:numel(hAxes)
                        hold(hAxes(i2),'on');
                    end
            else
                hActivity = area(hAxes(1),Groups(i1).timeArray,Groups(i1).activityArray);
                axes(hAxes(2));
                hLight = semilogy(Groups(i1).timeArray,Groups(i1).lightArray);
            end
                
            isLog = true;
        case {'cs','CS','Cs','cS'}
            if i1 == 1
                [hAxes,hActivity,hLight] = plotyy(Groups(i1).timeArray,Groups(i1).activityArray,...
                    Groups(i1).timeArray,Groups(i1).lightArray,'area','plot');
                for i2 = 1:numel(hAxes)
                        hold(hAxes(i2),'on');
                end
            else
                hActivity = area(hAxes(1),Groups(i1).timeArray,Groups(i1).activityArray);
                hLight = plot(hAxes(1),Groups(i1).timeArray,Groups(i1).lightArray);
            end
            isLog = false;
        otherwise
            error('Unknown light measure.');
    end
    
    formatactivity(hActivity);
    formatlight(hLight,lightMeasure);
    
    hideaxes(hAxes)
end

hold off;

formatxaxes(hAxes,xLim);
formatyaxes(hAxes,lightLim,isLog);

hLabel = ylabel(hAxes(1),datestr(xLim(1),'mm/dd/yyyy'));
set(hLabel,'Rotation',0,'HorizontalAlignment','right');


hAxes = hAxes(1);

end


function formatactivity(h)
set(h,...
    'FaceColor'   , [180, 211, 227]/256,...
    'EdgeColor'   , 'none',...
    'DisplayName' , 'Activity');

end


function formatlight(h,lightMeasure)
set(h,...
    'Color'     , 'k',...
    'LineWidth' , 2);
switch lightMeasure
    case {'cs','CS','Cs','cS'}
        set(h,'DisplayName' , 'Circadian Stimulus (CS)');
    case {'lux','Lux','LUX'}
        set(h,'DisplayName' , 'Illuminance (lux)');
    otherwise
        set(h,'DisplayName' , 'Light');
end

end


function hideaxes(h)

for i1 = 1:numel(h)
    set(h(i1),'Visible','off');
end

end


function formatxaxes(h,xLim)

xTick = xLim(1):1/24:xLim(2);

for i1 = 1:numel(h)
    set(h(i1),'Visible','on');
    set(h(i1),'XLimMode','manual','XLim',xLim);
    set(h(i1),'XTick',xTick,'XTickLabel','');
    set(h(i1),'Box','off','XGrid','on');
end

end

function formatyaxes(h,lightLim,isLog)

yLim = [0,1];
yTick = yLim;

for i1 = 1:numel(h)
    set(h(i1),'Visible','on');
end
set(h(1),'YLimMode','manual','YLim',yLim);
set(h(1),'YTick',yTick,'YTickLabel','');
plotyticklabels(h(1),yTick,'left',false);

if numel(h) > 1 % Format additional y-axes if they exist
    
    
    if lightLim(1) < 1 && lightLim(2) > 1
        yTick = [lightLim(1),1,lightLim(2)];
    else
        yTick = lightLim;
    end
    
    set(h(2),'YLimMode','manual','YLim',lightLim);
    set(h(2),'YTick',yTick,'YTickLabel','');
    set(h(2),'YColor','k');
    
    plotyticklabels(h(2),yTick,'right',isLog);
end

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

