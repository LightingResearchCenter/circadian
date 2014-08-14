function [mesor,amplitude,phi] = cosinorfit(timeArray,valueArray,Freq,fitOrder)
% COSINORFIT
%   time is the timestamps in days
%   value is the set of values you're fitting
%   Freq is the frequency in 1/days
%	fitOrder is the order of the fit

% preallocate variables
amplitude = zeros(1,fitOrder);
phi       = zeros(1,fitOrder);

C = zeros(2*fitOrder + 1, 2*fitOrder + 1);
D = zeros(1, 2*fitOrder + 1);

n = numel(timeArray);
omega = zeros(1,fitOrder);
xj    = zeros(n,fitOrder);
zj    = zeros(n,fitOrder);
for i1 = 1:fitOrder
    omega(i1) = 2*i1*pi*Freq;
    xj(:,i1) = cos(omega(i1)*timeArray);
    zj(:,i1) = sin(omega(i1)*timeArray);
end

yj = zeros(size(xj));
for i2 = 2:2:2*fitOrder
    yj(:,i2 - 1) = xj(:,i2/2);
    yj(:,i2) = zj(:,i2/2);
end

num = length(timeArray);

C(1, 1) = num;
for i3 = 2:2:2*fitOrder
    C(1, i3) = sum(xj(:,i3/2));
    C(i3, 1) = sum(xj(:,i3/2));
    C(1, i3 + 1) = sum(zj(:,i3/2));
    C(i3 + 1, 1) = sum(zj(:,i3/2));
end

for i4 = 2:2*fitOrder + 1
    for j4 = 2:2*fitOrder + 1
        C(i4, j4) = sum(yj(:,(i4 - 1)).*yj(:,(j4 - 1)));
    end
end

D(1) = sum(valueArray);
for i5 = 2:2*fitOrder + 1
    D(i5) = sum(yj(:,(i5 - 1)).*(valueArray));
end

D = D';

x = C\D;

mesor = x(1);

for i6 = 1:fitOrder
    amplitude(i6) = sqrt(x(2*i6)^2 + (x(2*i6 + 1)^2));
    phi(i6) = -atan2(x(2*i6 + 1), x(2*i6));
end


end

