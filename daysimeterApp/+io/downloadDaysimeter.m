function status = downloadDaysimeter(daysimeterPath,savePath,makeCsvFlag,makeCdfFlag)
%DOWNLOADDAYSIMETER Summary of this function goes here
%   Detailed explanation goes here

deviceSn = io.getDeviceSn(daysimeterPath);
nameStub = io.makeNameStub(deviceSn);

[status1,~,~] = io.copyLoginfo(daysimeterPath,savePath,nameStub);
[status2,~,~] = io.copyDatalog(daysimeterPath,savePath,nameStub);

if status1 == 1 && status2 == 1
    status = 'success';
else
    status = 'failure';
end

end

