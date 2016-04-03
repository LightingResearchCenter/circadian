function handels = createUserInterface()
% CREATEUSERINTERFACE will creat the GUI used to start and stop daysimeters
% handels = CREATEUSERINTERFACE() will generate all of the handels used to
% control the GUI used to start/stop/resume daysimeters and to download them.
%% Create the Window
handels = struct();
mp = get(groot,'monitorposition');
window = floor([.33*mp(1,3),.33*mp(1,4),.33*mp(1,3),.33*mp(1,4)]);
handels.head = figure('DockControl',   'off',...
           'MenuBar',       'none',...
           'Name',          'Daysimeter Start/Stop Hub',...
           'NumberTitle',   'off',...
           'ToolBar',       'None',...
           'units',         'pixel',...
           'Position',      window);
%% default directory
saveloc = getenv('DAYSIMSAVELOC');
if strcmpi(saveloc, '')
    daysimeter12.changeDefaultDir(handels)
end
%% Start up Interface

handels.daysimSearch = uipanel(handels.head,...
    'Units',    'pixel',...
    'Position', floor([0*window(3),0*window(4),1*window(3),1*window(4)]),...
    'fontsize', 10,...
    'Visible','on');
buttonGroup = floor([.05*window(3),.05*window(4),.90*window(3),.60*window(4)]);
handels.search.searchButtons = uipanel(handels.daysimSearch,...
    'Units',    'pixels',...
    'Position', buttonGroup,...
    'title',    '',...
    'fontsize', 10);

handels.search.exit = uicontrol(handels.search.searchButtons,...
    'Units',    'pixel',...
    'Position', floor([0.1*buttonGroup(3), 0.01*buttonGroup(4), 0.75*buttonGroup(3), 0.2*buttonGroup(4)]),...
    'String',   'Quit',...
    'callback', 'delete(gcbf)',...
    'fontsize', 12);
handels.search.search = uicontrol(handels.search.searchButtons,...
    'Units',    'pixel',...
    'Position', floor([0.1*buttonGroup(3), 0.66*buttonGroup(4), 0.75*buttonGroup(3), 0.2*buttonGroup(4)]),...
    'String',   'Search',...
    'callback', 'daysimeter12.search(handels)',...
    'fontsize', 12);
handels.search.changeDir = uicontrol(handels.search.searchButtons,...
    'Units',    'pixel',...
    'Position', floor([0.1*buttonGroup(3), 0.33*buttonGroup(4), 0.75*buttonGroup(3), 0.2*buttonGroup(4)]),...
    'String',   'Change Default Save Directory',...
    'callback', 'daysimeter12.changeDefaultDir(handels)',...
    'fontsize', 12);

handels.search.titleBlock = uicontrol(handels.daysimSearch,...
    'style',    'text',...
    'units',    'pixel',...
    'position', floor([.05*window(3),.80*window(4),.9*window(3),.15*window(4)]),...
    'string',   'Daysimeter Start Stop Hub',...
    'fontsize', 12);

handels.search.instructBlock = uicontrol(handels.daysimSearch,...
    'style',    'text',...
    'units',    'pixel',...
    'position', floor([.05*window(3),.70*window(4),.9*window(3),.15*window(4)]),...
    'string',   'Click Search to find Daysimeters',...
    'fontsize', 10);


%% Daysimeters found interface
handels.daysimFound = uipanel(handels.head,...
    'Units',    'pixel',...
    'Position', floor([0*window(3),0*window(4),1*window(3),1*window(4)]),...
    'fontsize', 10,...
    'Visible',  'off');
buttonGroup = floor([.05*window(3),.05*window(4),.90*window(3),.60*window(4)]);
handels.found.startStopButtons = uipanel(handels.daysimFound,...
    'Units',    'pixel',...
    'Position', buttonGroup,...
    'title',    'Change Current Log',...
    'fontsize', 10);

