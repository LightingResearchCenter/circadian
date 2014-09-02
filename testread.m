clear
close all
clc

filePath = 'test.cdf';

[absTime,relTime,light,activity,masks] = daysimeter12.convertcdf(filePath);