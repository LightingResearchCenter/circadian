clear
close all
clc

filePath = 'test.cdf';
newFilePath = 'test-crop.cdf';
    
cdfData = daysimeter12.readcdf(filePath);
daysimeter12.cropcdf(filePath,newFilePath);

cdfDataCropped = daysimeter12.readcdf(newFilePath);