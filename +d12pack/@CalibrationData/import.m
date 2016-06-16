function obj = import(obj,FilePath,SerialNumber)
%IMPORT Import calibration data from file for a specific serial number
%   Example:
%   Calibration = d12pack.CalibrationData;
%   Calibration = Calibration.import(FilePath,SerialNumber);

[~,~,ext] = fileparts(FilePath);

varNames = {'SerialNumber','Red','Green','Blue','Date','Label','Notes'};
format = '%u16 %f %f %f %s %s %s';

switch ext
    case {'.dat','.txt','.csv'}
        t = readtable(FilePath,...
            'FileType','text',...
            'ReadVariableNames',true,...
            'Format',format,...
            'Delimiter',',');
    otherwise
        error('Calibration file must be comma delimited text (.dat, .txt, or .csv).');
end

t.Properties.VariableNames = varNames;

q = t.SerialNumber == SerialNumber;
t = t(q,:);

if ~isempty(t)
    % Convert date strings to datetime
    t.Date = datetime(t.Date,'InputFormat','yyyy-MMM-dd','TimeZone','America/New_York');
    
    n = numel(t.Red);
    for iC = n:-1:1
        obj(iC,1).Red = t.Red(iC);
        obj(iC,1).Green = t.Green(iC);
        obj(iC,1).Blue = t.Blue(iC);
        obj(iC,1).Date = t.Date(iC);
        obj(iC,1).Label = t.Label{iC};
    end
end

end

