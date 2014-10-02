function compositeReport(plotDir,Phasor,Average,Miller,subject,figTitle)
%COMPOSITEREPORT Summary of this function goes here
%   Detailed explanation goes here

import reports.composite.*;
import plots.*

[hFigure,~,~,units] = initializefigure(1,'on');

fileName = ['compositeReport_',datestr(now,'yyyy-mm-dd_HHMM'),'_subject',subject];

%% Specify dimensions of plot areas
x1 = 0.25;
y1 = 3.875-.375;
w1 = 4.5;
h1 = 3+.375;
box1 = [x1,y1,w1,h1];

x2 = 5.375  - 0.5;
y2 = 3.875 - 0.25;
w2 = 4.5;
h2 = 3;
box2 = [x2,y2,w2,h2];

x3 = 0;
y3 = 1.25;
w3 = 5;
h3 = 2;
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
plotsubjectname(hFigure,subject)

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

% Notes
plotnotes(Phasor,Average,box3,units);

% Miller plot
% Create axes to plot on
hMiller = axes;
set(hMiller,'Units',units);
set(hMiller,'ActivePositionProperty','position');
set(hMiller,'Position',box2);
set(hMiller,'Units','normalized'); % Return to default
miller(Miller.time,'Circadian Stimulus (CS)',Miller.cs,'Activity Index (AI)',Miller.activity,hMiller);

% Histograms
phasorangdist(Phasor.angleHrs,box4,units)
phasormagdist(Phasor.magnitude,box5,units)
plotnursenote(hFigure,box6,units)

%% Save file to disk
filePath = fullfile(plotDir,fileName);
print(gcf,'-dpdf',filePath,'-painters');

end

