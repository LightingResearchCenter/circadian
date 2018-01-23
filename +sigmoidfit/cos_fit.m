function cm = cos_fit(X,y)
%COS_FIT Summary of this function goes here
%   Detailed explanation goes here

% Fit cosine using linear least squares
k = (2*pi)/24; % ratio of radians per period, period in units of t
chi = [sin(X.*k), cos(X.*k)];
mes = mean(y);
y2 = y - mes;
b = chi\y2;

amp = norm(b);
phi = atan2(b(1),b(2))/k;

fitted = mes + amp.*cos((X - phi).*k);

rsquared = 1 - sum((y-fitted).^2)/sum((y-mean(y)).^2);

cm = struct('mes',mes,'amp',amp,'phi',phi,'Fitted',fitted,'Rsquared',rsquared);
end