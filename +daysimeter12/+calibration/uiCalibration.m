function [selectedStart,selectedEnd,currentCal,oldLux,newLux,driftRates] = uiCalibration(data,IDnum,varargin)
%UICALIBRATION Summary of this function goes here
%   Detailed explanation goes here

%% Import dependencies
import('daysimeter12.*','daysimeter12.calibration.*');

%% Parse input
switch nargin
    case 3
        h = varargin{1};
        previousCal = [NaN;NaN;NaN];
        referenceIlluminance = 0;
        isLast = true;
    case 4
        h = varargin{1};
        previousCal = varargin{2};
        referenceIlluminance = 0;
        isLast = true;
    case 5
        h = varargin{1};
        previousCal = varargin{2};
        referenceIlluminance = varargin{3};
        isLast = true;
    case 6
        h = varargin{1};
        previousCal = varargin{2};
        referenceIlluminance = varargin{3};
        isLast = varargin{4};
    otherwise
        h = figure;
        previousCal = [NaN;NaN;NaN];
        referenceIlluminance = 0;
end

%% Specify date and time string formats
% Formats A support datenum and datestr,
% datetime uses and alternate convention.
dateFormatA = 'dd-mmm-yyyy';
timeFormatA = 'HH:MM:SS';
datetimeFormatA = [dateFormatA,' ',timeFormatA];
% Formats B support datetime conventions
dateFormatB = 'dd-MMM-yyyy';
timeFormatB = 'HH:mm:ss';
datetimeFormatB = [dateFormatB,' ',timeFormatB];

%% Specify formatspec for displaying illuminance
luxSpec = '%.3f';

%% Specify formatspc for displaying percent error
errSpec = '%.1f';

%% Attempt to automatically detect calibration periods
[startTimes,endTimes] = daysimeter12.calibration.findCalPlateau(data);

%% Prepare figure window
figure(h); % Make figure active
clf(h,'reset');
h.Name = 'Daysimeter Calibration';
h.Units = 'normalized';
h.OuterPosition = [0 0.05 1 0.95]; % Fill most of the screen

%% UI Panel
hPanel = uipanel(h);
hPanel.Units = 'normalized';
hPanel.Position(1) = 0;
hPanel.Position(2) = 0;
hPanel.Position(4) = 1;
hPanel.Units = 'points';
hPanel.Position(3) = 300;
hPanel.Units = 'normalized';

%% Create Axes
hAxes = axes;
hold(hAxes, 'on');
hAxes.Units = 'normalized';
axesX = hPanel.Position(1) + hPanel.Position(3);
axesWidth = 1 - axesX;
hAxes.OuterPosition = [axesX 0 axesWidth 1];
hAxes.ActivePositionProperty = 'outerposition';
hAxes.Color = [0.25 0.25 0.25];
hAxes.TickDir = 'out';
ylabel(hAxes,'Counts');
xlabel(hAxes,'Time');
hTitle = title(hAxes,['Daysimeter SN: ',num2str(IDnum)]);
hTitle.FontSize = 36;

%% Create zoom object and set zoom callback function
hZoom = zoom(h);
hZoom.ActionPostCallback = @zoomCallback;
    function zoomCallback(obj,event_obj)
        updateFill;
    end

%% Plot data
hData = plotData(hAxes,data);

%% Initialize selected start and end variable
selectedStart = startTimes(1);
selectedEnd = endTimes(1);

%% Initialize illuminance variables
oldLux = mean(calculateIlluminance(data,selectedStart,selectedEnd,previousCal));
currentCal = daysimeter12.calibration.calculateCalibration(data,selectedStart,selectedEnd,referenceIlluminance);
newLux = mean(calculateIlluminance(data,selectedStart,selectedEnd,currentCal));

%% Initialize percent error variables
oldError = (oldLux - referenceIlluminance)*100/referenceIlluminance;
newError = (newLux - referenceIlluminance)*100/referenceIlluminance;

%% Initialize drift rates
driftRates = calculateDriftRates(data,selectedStart,selectedEnd);

%% Plot selection highlight as fill
hHighlight = plotSelectionHighlight(hAxes,selectedStart,selectedEnd,'white');

%% Set default x position
x0 = 10/220;

