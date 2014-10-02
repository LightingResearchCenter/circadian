function varargout = plotnursenote(hFigure,position,units)
%PLOTNURSENOTE Summary of this function goes here
%   hFigure = figure handle

import reports.composite.*;

% Create textbox
hNurseNote = annotation(hFigure,'textbox','Units',units,'Position',position);

% Remove box outline and margin
lineStyle = 'none';
set(hNurseNote,'LineStyle',lineStyle);

margin = 0;
set(hNurseNote,'Margin',margin);

% Make sure box does not resize to text
fitBoxToText = 'off'; % 'on' or 'off'
set(hNurseNote,'FitBoxToText',fitBoxToText);

% Create text
nurseNote = '*1, *2, and *3 are rotating shift nurses 1, 2, and 3 days respectively';

% Add text to box
set(hNurseNote,'String',nurseNote);

% Align text in box
horizontalAlignment = 'center';
set(hNurseNote,'HorizontalAlignment',horizontalAlignment);

verticalAlignment = 'top';
set(hNurseNote,'VerticalAlignment',verticalAlignment);

% Set font properties
fontUnits = 'points';
set(hNurseNote,'FontUnits',fontUnits);

fontSize = 8;
set(hNurseNote,'FontSize',fontSize);

fontName = 'Arial';
set(hNurseNote,'FontName',fontName);

% Return the text handle if requested
if nargout == 1
    varargout = {hNurseNote};
end

end

