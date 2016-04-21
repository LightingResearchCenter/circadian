function daysimeterPaths = getDaysimeters
%GETDAYSIMETERS Get a list of all Daysimeters connected to the computer
%   DAYSIMETERS = GETDAYSIMETERS retuns a cell array that contains strings of
%   the drive names that appear to be daysimters.

drivePaths = getDrives;

tf = cellfun(@isDaysimeter,drivePaths);

daysimeterPaths = drivePaths(tf);

end

function drivePaths = getDrives
%GETDRIVES  Get the drive letters of all mounted filesystems.
%   DRVS = GETDRIVES returns the roots of all mounted filesystems as a cell
%   array.
%
%   On Windows systems, this is a list of the names of all single-letter
%   mounted drives.
%
%   See also EXIST, COMPUTER, UIGETFILE, UIPUTFILE.

if ispc
    startLetter = 'd';
    stopLetter = 'z';
    
    drvNum = (double(startLetter):double(stopLetter))';
    nDrv = numel(drvNum);
    drvStr = cellstr([drvNum,repmat(':\',nDrv,1)]);
    
    isDrv = @(x) exist(x,'dir') == 7;
    drvExist = cellfun(isDrv,drvStr);
    
    drivePaths = drvStr(drvExist);
    
elseif ismac
    volumesPath = [filesep,'Volumes'];
    listing = dir(volumesPath);
    drvNames = {listing(:).name}';
    tf1 = strcmp(drvNames,'.');
    tf2 = strcmp(drvNames,'..');
    tf3 = strcmp(drvNames,'Macintosh HD');
    drvNames(tf1 | tf2 | tf3) = [];% ignores '.', '..', and 'Macintosh HD'
    drivePaths = fullfile(volumesPath,drvNames);
else
    error('Only Mac and Windows supported.')
end

end

function tf = isDaysimeter(drivePath)
%ISDAYSIMETER will tell if the drive appears to be a Daysimeter
%   TF = ISDAYSIMETER(DRV) where DRV is a Char array with the name of a drive.
%   It will return a logical true if the drive only has the two files necessary
%   for a daysimeter.

fileNames = {'log_info.txt';'data_log.txt'};
filePaths = fullfile(drivePath,fileNames);

isFile = @(x) exist(x,'file') == 2;
tf = all(cellfun(isFile,filePaths));

end

