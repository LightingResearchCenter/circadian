function c = cos_trans(t,phi)
%COS_TRANS Summary of this function goes here
%   phi = acrophase, time of day of the peak of the model
%   k = ratio of radians per period, period in units of t
%   ex. k = (2*pi)/24 for t in hours and a period of 1 day

k = (2*pi)/24;
c = cos((t - phi).*k);

end

