function [magnitude,angleHrs] = cos24hrphasor(x,y,timeArray)
% COS24HRPHASOR returns the 24 hour phasor using x and y
%	x is one data set
%   y is the other data set
%   timeArray is the common timestamps (in days) for the signals
%   magnitude is the phasor magnitude
%   angle is the phasor angle in hours

%fits the signals using a 24 hour cosine curve
[mesorX,amplitudeX,phiX] = cosinorfit(timeArray,x,1,1);
[mesorY,amplitudeY,phiY] = cosinorfit(timeArray,y,1,1);

%angle is just the difference in phases
angle = (phiX - phiY)/(2*pi);

%pshift is the number of points to shift so that the signals line up
pshift = angle/(timeArray(2) - timeArray(1));

%shift one signal so that they overlap
y = circshift(y, round(pshift));

fitX = mesorX + amplitudeX*cos(2*pi*timeArray + phiX);
fitY = mesorY + amplitudeY*cos(2*pi*timeArray + phiY);

%magnitude is just the normalized cross covariance (from wikipedia)
magnitude = (std(fitX)*std(fitY))/(std(x)*std(y));

angleHrs = angle*24;

if(angleHrs > 12)
    angleHrs = angleHrs - 24;
end
if(angleHrs < -12)
    angleHrs = angleHrs + 24;
end

end

