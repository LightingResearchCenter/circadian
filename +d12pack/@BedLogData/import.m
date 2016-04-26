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
        error('Calibration file must be a spreadsheet.');
end

% Select just the second and third columns
t = t(:,2:3);
% Rename the columns to ensure consistency
varNames = {'BedTime','RiseTime'};
t.Properties.VariableNames = varNames;
% Remove empty rows
idx = isnan(t.BedTime) & isnan(t.RiseTime);
t(idx,:) = [];

if ~isempty(t)
    if nargin > 2
        TimeZone = varargin{1};
    else
        TimeZone = 'local';
    end
    % Convert Excel serial dates to datetime
    t.BedTime = datetime(t.BedTime,'ConvertFrom','excel','TimeZone',TimeZone);
    t.RiseTime = datetime(t.RiseTime,'ConvertFrom','excel','TimeZone',TimeZone);
    
    n = numel(t.BedTime);
    for iC = n:-1:1
        obj(iC,1).BedTime = t.BedTime(iC);
        obj(iC,1).RiseTime = t.RiseTime(iC);
    end
else
    error('Failed to import bed log spreadsheet.');
end

end

