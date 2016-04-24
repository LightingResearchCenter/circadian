function Coefficients = double(obj)
%DOUBLE Overloads double converter method
%   Returns array in format [R,G,B]

Coefficients = horzcat(vertcat(obj.R),vertcat(obj.G),vertcat(obj.B));

end

