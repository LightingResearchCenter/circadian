function plotnotes(Phasor,Average,position,units)
%PLOTNOTES Summary of this function goes here
%   hFigure = figure handle

import reports.composite.*;

% Create axes to plot on
hAxes = axes;
set(hAxes,'Units',units);
set(hAxes,'ActivePositionProperty','position');
set(hAxes,'Position',position);
set(hAxes,'XLim',[0,position(3)]);
set(hAxes,'YLim',[0,position(4)]);
set(hAxes,'Visible','off'); % 'on' or 'off'

% Create text
precision = '%.2f';

label1 = {...
                   'Phasor Magnitude:';...
                       'Phasor Angle:';...
                                    '';...
          'Interdaily Stability (IS):';...
        'Intradaily Variability (IV):';...
                                    '';...
                   'Average Activity:';...
	'Average Circadian Stimulus (CS):';...
       'Average Photopic Illuminance:';};
   
data1 = {...
    num2str(Phasor.magnitude, precision);...
    num2str(Phasor.angleHrs, precision);...
    '';...
    num2str(Phasor.interdailyStability, precision);...
    num2str(Phasor.intradailyVariability, precision);...
    '';...
    num2str(Average.activity, precision);...
	num2str(Average.cs, precision);...
    num2str(Average.illuminance, precision)};

units1 = {...
    '';...
    ' hours';...
    '';...
    '';...
    '';...
    '';...
    '';...
	'';...
    ' lux'};

top = position(4) - 0.125;
middle1 = 2.25;
fontSize = 12;

plottext(label1,data1,units1,middle1,top,fontSize);

end


function plottext(label,data,units,middle,top,fontSize)

hLabel = text(middle,top,label);
formattext(hLabel,fontSize);
set(hLabel,'HorizontalAlignment','right');
labelExtent = get(hLabel,'Extent');
labelPosition = get(hLabel,'Position');

space = repmat('  ',size(data));
hSpace = text(middle,top,space);
formattext(hSpace,fontSize);
set(hSpace,'HorizontalAlignment','left');
spaceExtent = get(hSpace,'Extent');
spacePosition = get(hSpace,'Position');

hData = text(middle,top,data);
formattext(hData,fontSize);
set(hData,'HorizontalAlignment','right');
dataExtent = get(hData,'Extent');
dataPosition = get(hData,'Position');

hUnits = text(middle,top,units);
formattext(hUnits,fontSize);
set(hUnits,'HorizontalAlignment','left');
unitsExtent = get(hUnits,'Extent');
unitsPosition = get(hUnits,'Position');

newMiddle1 = 2*middle-(labelExtent(1)+(labelExtent(3)+spaceExtent(3)+dataExtent(3)+unitsExtent(3))/2);
labelPosition(1) = newMiddle1;
set(hLabel,'Position',labelPosition);

spacePosition(1) = newMiddle1;
set(hSpace,'Position',spacePosition);
spaceExtent = get(hSpace,'Extent');

dataPosition(1) = spaceExtent(1)+spaceExtent(3)+dataExtent(3);
set(hData,'Position',dataPosition);

unitsPosition(1) = dataPosition(1);
set(hUnits,'Position',unitsPosition);

end

function formattext(hText,fontSize)
set(hText,'VerticalAlignment','top');
set(hText,'FontSize',fontSize);

end

