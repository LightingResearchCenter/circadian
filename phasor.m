function [phasorVector,magnitudeHarmonics,firstHarmonic] = phasor(timeArray,epoch,signal1,signal2)
% PHASOR Compares two time dependent signals
%   
%   Input:
%   timeArray is time in days or MATLAB datenum
%   epoch   is the sampling rate (object of samplingrate class)
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
%   [phasorVector,magnitudeHarmonics,firstHarmonic] = phsor(timeArray,epoch,lightArray,activityArray)

% Calculate phasors
phasorVector = phasor.cos24hrphasor(timeArray,epoch,signal1,signal2);

% f24H returns all the harmonics of the 24-hour rhythm (as complex numbers)
[f24H,f24] = phasor.phasor24harmonics(signal1,signal2,epoch.hertz);
% the magnitude including all the harmonics
magnitudeHarmonics = sqrt(sum((abs(f24H).^2)));

firstHarmonic = abs(f24);

end
