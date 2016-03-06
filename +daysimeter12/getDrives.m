function drvs = getDrives
%GETDRIVES  Get the drive letters of all mounted filesystems.
%   DRVS = GETDRIVES returns the roots of all mounted filesystems as a cell
%   array of char arrays.
%   
%   On Windows systems, this is a list of the names of all single-letter 
%   mounted drives.
%
%   Does not work for non-Windows systems.
%
%   Note that only the names of MOUNTED volumes are returned.  In 
%   particular, removable media drives that do not have the media inserted 
%   (such as an empty CD-ROM drive) are not returned.
%
%   See also EXIST, COMPUTER, UIGETFILE, UIPUTFILE.

startLetter = 'd';
stopLetter = 'z';

drvNum = (double(startLetter):double(stopLetter))';
nDrv = numel(drvNum);
drvStr = cellstr([drvNum,repmat(':\',nDrv,1)]);

isDrv = @(x) exist(x,'dir') == 7;
drvExist = cellfun(isDrv,drvStr);

drvs = drvStr(drvExist);

end