%% Calibration period radiobuttons and title
periodTitle = uiText(hPanel,x0,1,'Choose Calibration Period:',10,'bold');
[periodButtonGroup,periodButtons] = selectionUI(hPanel,x0,periodTitle.Position(2),numel(startTimes));
    function [bGroup,rdButtons] = selectionUI(p,x0,y0,nPeriods)
        n = nPeriods + 1;
        
        vertMargin = 15;
        rdHeight = 20;
        
        bgHeight = n*rdHeight + vertMargin;
        
        bGroup = uibuttongroup(p,'Visible', 'off');
        bGroup.Units = 'points';
        bGroup.Position(4) = bgHeight;
        bGroup.Units = 'normalized';
        bgHeight_norm = bGroup.Position(4);
        bGroup.Position(1) = x0;
        bGroup.Position(2) = y0 - bgHeight_norm;
        bGroup.Position(3) = 1 - 2*x0;
        bGroup.SelectionChangedFcn = @bselection;
        bGroup.BorderType = 'none';
        
        rdButtons = cell(n,1);
        
        % Create radio buttons
        for iRd = 1:nPeriods;
            
            rdY = bgHeight - vertMargin - iRd*rdHeight;
            
            rdButtons{iRd} = uicontrol(bGroup, 'Style', 'radiobutton');
            rdButtons{iRd}.String = ['Period ',num2str(iRd)];
            rdButtons{iRd}.Units = 'points';
            rdButtons{iRd}.Position(2) = rdY;
            rdButtons{iRd}.Position(4) = rdHeight;
            rdButtons{iRd}.Units = 'normalized';
            rdButtons{iRd}.Position(1) = 0;
            rdButtons{iRd}.Position(3) = 1;
            
        end
        
        rdY = bgHeight - vertMargin - n*rdHeight;
        
        rdButtons{n} = uicontrol(bGroup, 'Style', 'radiobutton');
        rdButtons{n}.String = 'Custom';
        rdButtons{n}.Units = 'points';
        rdButtons{n}.Position(2) = rdY;
        rdButtons{n}.Position(4) = rdHeight;
        rdButtons{n}.Units = 'normalized';
        rdButtons{n}.Position(1) = 0;
        rdButtons{n}.Position(3) = 1;
        
        % Make the uibuttongroup visible after creating child objects.
        bGroup.Visible = 'on';
        
        function bselection(source,callbackdata)
            if strcmp(callbackdata.NewValue.String,'Custom')
                setPeriodCustom;
            else
                selectionStr = regexprep(callbackdata.NewValue.String,'\D*(\d*)\D*','$1');
                selection = str2double(selectionStr);
                selectedStart = startTimes(selection);
                selectedEnd = endTimes(selection);
                startField.String = datestr(selectedStart,timeFormatA);
                endField.String = datestr(selectedEnd,timeFormatA);
                updateFill;
                updateCalibration;
            end
        end
        
    end

%% Start time title, text field, and select button
startTitle = uiText(hPanel,x0,periodButtonGroup.Position(2),'Start Time:',10,'bold');
startField = uiTimeField(hPanel,x0,startTitle.Position(2),selectedStart);
startButton = uiSelectButton(hPanel,x0,startField.Position(1)+startField.Position(3),startField.Position(2),startField);

%% End time title, text field, and select button
endTitle = uiText(hPanel,x0,startField.Position(2),'End Time:',10,'bold');
endField = uiTimeField(hPanel,x0,endTitle.Position(2),selectedEnd);
endButton = uiSelectButton(hPanel,x0,endField.Position(1)+endField.Position(3),endField.Position(2),endField);

%% UI time field
    function fld = uiTimeField(p,x0,y0,initVal)
        % Create text field
        fld = uicontrol(p, 'Style', 'edit');
        fld.String = datestr(initVal,timeFormatA);
        fld.Units = 'points';
        fld.Position = [0, 0, 100, 20];
        fld.Units = 'normalized';
        fld.Position(1) = x0;
        fld.Position(2) = y0 - fld.Position(4);
        fld.Position(3) = (1 - 3*fld.Position(1))/2;
        fld.Callback = @fldEdit;
        
        function fldEdit(source,callbackdata)
            setPeriodCustom;
            updateStartEnd;
            updateFill;
        end
    end

