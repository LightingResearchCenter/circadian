function Phasor = phasoranalysis(timeArray,csArray,activityArray)
% PHASORANALYSIS Performs analysis on CS and activity
%   Input is verticle vectors of:
%       time (in days or MATLAB datenum)
%       circadian stimulus
%       activity
%   
%   Returns a struct with:
%       phasor magnitude,
%       phasor angle,
%       interdaily stability,
%       intradaily variability,
%       magnitude of harmonics,
%       magnitude of first harmonic


% Preallocate empty output struct
Phasor = struct(...
    'magnitude'             , {[]} ,...
    'angleHrs'              , {[]} ,...
    'interdailyStability'   , {[]} ,...
    'intradailyVariability' , {[]} ,...
    'magnitudeHarmonics'    , {[]} ,...
    'firstHarmonic'         , {[]} );

% Calculate epoch and sampling rate
epochSec = round(mode(diff(timeArray)*24*60*60)); % sampling epoch in seconds
samplingRateHrtz = 1/epochSec; % sample rate in Hertz

% Apply gaussian filter to data
filterWindow = ceil(300/epochSec); % approximate number of samples in 5 minutes
csArray = gaussian(csArray,filterWindow);
activityArray = gaussian(activityArray,filterWindow);

% Calculate interdaily stability and intradaily variablity
[Phasor.interdailyStability,Phasor.intradailyVariability] = isivcalc(activityArray,epochSec);

% Calculate phasors
[Phasor.magnitude,Phasor.angleHrs] = cos24hrphasor(csArray,activityArray,timeArray);

% f24H returns all the harmonics of the 24-hour rhythm (as complex numbers)
[f24H,f24] = phasor24harmonics(csArray,activityArray,samplingRateHrtz);
% the magnitude including all the harmonics
Phasor.magnitudeHarmonics = sqrt(sum((abs(f24H).^2)));

Phasor.firstHarmonic = abs(f24);

end
