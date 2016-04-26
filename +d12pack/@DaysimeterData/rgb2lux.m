function Illuminance = rgb2lux(Red,Green,Blue)
%RGB2LUX Summary of this function goes here
%   Detailed explanation goes here


V = [0.382859 0.604808 0.017628];

Illuminance = V(1)*Red + V(2)*Green + V(3)*Blue;

end

