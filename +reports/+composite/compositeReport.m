function compositeReport(plotDir,Phasor,Actigraphy,Average,Miller,subject,deviceID,figTitle)
%COMPOSITEREPORT Summary of this function goes here
%   Detailed explanation goes here

import reports.composite.*;
import plots.*

[hFigure,~,~,units] = reports.composite.initializefigure(1,'on');

fileName = ['compositeReport_',datestr(now,'yyyy-mm-dd_HHMM'),'_subject',subject,'_deviceID',deviceID];

%% Specify dimensions of plot areas
x1 = 0;
y1 = 3.875 - 0.375;
w1 = 4.5;
h1 = 3 + 0.25;
box1 = [x1,y1,w1,h1];

x2 = 5.375  - 0.5;
y2 = 3.875 - 0.125;
w2 = 4.5;
h2 = 3 - 0.25;
box2 = [x2,y2,w2,h2];

x3 = 0;
y3 = 1.25;
w3 = 4.5;
h3 = 1.625;
box3 = [x3,y3,w3,h3];

histWidth = 2;
histHeight = 1.625;

x4 = 5.375 - 0.5;
y4 = 1.25;
w4 = histWidth;
h4 = histHeight;
box4 = [x4,y4,w4,h4];

x5 = 7.875 - 0.5;
y5 = 1.25;
w5 = histWidth;
h5 = histHeight;
box5 = [x5,y5,w5,h5];

x6 = x4;
y6 = .625;
w6 = (x5+histWidth)-x4;
h6 = .125;
box6 = [x6,y6,w6,h6];

%% Make figure active
set(0,'CurrentFigure',hFigure)

%% Plot annotations
plotsubjectname(hFigure,subject,deviceID)

plotfooter(hFigure,figTitle);

%% Plot data

% Phasor plot
% Create axes to plot on
hPhasor = axes;
set(hPhasor,'Units',units);
set(hPhasor,'OuterPosition',box1);
set(hPhasor,'Units','normalized'); % Return to default
[hPhasor,hGrid,hLabels] = plots.phasoraxes(hPhasor);
[h,hLine,hHead] = plots.phasorarrow(Phasor.vector,1.5);
set(hLine,'LineWidth',2);
set(hLine,'Color','k');
set(hHead,'FaceColor','k');
% Eliminate excess white space
set(hPhasor, 'Position', get(gca, 'OuterPosition') - ...
    get(hPhasor, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);
% Plot Phsor Title
hPhasorTitle = title(hPhasor,'Circadian Stimulus/Activity Phasor');
hPhasorTitle.Visible = 'on';
hPhasorTitle.Position(2) = hPhasorTitle.Position(2)*1.125;

% Notes
plotnotes(Phasor,Actigraphy,Average,box3,units);

% Miller plot
% Create axes to plot on
hMiller = axes;
set(hMiller,'Units',units);
set(hMiller,'ActivePositionProperty','position');
set(hMiller,'Position',box2);
set(hMiller,'Units','normalized'); % Return to default
plots.miller(Miller.time,'Circadian Stimulus (CS)',Miller.cs,'Activity Index (AI)',Miller.activity,hMiller);
% Create title
hMillerTitle = title('Average Day');
hMillerTitle.Position(2) = hMillerTitle.Position(2)*1.125;

% Histograms
phasorangdist(Phasor.angle.hours,box4,units)
phasormagdist(Phasor.magnitude,box5,units)
plotnursenote(hFigure,box6,units)

%% Save file to disk
filePath = fullfile(plotDir,fileName);
print(gcf,'-dpdf',filePath,'-painters');

end

