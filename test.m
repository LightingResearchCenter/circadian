clear
close all
clc

filePath = 'test.cdf';

[absTime,relTime,epoch,light,activity,masks] = daysimeter12.convertcdf(filePath);

[phasorVector,magnitudeHarmonics,firstHarmonic] = phasor.phasor(absTime.localDateNum,epoch,light.cs,activity);

figure(1);
[hAxes,hGrid,hLabels] = plots.phasoraxes;
[h,hLine,hHead] = plots.phasorarrow(phasorVector);
set(hLine,'LineWidth',2);
set(hLine,'Color','r');
set(hHead,'FaceColor','r');

[interdailyStability,intradailyVariability] = isiv.isiv(activity,epoch);

[         ~,millerCS] = millerize.millerize(relTime,light.cs,masks);
[millerTime,millerActivity] = millerize.millerize(relTime,activity,masks);

figure(2);
h = axes('Position',[0.125,0.125,0.75,0.75]);
h = plots.miller(millerTime,'Circadian Stimulus (CS)',millerCS,'Activity Index (AI)',millerActivity,h);


% WARNING: DFA is slow
% alpha = dfa.dfa(epoch,activity,1,[1.5,8]);