function varargout = loadlrclogo
%LOADLRCLOGO Summary of this function goes here
%   Detailed explanation goes here

import reports.daysigram.*;

% Read in our image.
[A,map,alpha] = imread('lrcLogo.png');

% Make a new axes for logo
hLogoAxes = axes;
% Set axes visibility
set(hLogoAxes,'Visible','off'); % 'on' or 'off'

% Position and size the logo axes
units = 'inches';
set(hLogoAxes,'Units',units);
set(hLogoAxes,'ActivePositionProperty','position');

width = 1.726;
height = 0.5;

position = [0,0,width,height]; % [left,bottom,width,height] (inches)
set(hLogoAxes,'Position',position);

% Display image
hLogo = imshow(A,map);
% Set alpha channel
set(hLogo,'AlphaData',alpha);

% Return the logo handle if requested
if nargout == 1
    varargout = {hLogoAxes};
end

end

