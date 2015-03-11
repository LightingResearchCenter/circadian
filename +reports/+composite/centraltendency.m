function Output = centraltendency(data)
%CENTRALTENDENCY Summary of this function goes here
%   Detailed explanation goes here

Output = struct;
Output.arithmeticMean = mean(data);
Output.geometricMean = geomean(data);
Output.median = median(data);

end

