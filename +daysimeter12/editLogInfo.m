function varargout = editLogInfo(log_infoPath,varargin)
%EDITLOGINFO Edits a Daysimeter log_info.txt file
%   Function input is a path to a log_info file followed by name value
%   pairs. Alternatively a structure with matching fieldnames may be given
%   as input. If a parameter is not specified the the original value willl
%   be unchanged.
%
%   EXAMPLE:
%       parameters = struct;
%       parameters.status = daysimeter12.daysimeterStatus.Start;
%       parameters.startDateTime = now;
%       parameters.loggingInterval = 30;
%
%       daysimeter12.editLogInfo('log_info.txt',parameters)

% Initialize message string
message = '';

% Parse function inputs
[statusObj,startDateTime,loggingInterval] = parameterParser(varargin);

% Short circuit if no parameters provided
if isempty(statusObj) || isempty(startDateTime) || isempty(loggingInterval)
    % If output argument is requested return the message string
    if nargout == 1
        varargout{1} = message;
    end
    warning('File was not editted. At least one parameter is required.');
    return;
end

% Read the current file contents
logInfoTxt = daysimeter12.readloginfo(log_infoPath);
% Find the position of the first 3 line feed characters (char(10))
q = find(logInfoTxt==char(10),3,'first');

% Edit status if provided
if ~isempty(statusObj)
    % Write the status as an integer to a string
    s_status = sprintf('%i',uint32(statusObj));
    % Replace the first character with the new status character
    logInfoTxt(1) = s_status(1);
end

% Edit startDateTime if provided
if ~isempty(startDateTime)
    % Write the start date time as a string
    s_startDateTime = datestr(startDateTime,'mm-dd-yy HH:MM');
    % Replace the existing start date time
    logInfoTxt(q(2)+1:q(2)+14) = s_startDateTime;
end

% Edit loggingInterval if provided
if ~isempty(loggingInterval)
    % Write the logging interval as a 3 digit padded integer
    s_loggingInterval = sprintf('%03i',loggingInterval);
    % Replace the existing logging interval
    logInfoTxt(q(3)+1:q(3)+3) = s_loggingInterval;
end

% Open the file for writing, and erase existing contents
fidInfo = fopen(log_infoPath,'w');
% Create an opject that closes the file when the object is destroyed
c = onCleanup(@() fclose(fidInfo));
% Check for error messages
message = ferror(fidInfo);
% Continue if there is no erro message
if isempty(message)
    % Write the modified text to the file
    fprintf(fidInfo,logInfoTxt);
    % Check for error messages
    message = ferror(fidInfo);
end

% If output argument is requested return the message string
if nargout == 1
    varargout{1} = message;
end

end


function [statusObj,startDateTime,loggingInterval] = parameterParser(a)
% PARAMETERPARSER Parse and validate function inputs

% Create inputParser object
p = inputParser;
% Define default values
defaultStatus = [];
defaultStartDateTime = [];
defaultLoggingInterval = [];
% Add parameters to parser object
addParameter(p,'status',defaultStatus,@isStatus);
addParameter(p,'startDateTime',defaultStartDateTime,@isStartDateTime);
addParameter(p,'loggingInterval',defaultLoggingInterval,@isLoggingInterval);
% Parse the input
parse(p,a{:});

% Expand parameters
statusObj = p.Results.status;
startDateTime = p.Results.startDateTime;
loggingInterval = p.Results.loggingInterval;

end

function TF = isStatus(statusObj)
% ISSTATUS Validate statusObj as class daysimeterStatus

if numel(statusObj) == 1
    TF = isa(statusObj,'daysimeter12.daysimeterStatus');
else
    TF = false;
end

end


function TF = isStartDateTime(startDateTime)
% ISSTARTDATETIME Validate startDateTime format

% Short circuit if not a vector
if ~isvector(startDateTime)
    TF = false;
    return;
end

switch numel(startDateTime)
    case 1 % Single datenum or datetime
        TF = isnumeric(startDateTime) | isdatetime(startDateTime);
    case 3 % Short datevec
        TF = isnumeric(startDateTime);
    case 6 % Long datevec
        TF = isnumeric(startDateTime);
    otherwise
        TF = false;
end

end


function TF = isLoggingInterval(loggingInterval)
% ISLOGGINGINTERVAL Validate loggingInterval format

% Short circuit if not numeric or not one value
if numel(loggingInterval) ~= 1 || ~isnumeric(loggingInterval)
    TF = false;
    return;
end

% Test if within valid range
if loggingInterval >= 30 && loggingInterval <= 990
    % Test if multiple of 30
    TF = mod(loggingInterval,30) == 0;
else
    TF = false;
end

end