clear
close all
clc

filePath = 'test.cdf';

[absTime,relTime,light,activity,masks] = importD12(filePath);