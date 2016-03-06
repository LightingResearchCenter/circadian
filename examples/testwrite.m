clear
close all
clc

filePath = 'test.cdf';
newFilePath = 'test-copy.cdf';
    
cdfData = daysimeter12.readcdf(filePath);
daysimeter12.writecdf(cdfData, newFilePath);

cdfDataCopy = daysimeter12.readcdf(newFilePath);