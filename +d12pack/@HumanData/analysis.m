function t = analysis(obj)
%ANALYSIS Summary of this function goes here
%   Detailed explanation goes here

SerialNumber = {obj.SerialNumber}';
ID = {obj.ID}';
temp = repmat({[]},size(ID));
sectionBreak = temp;
location = vertcat(obj.Location);
session = vertcat(obj.Session);
phasor = vertcat(obj.Phasor);

WakingCoverage              = days(vertcat(obj.WakingCoverage));
MeanWakingActivityIndex     = vertcat(obj.MeanWakingActivityIndex);
MeanWakingIlluminance       = vertcat(obj.MeanWakingIlluminance);
MeanWakingCircadianLight    = vertcat(obj.MeanWakingCircadianLight);
MeanWakingCircadianStimulus = vertcat(obj.MeanWakingCircadianStimulus);
GeometricMeanWakingIlluminance = vertcat(obj.GeometricMeanWakingIlluminance);
GeometricMeanWakingCircadianLight = vertcat(obj.GeometricMeanWakingCircadianLight);

AtWorkCoverage              = hours(vertcat(obj.AtWorkCoverage));
MeanAtWorkActivityIndex     = vertcat(obj.MeanAtWorkActivityIndex);
MeanAtWorkIlluminance       = vertcat(obj.MeanAtWorkIlluminance);
MeanAtWorkCircadianLight    = vertcat(obj.MeanAtWorkCircadianLight);
MeanAtWorkCircadianStimulus = vertcat(obj.MeanAtWorkCircadianStimulus);
GeometricMeanAtWorkIlluminance       = vertcat(obj.GeometricMeanAtWorkIlluminance);
GeometricMeanAtWorkCircadianLight    = vertcat(obj.GeometricMeanAtWorkCircadianLight);

PreWorkCoverage              = hours(vertcat(obj.PreWorkCoverage));
MeanPreWorkActivityIndex     = vertcat(obj.MeanPreWorkActivityIndex);
MeanPreWorkIlluminance       = vertcat(obj.MeanPreWorkIlluminance);
MeanPreWorkCircadianLight    = vertcat(obj.MeanPreWorkCircadianLight);
MeanPreWorkCircadianStimulus = vertcat(obj.MeanPreWorkCircadianStimulus);
GeometricMeanPreWorkIlluminance       = vertcat(obj.GeometricMeanPreWorkIlluminance);
GeometricMeanPreWorkCircadianLight    = vertcat(obj.GeometricMeanPreWorkCircadianLight);

PostWorkCoverage              = hours(vertcat(obj.PostWorkCoverage));
MeanPostWorkActivityIndex     = vertcat(obj.MeanPostWorkActivityIndex);
MeanPostWorkIlluminance       = vertcat(obj.MeanPostWorkIlluminance);
MeanPostWorkCircadianLight    = vertcat(obj.MeanPostWorkCircadianLight);
MeanPostWorkCircadianStimulus = vertcat(obj.MeanPostWorkCircadianStimulus);
GeometricMeanPostWorkIlluminance       = vertcat(obj.GeometricMeanPostWorkIlluminance);
GeometricMeanPostWorkCircadianLight    = vertcat(obj.GeometricMeanPostWorkCircadianLight);

