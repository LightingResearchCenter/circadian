function varargout = createpaperaxes(hFigure,visible)
%CREATEPAPERAXES Summary of this function goes here
%   Detailed explanation goes here

import reports.composite.*;

% Create axes
hPaperAxes = axes;

% Set axes visibility
set(hPaperAxes,'Visible',visible); % 'on' or 'off'

% Maximize axes to paper position (axes units are normalized)
set(hPaperAxes,'Position',[0,0,1,1]);

% Retrieve paper properties
paperPosition = get(hFigure,'PaperPosition');
width = paperPosition(3);
height = paperPosition(4);

% Set limits to printable area's dimensions
set(hPaperAxes,'XLim',[0,width]);
set(hPaperAxes,'YLim',[0,height]);

% Return the axes handle if requested
if nargout == 1
    varargout = {hPaperAxes};
end

end

