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

hReportTitle.Position(1) = 0.5*hFigure.Position(3) - 0.5*hReportTitle.Position(3); % Center the textbox
hReportTitle.Position(2) = 0.5-hReportTitle.Position(4);

% Return the text handle if requested
if nargout == 1
    varargout = {hReportTitle};
end

end