%% UI select button
    function btn = uiSelectButton(p,margin,x0,y0,hField)
        % Create push button
        btn = uicontrol(p, 'Style', 'pushbutton');
        btn.String = 'Select';
        btn.Units = 'points';
        btn.Position = [0, 0, 100, 25];
        btn.Units = 'normalized';
        btn.Position(1) = x0 + margin;
        btn.Position(2) = y0;
        btn.Position(3) = 0.5 - margin;
        btn.Callback = @bselection;
        
        function bselection(hObject, eventdata, handles)
            % hObject    handle to pushbutton1 (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            setPeriodCustom;
            [newPoint,~] = ginput(1);
            hField.String = datestr(newPoint,timeFormatA);
            updateStartEnd;
            updateFill;
        end
        
    end

%% Reference illuminance title and text field
luxLabel = uiText(hPanel,x0,endField.Position(2),'Reference Illuminance (lux):',10,'bold');
luxField = uiLuxField(hPanel,x0,luxLabel.Position(2),referenceIlluminance);
    function fld = uiLuxField(p,x0,y0,initVal)
        % Create text field
        fld = uicontrol(p, 'Style', 'edit');
        fld.String = num2str(initVal);
        fld.Units = 'points';
        fld.Position = [0, 0, 100, 20];
        fld.Units = 'normalized';
        fld.Position(1) = x0;
        fld.Position(2) = y0 - fld.Position(4);
        fld.Position(3) = 1 - 2*fld.Position(1);
        fld.Callback = @fldEdit;
        
        function fldEdit(source,callbackdata)
            updateCalibration;
        end
    end

%% Calibration Factors Label and Table
calibrationTitle = uiText(hPanel,x0,luxField.Position(2),'Calibration Factors:',10,'bold');
calibrationTable = uiCalibrationTable(hPanel,x0,calibrationTitle.Position(2),previousCal);
    function tbl = uiCalibrationTable(p,x0,y0,previousCal)
        % create the data
        currentCal = daysimeter12.calibration.calculateCalibration(data,selectedStart,selectedEnd,referenceIlluminance);
        d = [(previousCal(:))'; (currentCal(:))'];
        
        % Create the column and row names in cell arrays
        cnames = {'Red','Green','Blue'};
        rnames = {'Previous','Current'};
        
        % Create the uitable
        tbl = uitable(p);
        tbl.Data = d;
        tbl.ColumnName = cnames;
        tbl.RowName = rnames;
        
        % Set width and height
        tbl.Units = 'normalized';
        tbl.Position(3) = 1 - 2*x0;
        tbl.Position(4) = tbl.Extent(4);
        
        % Set position x and y
        tbl.Position(1) = x0;
        tbl.Position(2) = y0 - tbl.Position(4);
        
        % Set column width
        tbl.Units = 'pixels';
        columnWidth = tbl.Position(3)/(numel(cnames)+1.5);
        tbl.ColumnWidth = {columnWidth,columnWidth,columnWidth};
        tbl.Units = 'normalized';
    end

%% Mean illuminance display
titleStr = sprintf('Mean Illuminance Using Previous Calibration:');
oldLuxTitle = uiText(hPanel,x0,calibrationTable.Position(2),titleStr,10,'bold');
oldLuxStr = [num2str(oldLux,luxSpec),' lux'];
oldLuxText = uiText(hPanel,x0,oldLuxTitle.Position(2),oldLuxStr,10);

titleStr = sprintf('Mean Illuminance Using Current Calibration:');
newLuxTitle = uiText(hPanel,x0,oldLuxText.Position(2),titleStr,10,'bold');
newLuxStr = [num2str(newLux,luxSpec),' lux'];
newLuxText = uiText(hPanel,x0,newLuxTitle.Position(2),newLuxStr,10);

%% Percent error display
titleStr = sprintf('Percent Error Using Previous Calibration:');
oldErrorTitle = uiText(hPanel,x0,newLuxText.Position(2),titleStr,10,'bold');
oldErrorStr = [num2str(mean(oldError),errSpec),' %'];
oldErrorText = uiText(hPanel,x0,oldErrorTitle.Position(2),oldErrorStr,10);

titleStr = sprintf('Mean Illuminance Using Current Calibration:');
newErrorTitle = uiText(hPanel,x0,oldErrorText.Position(2),titleStr,10,'bold');
newErrorStr = [num2str(mean(newError),errSpec),' %'];
newErrorText = uiText(hPanel,x0,newErrorTitle.Position(2),newErrorStr,10);

%% Save and continue/exit pushbutton
saveButton = uiSave(hPanel,x0,0,isLast);
    function btn = uiSave(p,x0,y0,isLast)
        % Create push button
        btn = uicontrol(p, 'Style', 'pushbutton');
        if isLast
            btn.String = 'Save and Exit';
        else
            btn.String = 'Save and Continue';
        end
        btn.FontSize = 10;
        btn.Units = 'normalized';
        btn.Position(1) = x0;
        btn.Position(3) = 1 - 2*btn.Position(1);
        btn.Position(4) = 1.5*btn.Extent(4);
        btn.Position(2) = y0;
        btn.Units = 'pixels';
        btn.Position(2) = btn.Position(2) + 5;
        btn.Units = 'normalized';
        btn.Callback = @bselection;
        
        function bselection(hObject, eventdata, handles)
            % hObject    handle to pushbutton (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            if isLast
                close(h);
            else
                resetFigure;
            end
        end
        
    end

%% Exit without saving pushbutton
exitButton = uiExit(hPanel,x0,saveButton.Position(2)+saveButton.Position(4),isLast);
    function btn = uiExit(p,x0,y0,isLast)
        % Create push button
        btn = uicontrol(p, 'Style', 'pushbutton');
        if isLast
            btn.String = 'Exit Without Saving';
        else
            btn.String = 'Continue Without Saving';
        end
        btn.FontSize = 10;
        btn.Units = 'normalized';
        btn.Position(1) = x0;
        btn.Position(3) = 1 - 2*btn.Position(1);
        btn.Position(4) = 1.5*btn.Extent(4);
        btn.Position(2) = y0;
        btn.Units = 'pixels';
        btn.Position(2) = btn.Position(2) + 5;
        btn.Units = 'normalized';
        btn.Callback = @bselection;
        
        function bselection(hObject, eventdata, handles)
            % hObject    handle to pushbutton (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            
            selectedStart = NaN;
            selectedEnd = NaN;
            currentCal = NaN(1,3);
            oldLux = NaN;
            newLux = NaN;
            driftRates = NaN(1,3);
            
            if isLast
                close(h);
            else
                resetFigure;
            end
        end
        
    end

%% Align interface objects
handleList = [oldLuxTitle,oldLuxText,newLuxTitle,newLuxText,oldErrorTitle,oldErrorText,newErrorTitle,newErrorText,saveButton,exitButton];
align(handleList,'VerticalAlignment','Distribute');

%% Update selection highlight fill
    function updateFill
        hHighlight.XData = datenum([selectedStart;selectedStart;selectedEnd;selectedEnd]);
        hHighlight.YData = [hAxes.YLim(1);hAxes.YLim(2);hAxes.YLim(2);hAxes.YLim(1)];
    end


%% Update selected start and end variables
    function updateStartEnd
        baseDate = datestr(floor(datenum(data.datetime(1))),dateFormatA);
        newStart = [baseDate,' ',startField.String];
        selectedStart = datetime(newStart,'InputFormat',datetimeFormatB);
        newEnd = [baseDate,' ',endField.String];
        selectedEnd = datetime(newEnd,'InputFormat',datetimeFormatB);
        
        updateCalibration;
        updateDriftRates;
    end

%% Set selected period radiobutton to Custom
    function setPeriodCustom
        periodButtonGroup.SelectedObject = periodButtons{end};
    end

%% Update calibration factors
    function updateCalibration
        referenceIlluminance = str2double(luxField.String);
        currentCal = calculateCalibration(data,selectedStart,selectedEnd,referenceIlluminance);
        calibrationTable.Data(2,:) = currentCal;
        
        updateIlluminance;
    end

%% Update illuminance display
    function updateIlluminance
        oldLux = mean(calculateIlluminance(data,selectedStart,selectedEnd,previousCal));
        newLux = mean(calculateIlluminance(data,selectedStart,selectedEnd,currentCal));
        
        oldLuxText.String = [num2str(oldLux,luxSpec),' lux'];
        newLuxText.String = [num2str(newLux,luxSpec),' lux'];
        
        updatePercentError;
    end

%% Update percent error display
    function updatePercentError
        oldError = (oldLux - referenceIlluminance)*100/referenceIlluminance;
        newError = (newLux - referenceIlluminance)*100/referenceIlluminance;
        
        oldErrorText.String = [num2str(mean(oldError),errSpec),' %'];
        newErrorText.String = [num2str(mean(newError),errSpec),' %'];
    end

%% Update drift rate
    function updateDriftRates
        driftRates = calculateDriftRates(data,selectedStart,selectedEnd);
    end

%% Reset UI figure
    function resetFigure
        delete(hPanel);
        delete(hAxes);
    end

%% Wait for axes to be deleted before exiting function
waitfor(hAxes);
% Clear the figure window if it still exists
if ishandle(h)
    clf(h);
    waitMessage(h);
end

end

function hData = plotData(hAxes,data,varargin)

switch nargin
    case 3
        marker = varargin{1};
        legendColor = 'white';
    case 4
        marker = varargin{1};
        legendColor = varargin{1};
    otherwise
        marker = 'o';
        legendColor = 'white';
end

dataColors = {'red','green','blue'};

hData = plot(hAxes,data.datetime,[data.R,data.G,data.B]);
for iObj = 1:numel(hData)
    hData(iObj).Marker = marker;
    hData(iObj).Color = dataColors{iObj};
end

dataLabels = {'Red Channel','Green Channel','Blue Channel'};
hLegend = legend(hAxes,dataLabels,'Location','NorthEast');
hLegend.Color = legendColor;


end

function hHighlight = plotSelectionHighlight(hAxes,startTime,endTime,varargin)
%PLOTSELECTIONHIGHLIGHT Create a fill object behind the plotted data
%   hAxes is the parent axes object
%   startTime and endTime are datetime
%   optional input of color in ColorSpec
%
%   See also FILL, DATETIME, and COLORSPEC.

% Specify color to use for highlight
if nargin == 4 % If color is provided use that
    highlightColor = varargin{1};
else % Default color
    highlightColor = 'white';
end

% Get Axes limits from parent axes
yMin = hAxes.YLim(1);
yMax = hAxes.YLim(2);
zMin = hAxes.ZLim(1);

% Create X and Y arrays
X = datenum([startTime;startTime;endTime;endTime]);
Y = [yMin;yMax;yMax;yMin];

% Plot highlight as fill object
hHighlight = fill(X,Y,highlightColor);

% Force highlight behind other objects
hHighlight.ZData = repmat(zMin,size(X));

% Remove edge from highlight
hHighlight.EdgeColor = 'none';
end

function txt = uiText(p,x0,y0,textStr,varargin)
% Create UI text
txt = uicontrol(p, 'Style', 'text');
txt.String = textStr;

switch nargin
    case 5
        fontSize = varargin{1};
        fontWeight = 'normal';
    case 6
        fontSize = varargin{1};
        fontWeight = varargin{2};
    otherwise
        fontSize = 10;
        fontWeight = 'normal';
end
txt.FontSize = fontSize;
txt.FontWeight = fontWeight;
txt.Units = 'normalized';
txt.Position(1) = x0;
txt.Position(3) = 1 - 2*txt.Position(1);
txt.Position(4) = txt.Extent(4);
txt.Position(2) = y0 - txt.Extent(4);
txt.Units = 'pixels';
txt.Position(2) = txt.Position(2) - 5;
txt.Units = 'normalized';
end

function illuminance = calculateIlluminance(data,startTime,endTime,calibrationFactors)
%CALCULATEILLUMINANCE Apply calibration to data and calculate illuminance

% Select data from specified period
idx = data.datetime >= startTime & data.datetime <= endTime;
selection = data(idx,:);

% Apply calibration to selection
red = selection.R*calibrationFactors(1);
green = selection.G*calibrationFactors(2);
blue = selection.B*calibrationFactors(3);

% Calculate illuminance from calibrated data
illuminance = daysimeter12.rgb2lux(red,green,blue);

end

function driftRates = calculateDriftRates(data,startTime,endTime)

% Select data from specified period
idx = data.datetime >= startTime & data.datetime <= endTime;
selection = data(idx,:);

dT_seconds = seconds(selection.datetime(end) - selection.datetime(1));
dR = selection.R(end) - selection.R(1);
dG = selection.G(end) - selection.G(1);
dB = selection.B(end) - selection.B(1);

driftRates = [dR,dG,dB]/dT_seconds;
end

function waitMessage(h)
msg = uicontrol(h, 'Style', 'text');
msg.String = 'Please wait...';
msg.FontSize = 48;
msg.Units = 'normalized';
msg.Position(3) = msg.Extent(3);
msg.Position(4) = msg.Extent(4);
msg.Position(1) = 0.5 - msg.Extent(3)/2;
msg.Position(2) = 0.5 - msg.Extent(4)/2;
end