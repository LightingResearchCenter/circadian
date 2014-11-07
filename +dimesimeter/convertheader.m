function [absTime,relTime,epoch,light,activity] = convertheader(filePath,dimeSN,utcOffsetHours)

import dimesimeter.*;

%process organized file
[labviewTime,lux,CLA,AI,~,X,Y] = processheader(filePath, dimeSN);

% Convert the time to custom time classes
absTime = absolutetime(labviewTime,'labview',false,utcOffsetHours,'hours');
relTime = relativetime(absTime);

% Find the most frequent sampling rate.
epochSeconds = mode(diff(relTime.seconds));

% Create a samplingrate object called epoch.
epoch = samplingrate(epochSeconds,'seconds');

% Apply gaussian filter to data
filterWindow = ceil(300/epochSeconds); % approximate number of samples in 5 minutes
lux = gaussian(lux,filterWindow);
CLA = gaussian(CLA,filterWindow);
AI  = gaussian(AI ,filterWindow);

chromaticity = chromcoord('x',X,'y',Y);

% Create an instance of lightmetrics
light = lightmetrics('illuminance',lux,'cla',CLA,'chromaticity',chromaticity);

activity = AI;

end