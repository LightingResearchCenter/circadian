close all
clear
clc

rt = now;

% Data import
filePath = 'test.cdf';
cdfData = daysimeter12.readcdf(filePath);
[absTime,relTime,epoch,light,activity,masks] = daysimeter12.convertcdf(cdfData);
subject = cdfData.GlobalAttributes.subjectID;

%Reference function
Actigraphy = isiv.prep(absTime,epoch,activity,masks);

% Prep data
time = absTime.localDateNum;
time(~masks.observation) = [];
activity(~masks.observation) = [];

if ~isempty(masks.compliance)
    masks.compliance(~masks.observation) = [];
end

if ~isempty(masks.bed)
    masks.bed(~masks.observation) = [];
    activity(masks.bed) = 0;
end

masks.observation(~masks.observation) = [];

if ~isempty(masks.compliance) && ~isempty(masks.bed)
    masks.compliance = isiv.adjustcrop(time,masks.compliance,masks.bed);
end

if ~isempty(masks.compliance)
    time(~masks.compliance) = [];
    activity(~masks.compliance) = [];
end

% Analyze data
[iv_m,iv_60] = isiv.IVm(activity,epoch);
[is_m,is_60] = isiv.ISm(activity,epoch);
