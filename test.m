clear
close all
clc

filePath = 'test.cdf';
cdfData = daysimeter12.readcdf(filePath);
[absTime,relTime,epoch,light,activity,masks] = daysimeter12.convertcdf(cdfData);
subject = cdfData.GlobalAttributes.subjectID;

Phasor = phasor.prep(absTime,epoch,light,activity,masks);

Actigraphy = struct;
[Actigraphy.interdailyStability,Actigraphy.intradailyVariability] = isiv.isiv(activity,epoch);

Miller = struct('time',[],'cs',[],'activity',[]);
[         ~,Miller.cs] = millerize.millerize(relTime,light.cs,masks);
[Miller.time,Miller.activity] = millerize.millerize(relTime,activity,masks);

Average = reports.composite.daysimeteraverages(light.cs,light.illuminance,activity);
reports.composite.compositeReport('',Phasor,Actigraphy,Average,Miller,subject,'Composite Report Test')

% WARNING: DFA is slow
% alpha = dfa.dfa(epoch,activity,1,[1.5,8]);