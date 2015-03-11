function illuminance = rgb2lux(red,green,blue)
%RGB2LUX Summary of this function goes here
%   Detailed explanation goes here

import daysimeter12.*

[~, ~, ~, ~, V, ~] = constants;

illuminance = V(1)*red + V(2)*green + V(3)*blue;

end

