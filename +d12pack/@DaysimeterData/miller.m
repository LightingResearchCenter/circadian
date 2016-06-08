function MillerValue = miller(obj,Value,fun,varargin)
%HOURLY Summary of this function goes here
%   24 results for hours 0 - 23
%   fun is functinon handle or name see also FEVAL, ex. fun = 'mean'

idx = obj.Observation & ~obj.Error;
if isprop(obj,'Compliance');
    idx = idx & obj.Compliance;
end

if nargin == 4
    idx = idx & varargin{1};
end

Time = obj.Time(idx);
Value = Value(idx);

interval = 1/6;

Hours = hour(Time) + minute(Time)/60;
H = 0:interval:24;
nH = numel(H);
MillerValue = NaN(nH-1,1);
for iH = 1:nH-1
    idx = Hours >= H(iH) & Hours < H(iH+1);
    MillerValue(iH,1) = feval(fun,Value(idx));
end

end

