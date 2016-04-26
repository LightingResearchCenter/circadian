function Coefficients = double(obj)
%DOUBLE Overloads double converter method
%   Returns array in format [R,G,B]

Coefficients = horzcat(vertcat(obj.Red),vertcat(obj.Green),vertcat(obj.Blue));

end