handels.found.startbutton = uicontrol(handels.found.startStopButtons,...
    'Style',    'pushbutton',...
    'units',    'pixel',...
    'Position', floor([0.1*buttonGroup(3), 0.66*buttonGroup(4), 0.75*buttonGroup(3), 0.2*buttonGroup(4)]),...
    'String',   'Start',...
    'callback', 'daysimeter12.startDaysimeters(handels)',...
    'fontsize', 10);

handels.found.stopbutton = uicontrol(handels.found.startStopButtons,...
    'Style',    'pushbutton',...
    'units',    'pixel',...
    'Position', floor([0.1*buttonGroup(3), 0.33*buttonGroup(4), 0.75*buttonGroup(3), 0.2*buttonGroup(4)]),...
    'String',   'Stop and Download',...
    'callback', 'daysimeter12.stopDaysimeters(handels)',...
    'fontsize', 10);

handels.found.continuebutton = uicontrol(handels.found.startStopButtons,...
    'Style',    'pushbutton',...
    'units',    'pixel',...
    'Position', floor([0.1*buttonGroup(3), 0.01*buttonGroup(4), 0.75*buttonGroup(3), 0.2*buttonGroup(4)]),...
    'String',   'Continue',...
    'callback', 'daysimeter12.resumeDaysimeters(handels)',...
    'fontsize', 10);

handels.found.titleBlock = uicontrol(handels.daysimFound,...
    'style',    'text',...
    'units',    'pixel',...
    'position', floor([.05*window(3),.80*window(4),.9*window(3),.15*window(4)]),...
    'string',   'Daysimeter Start Stop Hub',...
    'fontsize', 12);

handels.found.instructBlock = uicontrol(handels.daysimFound,...
    'style',    'text',...
    'units',    'pixel',...
    'position', floor([.05*window(3),.70*window(4),.9*window(3),.15*window(4)]),...
    'string',   'What would you like to do with these Daysimeters?',...
    'fontsize', 10);

%% error Window
handels.error = uipanel(handels.head,...
    'Units',    'pixel',...
    'Position', floor([0*window(3),0*window(4),1*window(3),1*window(4)]),...
    'fontsize', 10,...
    'Visible',  'off');
handels.errorControl.titleBlock = uicontrol(handels.error,...
    'style',    'text',...
    'units',    'pixel',...
    'position', floor([.05*window(3),.80*window(4),.9*window(3),.15*window(4)]),...
    'string',   'Daysimeter Start Stop Hub',...
    'fontsize', 12);
handels.errorControl.instructBlock = uicontrol(handels.error,...
    'style',    'text',...
    'units',    'pixel',...
    'position', floor([.05*window(3),.5*window(4),.9*window(3),.25*window(4)]),...
    'string',   'There was a know error that was not corrected for... find Tim or Geoff',...
    'fontsize', 10);
%% New Log Info Selection
currentDate = datevec(now);
handels.logInfo = uipanel(handels.head,...
    'Units',    'pixel',...
    'Position', floor([0*window(3),0*window(4),1*window(3),1*window(4)]),...
    'fontsize', 10,...
    'Visible',  'off');
handels.logInfoControl.titleBlock = uicontrol(handels.logInfo,...
    'style',    'text',...
    'units',    'pixel',...
    'position', floor([.05*window(3),.80*window(4),.9*window(3),.15*window(4)]),...
    'string',   'Daysimeter Start Stop Hub',...
    'fontsize', 12);
handels.logInfoControl.instructBlock = uicontrol(handels.logInfo,...
    'style',    'text',...
    'units',    'pixel',...
    'position', floor([.05*window(3),.70*window(4),.9*window(3),.15*window(4)]),...
    'string',   'Please Selcting Starting Information',...
    'fontsize', 10);
buttonGroup = floor([.05*window(3),.05*window(4),.90*window(3),.70*window(4)]);
handels.logInfoControl.startInfo = uipanel(handels.logInfo,...
    'Units',    'pixel',...
    'Position', buttonGroup,...
    'title',    'Startinging Information',...
    'fontsize', 10);
