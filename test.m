clear
close all
clc

filePath = 'test.cdf';

[absTime,relTime,epoch,light,activity,masks] = daysimeter12.convertcdf(filePath);

[phasorVector,magnitudeHarmonics,firstHarmonic] = phasor.phasor(absTime.localDateNum,epoch,light.cs,activity);

[interdailyStability,intradailyVariability] = isiv.isiv(activity,epoch);