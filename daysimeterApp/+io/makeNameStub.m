function nameStub = makeNameStub(deviceSn)
%MAKENAMESTUB creates the daysimeters downloaded name string. 
%   IDnum is the serial number for the daysimeter

t = datestr(now,'yyyy-mm-dd-HH-MM-SS');
nameStub = [num2str(deviceSn,'%04u'),'-',t];

end

