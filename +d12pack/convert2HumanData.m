function obj = convert2HumanData(log_info_path,data_log_path,cdfPath,bedLogPath)
%CONVERT2HUMANDATA Summary of this function goes here
%   Detailed explanation goes here

% Create object from source files
obj = d12pack.HumanData(log_info_path,data_log_path);

% Import CDF
cdfData = daysimeter12.readcdf(cdfPath);

% Add subject ID
obj.ID = cdfData.GlobalAttributes.subjectID;

% Add observation mask (accounting for cdfread error)
obj.Observation = false(size(obj.Time));
obj.Observation(1:numel(cdfData.Variables.logicalArray)) = logical(cdfData.Variables.logicalArray);

% Add compliance mask (accounting for cdfread error)
obj.Compliance = true(size(obj.Time));
obj.Compliance(1:numel(cdfData.Variables.complianceArray)) = logical(cdfData.Variables.complianceArray);

% Add bed log
obj.BedLog = obj.BedLog.import(bedLogPath);

end

