function deviceSn = parseDeviceSn(logInfoTxt)
%PARSEDEVICESN return the daysimeters serial number
%   logInfoTxt should be the read in string of the daysimeter.

% Find the position of the first line feed character (char(10))
q = find(logInfoTxt==char(10),1,'first');
% Select the 4 characters after the line feed
deviceSn = logInfoTxt(q+1:q+4);

end

