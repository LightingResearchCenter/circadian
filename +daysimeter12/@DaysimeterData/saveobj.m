function s = saveobj(obj)
%SAVEOBJ Overloads the default save method
%   Saves necessary properties as a structure

% List of key properties to be saved
keyProp = {         ...
    'data_log';     ...
    'log_info';     ...
    'Calibration';  ...
    'Subject'};

nProp = numel(keyProp);

for iProp = 1:nProp
    s.(keyProp{iProp}) = obj.(keyProp{iProp});
end

s.Modified = datetime('now','TimeZone','local');

end

