function varargout = loadrpilogo
%LOADRPILOGO Summary of this function goes here
%   Detailed explanation goes here

% Read in our image.
[A,map,alpha] = imread('rpiLogo.png');


% Make a new axes for logo
hLogoAxes = axes;
% Set axes visibility
set(hLogoAxes,'Visible','off'); % 'on' or 'off'

% Position and size the logo axes
units = 'inches';
set(hLogoAxes,'Units',units);
set(hLogoAxes,'ActivePositionProperty','position');

paperPosition = get(gcf,'PaperPosition');
paperWidth = paperPosition(3);

width = 1.280;
height = 0.236;
bottom = 0;
left = paperWidth - width;

position = [left,bottom,width,height]; % [left,bottom,width,height] (inches)
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

