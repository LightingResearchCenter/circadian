function [hFigure,width,height,units] = initializefigure(h,visible)
%INITIALIZEFIGURE Summary of this function goes here
%   Detailed explanation goes here

import daysigram.*;

% Create figure window
hFigure = figure(h);
set(hFigure,'Visible',visible);

% Define paper properties
paperOrientation = 'portrait'; % 'portrait' or 'landscape'
set(hFigure,'PaperOrientation',paperOrientation);

paperType = 'usletter';
set(hFigure,'PaperType',paperType);

paperUnits = 'inches'; % Paper units
set(hFigure,'PaperUnits',paperUnits);

paperSize = get(hFigure,'PaperSize'); % [width,height]

paperPositionMode = 'manual';
set(hFigure,'PaperPositionMode',paperPositionMode);

% Define useable area to print in
margin = 0.5; % inches
width  = paperSize(1)-2*margin;
height = paperSize(2)-2*margin;
paperPosition = [margin,margin,width,height]; % [left,bottom,width,height]
set(hFigure,'PaperPosition',paperPosition);

% Define figure window properties
units = 'inches'; % Figure units
set(hFigure,'Units',units);

position = [0.5,0.5,width,height]; % [left,bottom,width,height]
set(hFigure,'Position',position);

set(hFigure,'Renderer','painters');

% Limit user's ability to change figure
dockControls = 'off';
set(hFigure,'DockControls',dockControls);

resize = 'off';
set(hFigure,'Resize',resize);

end

