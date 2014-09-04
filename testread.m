clear
close all
clc

filePath = 'test.cdf';

[absTime,relTime,epoch,light,activity,masks] = daysimeter12.convertcdf(filePath);