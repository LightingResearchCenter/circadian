function disp(obj)
%DISP Summary of this function goes here
%   Detailed explanation goes here

falsetrue = {'false', 'true'};
IsFixed_str = falsetrue{obj.IsFixed + 1};

display(horzcat('    IsFixed: ',IsFixed_str,char(10)));
disp(obj.table);

end

