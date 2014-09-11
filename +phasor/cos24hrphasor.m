function phasorVector = cos24hrphasor(timeArray,epoch,signal1,signal2)
% COS24HRPHASOR 24 hour phasor of signal1 and signal2
%
%   Input:
%   timeArray is the common timestamps (in days) for the signals
%   epoch     is the sampling rate (object of samplingrate class)
%   signal1   is the input signal to the system, this is generally light
%   signal2   is the output signal of the system, this is often activity
%   
%   Output:
%   phasorVector is the complex representation of phasor magnitude and
%   angle
%   
%   Reference(s):
%       Author(s), Title. Journal Abbrv. year; vol: pp-pp.
%   
%   Example(s):
%   phasorVector = cos24hrphasor(timeArray,epoch,signal1,signal2)

% Import the phasor package
import phasor.*

% Fits the signals using a 24 hour cosine curve.
[mesor1,amplitude1,phi1] = cosinorfit(timeArray,signal1,1,1);
[mesor2,amplitude2,phi2] = cosinorfit(timeArray,signal2,1,1);

% The phasor angle (in radians) is the difference in acrophases.
angle = (phi1 - phi2);

% Shift signal2 so that it lines up with signal1.
% Number of points to shift is nShift.
nShift = angle/(2*pi*epoch.days);
signal2 = circshift(signal2, round(nShift));

fit1 = mesor1 + amplitude1*cos(2*pi*timeArray + phi1);
fit2 = mesor2 + amplitude2*cos(2*pi*timeArray + phi2);

% Phasor magnitude is just the normalized cross covariance.
magnitude = (std(fit1)*std(fit2))/(std(signal1)*std(signal2));

% Convert from polar to complex.
phasorVector = magnitude*(cos(angle)+1i*sin(angle));

end

