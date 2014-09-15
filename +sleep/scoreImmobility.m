function immobility = scoreImmobility(activity,noise)
%SCOREIMMOBILITY Score activity as immobile(1) or mobile(0)

% Set a threshold as twice the background noise
threshold = noise*2;

% Score immobility
immobility = activity < threshold;

end

