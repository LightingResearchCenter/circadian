function HourlyValue = hourly(obj,Value,fun,varargin)
%HOURLY Summary of this function goes here
%   24 results for hours 0 - 23
%   fun is functinon handle or name see also FEVAL, ex. fun = 'mean'

idx = obj.Observation & ~obj.Error;
if isprop(obj,'Compliance');
    idx = idx & obj.Compliance;
end
if isprop(obj,'InBed')
    if ~isempty(obj.InBed)
        idx = idx & ~obj.InBed;
    end
end
if nargin == 4
    idx = idx & varargin{1};
end

Time = obj.Time(idx);
Value = Value(idx);

Hours = hour(Time);
HourlyValue = NaN(24,1);
for iH = 0:23
    idx = Hours == iH;
    HourlyValue(iH+1,1) = feval(fun,Value(idx));
end

end

