function nameStub = makeNameStub(IDnum)
%MAKENAMESTUB Summary of this function goes here
%   Detailed explanation goes here

t = datestr(now,'yyyy-mm-dd-HH-MM-SS');
nameStub = [num2str(IDnum,'%04u'),'-',t];

end

