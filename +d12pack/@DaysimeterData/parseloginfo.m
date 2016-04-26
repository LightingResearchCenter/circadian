function s = parseloginfo(obj,varargin)
%PARSELOGINFO Summary of this function goes here
%   Detailed explanation goes here

log_info = obj.log_info;

% Split into individual lines (seperator = [carriage return,line feed]
lines = regexp(log_info,'\r\n','split')';

% Serial Number is line 2
s.SerialNumber = uint16(str2double(lines{2}));

% Start is line 3
if nargin > 1
    timezone = varargin{1};
    if isempty(timezone)
        timezone = 'local';
    end
else
    timezone = 'local';
end
s.Start = datetime(lines{3},'InputFormat','MM-dd-yy HH:mm','TimeZone',timezone);

% Logging rate (epoch) is line 4 in seconds
s.Epoch = duration(0,0,str2double(lines{4}));

end

