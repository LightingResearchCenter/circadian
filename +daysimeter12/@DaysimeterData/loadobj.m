function obj = loadobj(s)
%LOADOBJ Overloads the default load method
%   Constructs and loads object from file

% List of key properties that were saved
keyProp = {         ...
    'data_log';     ...
    'log_info';     ...
    'Calibration';  ...
    'Subject'};

if isstruct(s)
    obj = DaysimeterData;
    
    nProp = numel(keyProp);
    for iProp = 1:nProp
        obj.(keyProp{iProp}) = s.(keyProp{iProp});
    end
else
    obj = s;
end

end

