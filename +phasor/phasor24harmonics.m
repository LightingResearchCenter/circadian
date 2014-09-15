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