VariableNames = {...
    'Serial_Number',...
    'ID',...
    'City_State',...
    'Building_Name',...
    'Session_Name',...
    ...
    'Section_Break_0',...
    ...
    'Wing',...
    'Floor',...
    'Workstation',...
    'Exposure',...
    ...
    'Section_Break_1',...
    ...
    'Phasor_Coverage_Days',...
    'Phasor_Magnitude',...
    'Phasor_Angle_Hours',...
    ...
    'Section_Break_2',...
    ...
    'Waking_Coverage_Days',...
    'Mean_Waking_Activity_Index',...
    'Mean_Waking_Illuminance',...
    'Mean_Waking_Circadian_Light',...
    'Mean_Waking_Circadian_Stimulus',...
    'Geometric_Mean_Waking_Illuminance',...
    'Geometric_Mean_Waking_Circadian_Light',...
    ...
    'Section_Break_3',...
    ...
    'At_Work_Coverage_Hours',...
    'Mean_At_Work_Activity_Index',...
    'Mean_At_Work_Illuminance',...
    'Mean_At_Work_Circadian_Light',...
    'Mean_At_Work_Circadian_Stimulus',...
    'Geometric_Mean_At_Work_Illuminance',...
    'Geometric_Mean_At_Work_Circadian_Light',...
    ...
    'Section_Break_4',...
    ...
    'Pre_Work_Coverage_Hours',...
    'Mean_Pre_Work_Activity_Index',...
    'Mean_Pre_Work_Illuminance',...
    'Mean_Pre_Work_Circadian_Light',...
    'Mean_Pre_Work_Circadian_Stimulus',...
    'Geometric_Mean_Pre_Work_Illuminance',...
    'Geometric_Mean_Pre_Work_Circadian_Light',...
    ...
    'Section_Break_5',...
    ...
    'Post_Work_Coverage_Hours',...
    'Mean_Post_Work_Activity_Index',...
    'Mean_Post_Work_Illuminance',...
    'Mean_Post_Work_Circadian_Light',...
    'Mean_Post_Work_Circadian_Stimulus',...
    'Geometric_Mean_Post_Work_Illuminance',...
    'Geometric_Mean_Post_Work_Circadian_Light'};

t = table(...
    SerialNumber,...
    ID,...
    temp,... % City_State
    temp,... % Building_Name
    temp,... % Session_Name
    ...
    sectionBreak,...
    ...
    temp,... % Wing
    temp,... % Floor
    temp,... % Workstation
    temp,... % Exposure
    ...
    sectionBreak,...
    ...
    temp,... % Phasor_Coverage_Days
    temp,... % Phasor_Magnitude
    temp,... % Phasor_Angle_Hours
    ...
    sectionBreak,...
    ...
    WakingCoverage,...
    MeanWakingActivityIndex,...
    MeanWakingIlluminance,...
    MeanWakingCircadianLight,...
    MeanWakingCircadianStimulus,...
    GeometricMeanWakingIlluminance,...
    GeometricMeanWakingCircadianLight,...
    ...
    sectionBreak,...
    ...
    AtWorkCoverage,...
    MeanAtWorkActivityIndex,...
    MeanAtWorkIlluminance,...
    MeanAtWorkCircadianLight,...
    MeanAtWorkCircadianStimulus,...
    GeometricMeanAtWorkIlluminance,...
    GeometricMeanAtWorkCircadianLight,...
    ...
    sectionBreak,...
    ...
    PreWorkCoverage,...
    MeanPreWorkActivityIndex,...
    MeanPreWorkIlluminance,...
    MeanPreWorkCircadianLight,...
    MeanPreWorkCircadianStimulus,...
    GeometricMeanPreWorkIlluminance,...
    GeometricMeanPreWorkCircadianLight,...
    ...
    sectionBreak,...
    ...
    PostWorkCoverage,...
    MeanPostWorkActivityIndex,...
    MeanPostWorkIlluminance,...
    MeanPostWorkCircadianLight,...
    MeanPostWorkCircadianStimulus,...
    GeometricMeanPostWorkIlluminance,...
    GeometricMeanPostWorkCircadianLight,...
    'VariableNames',VariableNames);

for ii = 1:numel(ID)
    t.City_State{ii,1} = [location(ii).City,', ',location(ii).PostalStateAbbreviation];
    t.Building_Name{ii,1} = location(ii).BuildingName;
    t.Session_Name{ii,1} = session(ii).Name;
    
    t.Wing{ii,1} = location(ii).Wing;
    t.Floor{ii,1} = location(ii).Floor;
    t.Workstation{ii,1} = location(ii).Workstation;
    t.Exposure{ii,1} = location(ii).Exposure;
    
    t.Phasor_Coverage_Days{ii,1} = days(phasor(ii).Coverage);
    t.Phasor_Magnitude{ii,1} = phasor(ii).Magnitude;
    if ~isempty(phasor(ii).Angle)
        t.Phasor_Angle_Hours{ii,1} = phasor(ii).Angle.hours;
    end
end

end