handels.logInfoControl.startMonth = uicontrol(handels.logInfoControl.startInfo,...
    'Style',    'popupmenu',...
    'units',    'pixel',...
    'Position', floor([0.05*buttonGroup(3), 0.60*buttonGroup(4), 0.11*buttonGroup(3), 0.2*buttonGroup(4)]),...
    'String',   {'month',num2str((1:12)')},...
    'callback', '',...
    'fontsize', 10);
handels.logInfoControl.startDay = uicontrol(handels.logInfoControl.startInfo,...
    'Style',    'popupmenu',...
    'units',    'pixel',...
    'Position', floor([0.17*buttonGroup(3), 0.60*buttonGroup(4), 0.11*buttonGroup(3), 0.2*buttonGroup(4)]),...
    'String',   {'day',num2str((1:31)')},...
    'callback', '',...
    'fontsize', 10);

handels.logInfoControl.startYear = uicontrol(handels.logInfoControl.startInfo,...
    'Style',    'popupmenu',...
    'units',    'pixel',...
    'Position', floor([0.30*buttonGroup(3), 0.60*buttonGroup(4), 0.11*buttonGroup(3), 0.2*buttonGroup(4)]),...
    'String',   {'year',num2str((currentDate(1):currentDate(1)+10)')},...
    'callback', '',...
    'fontsize', 10);
handels.logInfoControl.startHour = uicontrol(handels.logInfoControl.startInfo,...
    'Style',    'popupmenu',...
    'units',    'pixel',...
    'Position', floor([0.43*buttonGroup(3), 0.60*buttonGroup(4), 0.11*buttonGroup(3), 0.2*buttonGroup(4)]),...
    'String',   {'Hour',num2str((1:24)')},...
    'callback', '',...
    'fontsize', 10);
handels.logInfoControl.startMinute = uicontrol(handels.logInfoControl.startInfo,...
    'Style',    'popupmenu',...
    'units',    'pixel',...
    'Position', floor([0.55*buttonGroup(3), 0.60*buttonGroup(4), 0.11*buttonGroup(3), 0.2*buttonGroup(4)]),...
    'String',   {'Minute',num2str((1:60)')},...
    'callback', '',...
    'fontsize', 10);
handels.logInfoControl.setCurrentTime = uicontrol(handels.logInfoControl.startInfo,...
    'Style',    'pushbutton',...
    'units',    'pixel',...
    'Position', floor([0.68*buttonGroup(3), 0.70*buttonGroup(4), 0.20*buttonGroup(3), 0.1*buttonGroup(4)]),...
    'String',   'Use Current time',...
    'callback', 'daysimeter12.useCurrentTime(handels)',...
    'fontsize', 10);
handels.logInfoControl.startLogInterval = uicontrol(handels.logInfoControl.startInfo,...
    'Style',    'popupmenu',...
    'units',    'pixel',...
    'Position', floor([0.05*buttonGroup(3), 0.40*buttonGroup(4), 0.20*buttonGroup(3), 0.2*buttonGroup(4)]),...
    'String',   {'Log Interval',num2str((30:30:180)')},...
    'callback', '',...
    'fontsize', 10);
handels.logInfoControl.quickSelection = uicontrol(handels.logInfoControl.startInfo,...
    'Style',    'pushbutton',...
    'units',    'pixel',...
    'Position', floor([0.68*buttonGroup(3), 0.50*buttonGroup(4), 0.20*buttonGroup(3), 0.1*buttonGroup(4)]),...
    'String',   'Quick Set Up',...
    'callback', 'daysimeter12.quickSetup(handels)',...
    'fontsize', 10);
handels.logInfoControl.start = uicontrol(handels.logInfoControl.startInfo,...
    'Style',    'pushbutton',...
    'units',    'pixel',...
    'Position', floor([0.05*buttonGroup(3), 0.1*buttonGroup(4), 0.9*buttonGroup(3), 0.3*buttonGroup(4)]),...
    'String',   'Start',...
    'callback', 'daysimeter12.writeStartInfo(handels)',...
    'fontsize', 12);
end

