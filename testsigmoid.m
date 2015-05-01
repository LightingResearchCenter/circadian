close all
clear
clc

filePath = 'test.cdf';
cdfData = daysimeter12.readcdf(filePath);
[absTime,relTime,epoch,light,activity,masks] = daysimeter12.convertcdf(cdfData);
subject = cdfData.GlobalAttributes.subjectID;

idx = 6561:13201;
X = relTime.hours(idx);
y = activity(idx);


mdl = sigmoidfit.antilog_fit(X,y)

plot(X,y,'.',X,mdl.Fitted,'-');