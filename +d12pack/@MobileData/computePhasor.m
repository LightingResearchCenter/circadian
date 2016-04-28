function Phasor = computePhasor(Time,CircadianStimulus,Epoch,ActivityIndex,Observation,varargin)
%PREP Summary of this function goes here
%   Detailed explanation goes here

% Preallocate output
Phasor = d12pack.PhasorData;

switch nargin
    case 6
        PhasorCompliance = varargin{1};
        InBed = false(size(Time));
    case 7
        PhasorCompliance = varargin{1};
        InBed = varargin{2};
    otherwise
        PhasorCompliance = true(size(Time));
        InBed = false(size(Time));
end

if ~isempty(Time) && ~isempty(CircadianStimulus) && ~isempty(ActivityIndex)
    
    % Assign value to zero when in bed
    CircadianStimulus(InBed) = 0;
    ActivityIndex(InBed) = 0;
    
    % Indicies to be removed
    idxRemove = ~Observation | ~PhasorCompliance;
    
    % Remove specified indicies
    Time(idxRemove) = [];
    CircadianStimulus(idxRemove) = [];
    ActivityIndex(idxRemove) = [];
    
    if ~isempty(Time)
        % Compute Phasor
        [Phasor.Vector,Phasor.Magnitude,Phasor.Angle,...
            Phasor.MagnitudeHarmonics,Phasor.FirstHarmonic] = ...
            phasor(datenum(Time),Epoch,CircadianStimulus,ActivityIndex);
    else
        
    end
    
end
% Compute Coverage of Phasor
Phasor.Coverage = Epoch*numel(Time);

end


function [vector,magnitude,Angle,magnitudeHarmonics,firstHarmonic] = phasor(Time,Epoch,signal1,signal2)
% PHASOR Compares two time dependent signals
%
%   Input:
%   timeArray is time in days or MATLAB datenum
%   epoch   is the sampling rate (duration object)
%   signal1 is the input signal to the system, this is generally light
%   signal2 is the output signal of the system, this is often activity
%
%   Output:
%   phasorVector is the complex representation of phasor magnitude and
%   angle
%
%   Reference(s):
%       Author(s), Title. Journal Abbrv. year; vol: pp-pp.
%
%   Example(s):
%   [phasorVector,magnitudeHarmonics,firstHarmonic] = phasor.phasor(timeArray,epoch,lightArray,activityArray)

% Calculate phasors
[vector,magnitude,Angle] = cos24hrphasor(Time,Epoch,signal1,signal2);

% f24H returns all the harmonics of the 24-hour rhythm (as complex numbers)
[f24H,f24] = phasor24harmonics(signal1,signal2,1/seconds(Epoch));
% the magnitude including all the harmonics
magnitudeHarmonics = sqrt(sum((abs(f24H).^2)));

firstHarmonic = abs(f24);

end


function [vector,magnitude,Angle] = cos24hrphasor(Time,Epoch,signal1,signal2)
% COS24HRPHASOR 24 hour phasor of signal1 and signal2
%
%   Input:
%   timeArray is the common timestamps (in days) for the signals
%   epoch     is the sampling rate (object of samplingrate class)
%   signal1   is the input signal to the system, this is generally light
%   signal2   is the output signal of the system, this is often activity
%
%   Output:
%   vector is the complex representation of phasor magnitude and angle
%
%   Reference(s):
%       Author(s), Title. Journal Abbrv. year; vol: pp-pp.
%
%   Example(s):
%   [vector,magnitude,angle] = cos24hrphasor(timeArray,epoch,signal1,signal2)


% Fits the signals using a 24 hour cosine curve.
[mesor1,amplitude1,phi1] = cosinorfit(Time,signal1,1,1);
[mesor2,amplitude2,phi2] = cosinorfit(Time,signal2,1,1);

% The phasor angle (in radians) is the difference in acrophases.
angleRad = mod((phi1 - phi2),2*pi);

% Shift signal2 so that it lines up with signal1.
% Number of points to shift is nShift.
nShift = angleRad/(2*pi*days(Epoch));
signal2 = circshift(signal2, round(nShift));

if angleRad > pi
    angleRad = -(2*pi -angleRad);
end

Angle = struct;
Angle.radians       = angleRad;
Angle.degrees       = angleRad*360/(2*pi);
Angle.days          = angleRad/(2*pi);
Angle.hours         = angleRad*24/(2*pi);
Angle.minutes       = angleRad*24*60/(2*pi);
Angle.seconds       = angleRad*24*60*60/(2*pi);
Angle.milliseconds	= angleRad*24*60*60*1000/(2*pi);


fit1 = mesor1 + amplitude1*cos(2*pi*Time + phi1);
fit2 = mesor2 + amplitude2*cos(2*pi*Time + phi2);

% Phasor magnitude is just the normalized cross covariance.
magnitude = (std(fit1)*std(fit2))/(std(signal1)*std(signal2));

% Convert from polar to complex.
vector = magnitude*(cos(angleRad)+1i*sin(angleRad));

end


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


function [f24H,f24] = phasor24harmonics(X,Y,Srate)
% Calculates the 24-hour complex phasor for time series x and y sampled at Srate in units of Hertz

if length(X)~=length(Y)
    error('vectors must be equal length')
end
% Crop data to integer number of days
q = round(floor(length(X)/(Srate*(24*3600)))*(24*3600)*Srate);
X = X(1:q);
Y = Y(1:q);

XCORR = (ifft(conj(fft(Y)).*fft(X))- mean(Y)*mean(X)*length(Y))/(std(Y)*std(X))/length(Y);
% XCORRshift = circshift(XCORR,floor(length(X)/2)); % place zero phase shift in the center of the graph

% FFT of entrainment-correlation curve
n = length(XCORR);
SrateCorr = Srate; % samples per second
temp = fft(XCORR)/n;
% mag = abs(temp);
% phase = angle(temp);
if  rem(n,2)==0 % is n even?
    %     MAGc(1:n/2+1) = [mag(1);2*mag(2:n/2);mag(n/2+1)]; % [dc; 2*(fundamental to nyquist-1); nyquist]
    %     PHASEc = 180/pi*phase(1:n/2+1); % degrees
    Complex = [temp(1);2*temp(2:n/2);temp(n/2+1)]; %zeros(n/2 - 2, 1)
else % else n is odd
    %     MAGc(1:(n+1)/2) = [mag(1);2*mag(2:(n+1)/2)]; % [dc; 2*(fundamental to nyquist)]
    %     PHASEc = 180/pi*phase(1:(n+1)/2); % degrees
    Complex = zeros(2, (n+1)/2 - 1);
    Complex = [temp(1);2*temp(2:(n+1)/2)];
end
Freq = [ 0 SrateCorr/n:SrateCorr/n:SrateCorr/2]'; % frequency in Hertz
Freq = Freq*(3600*24); % Convert from Hz to cycles per day
FreqInterval = Freq(2)-Freq(1);
f24 = Complex(Freq>1-FreqInterval/2 & Freq<1+FreqInterval/2); % frequency = 1 day (24 hours)
maxHarmonic = floor(max(Freq));
q = zeros(maxHarmonic,1);
for i1 = 1:maxHarmonic
    q1 = find(Freq>=i1-FreqInterval/2 & Freq<=i1+FreqInterval/2);
    if length(q1)==1
        q(i1) = q1;
    else
        q(i1) = q1(q1==max(q1));
    end
end
f24H = Complex(q);
end


