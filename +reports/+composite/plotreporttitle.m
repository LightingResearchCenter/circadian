function varargout = plotreporttitle(hFigure,figTitle)
%PLOTREPORTTITLE Summary of this function goes here
%   hFigure = figure handle

import reports.composite.*;

% Create textbox
hReportTitle = annotation(hFigure,'textbox');

% Remove box outline and margin
lineStyle = 'none';
set(hReportTitle,'LineStyle',lineStyle);

margin = 0;
set(hReportTitle,'Margin',margin);

% Create text
todayStr = datestr(now,'mmmm dd, yyyy');
reportTitle = {figTitle;['Created: ',todayStr]};

% Add text to box
set(hReportTitle,'String',reportTitle);

% Make sure box resizes to text
fitBoxToText = 'on'; % 'on' or 'off'
set(hReportTitle,'FitBoxToText',fitBoxToText);

% Align text in box
horizontalAlignment = 'center';
set(hReportTitle,'HorizontalAlignment',horizontalAlignment);

verticalAlignment = 'top';
set(hReportTitle,'VerticalAlignment',verticalAlignment);

% Set font properties
fontUnits = 'points';
set(hReportTitle,'FontUnits',fontUnits);

fontSize = 16;
set(hReportTitle,'FontSize',fontSize);

fontName = 'Arial';
set(hReportTitle,'FontName',fontName);

fontWeight = 'bold';
set(hReportTitle,'FontWeight',fontWeight);

% Position box centered on the bottom of the page
set(hReportTitle,'Units','inches');

position = get(hReportTitle,'Position'); % get current position and size
paperPosition = get(hFigure,'PaperPosition');

width = position(3);
height = position(4);

paperWidth = paperPosition(3);

left = 0.5*paperWidth - 0.5*width; % Center the textbox
bottom = 0.5 - height;
if bottom < 0
    bottom = 0;
end

position = [left,bottom,width,height];
set(hReportTitle,'Position',position);

% Return the text handle if requested
if nargout == 1
    varargout = {hReportTitle};
end

end

