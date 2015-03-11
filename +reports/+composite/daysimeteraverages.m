function Average = daysimeteraverages(light,activity,masks)
%DAYSIMETERAVERAGES Summary of this function goes here
%   Detailed explanation goes here

import reports.composite.*

% Preallocate output
template = struct(...
    'arithmeticMean'    , {[]},...
    'geometricMean'     , {[]},...
    'median'            , {[]});
Average = struct(...
    'cs'         , template,...
    'cla'        , template,...
    'illuminance', template,...
    'activity'   , template);


% Select compliant waking data
idx = masks.observation & masks.compliance & ~masks.bed;
cs = light.cs(idx);
cla = light.cla(idx);
lux = light.illuminance(idx);
ai = activity(idx);

% Duplicate data
cs2 = cs;
cla2 = cla;
lux2 = lux;
ai2 = ai;

% Replace low values
cs2(cs2 < 0.01) = 0.01;
cla2(cla2 < 1) = 1;
lux2(lux2 <1) = 1;
ai2(ai2 < 0.01) = 0.01;

% Average data
Average.cs.arithmeticMean = mean(cs);
Average.cs.geometricMean = geomean(cs2);
Average.cs.median = median(cs);

Average.cla.arithmeticMean = mean(cla);
Average.cla.geometricMean = geomean(cla2);
Average.cla.median = median(cla);

Average.illuminance.arithmeticMean = mean(lux);
Average.illuminance.geometricMean = geomean(lux2);
Average.illuminance.median = median(lux);

Average.activity.arithmeticMean = mean(ai);
Average.activity.geometricMean = geomean(ai2);
Average.activity.median = median(ai);

end

