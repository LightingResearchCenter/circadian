function obj = import(obj,FilePath,varargin)
%IMPORT Summary of this function goes here
%   Detailed explanation goes here

[~,~,ext] = fileparts(FilePath);

switch ext
    case {'.xls','.xlsx','.xlsm','.xltx','.xltm'}
        s = warning('off','MATLAB:table:ModifiedVarnames');
        t = readtable(FilePath,...
            'FileType','spreadsheet',...
            'ReadVariableNames',true,...
            'Basic',true);
        warning(s);
    otherwise
        error('Weather log file must be a spreadsheet.');
end

% Select just the first and second columns
t = t(:,1:2);
% Rename the columns to ensure consistency
varNames = {'Date','Condition'};
t.Properties.VariableNames = varNames;
% If errant text was imported convert to double (unconvertable text becomes
% NaN
if iscell(t.Date)
    t.StartTime = str2double(t.StartTime);
end
% Remove empty rows
idx = isnan(t.Date) & cellfun(@isempty,t.Condition);
t(idx,:) = [];

if ~isempty(t)
    if nargin > 2
        TimeZone = varargin{1};
    else
        TimeZone = 'local';
    end
    % Convert Excel serial dates to datetime
    t.Date = datetime(t.Date,'ConvertFrom','excel','TimeZone',TimeZone);
    
    obj = d12pack.WeatherLogData(t.Date(:),t.Condition(:));
else
    warning(['Work log was empty or could not be imported.',char(10),FilePath]);
end

end

