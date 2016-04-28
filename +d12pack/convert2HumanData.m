function obj = convert2HumanData(log_info_path,data_log_path,cdfData,bedLogPath,varargin)
%CONVERT2HUMANDATA Summary of this function goes here
%   Detailed explanation goes here

% Create object from source files
obj = d12pack.HumanData(log_info_path,data_log_path);

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

% Add work log
if nargin == 5
    workLogPath = varargin{1};
    obj.WorkLog = obj.WorkLog.import(workLogPath);
else
    obj.WorkLog = d12pack.WorkLogData;
    obj.WorkLog.StartTime = duration(9,0,0);
    obj.WorkLog.EndTime = duration(17,0,0);
end

end

