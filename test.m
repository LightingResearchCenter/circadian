clear
close all
clc

filePath = 'test.cdf';

[absTime,relTime,epoch,light,activity,masks] = daysimeter12.convertcdf(filePath);

[phasorVector,magnitudeHarmonics,firstHarmonic] = phasor.phasor(absTime.localDateNum,epoch,light.cs,activity);

[interdailyStability,intradailyVariability] = isiv.isiv(activity,epoch);

[millerTime,millerDataArray] = millerize.millerize(relTime,activity,masks);
figure(1)
plot(millerTime.hours,millerDataArray)

[millerTime,millerDataArray] = millerize.millerize(relTime,light.cs,masks);
figure(2)
plot(millerTime.hours,millerDataArray)

alpha = dfa.dfa(epoch,activity,1,[1.5,8]);