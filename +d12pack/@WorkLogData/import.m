function obj = import(obj,FilePath,varargin)
%IMPORT Summary of this function goes here
%   Detailed explanation goes here

[~,~,ext] = fileparts(FilePath);

switch ext
    case {'.xls','.xlsx','.xlsm','.xltx','.xltm'}
        t = readtable(FilePath,...
            'FileType','spreadsheet',...
            'ReadVariableNames',true,...
            'Basic',true);
    otherwise
        error('Work log file must be a spreadsheet.');
end

% Select just the second, third, and fourth columns
t = t(:,2:4);
% Rename the columns to ensure consistency
varNames = {'Workstation','StartTime','EndTime'};
t.Properties.VariableNames = varNames;
% If errant text was imported convert to double (unconvertable text becomes
% NaN
if iscell(t.StartTime)
    t.StartTime = str2double(t.StartTime);
end
if iscell(t.EndTime)
    t.EndTime = str2double(t.EndTime);
end
% Remove empty rows
idx = isnan(t.StartTime) & isnan(t.EndTime);
t(idx,:) = [];

if ~isempty(t)
    if nargin > 2
        TimeZone = varargin{1};
    else
        TimeZone = 'local';
    end
    % Convert Excel serial dates to datetime
    t.StartTime = datetime(t.StartTime,'ConvertFrom','excel','TimeZone',TimeZone);
    t.EndTime = datetime(t.EndTime,'ConvertFrom','excel','TimeZone',TimeZone);
    
    n = numel(t.StartTime);
    for iC = n:-1:1
        obj(iC,1).StartTime = t.StartTime(iC);
        obj(iC,1).EndTime = t.EndTime(iC);
    end
else
    error('Failed to import work log spreadsheet.');
end

end

