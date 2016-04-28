function t = analysis(obj)
%ANALYSIS Summary of this function goes here
%   Detailed explanation goes here

p = gcp();

ID = {obj.ID}';
temp = repmat({[]},size(ID));
phasor = vertcat(obj.Phasor);

t = table(ID,temp,temp,'VariableNames',{'ID','Phasor_Magnitude','Phasor_Angle_Hours'});

for ii = 1:numel(ID)
    t.Phasor_Magnitude{ii,1} = phasor(ii).Magnitude;
    if ~isempty(phasor(ii).Angle)
        t.Phasor_Angle_Hours{ii,1} = phasor(ii).Angle.hours;
    end
end

end

