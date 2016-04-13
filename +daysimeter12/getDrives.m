function drvs = getDrives
%GETDRIVES  Get the drive letters of all mounted filesystems.
%   DRVS = GETDRIVES returns the roots of all mounted filesystems as a cell
%   array of char arrays.
%
%   On Windows systems, this is a list of the names of all single-letter
%   mounted drives.
%
%   Does not work for non-Windows systems. This may be updated later.
%
%   Note that only the names of MOUNTED volumes are returned.  In
%   particular, removable media drives that do not have the media inserted
%   (such as an empty CD-ROM drive) are not returned.
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
    
    drvs = drvStr(drvExist);
    
elseif ismac
    volumesPath = [filesep,'Volumes'];
    listing = dir(volumesPath);
    drvNames = {listing(4:end).name}'; % ignores first 3 drives usually '.', '..', and 'Macintosh HD'
    drvs = fullfile(volumesPath,drvNames);
    
else
    error('Only Mac and Windows supported.')
end

end
