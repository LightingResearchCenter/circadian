function t = analysis(obj)
%ANALYSIS Summary of this function goes here
%   Detailed explanation goes here

SerialNumber = {obj.SerialNumber}';
tempCell = repmat({[]},size(SerialNumber));
tempNum = NaN(size(SerialNumber));
sectionBreak = tempCell;
location = vertcat(obj.Location);
session = vertcat(obj.Session);

Orientation = {obj.Orientation}';
Type = {obj.Type}';

HourlyMeanIlluminance       = (horzcat(obj.HourlyMeanIlluminance))';
HourlyMeanCircadianLight    = (horzcat(obj.HourlyMeanCircadianLight))';
HourlyMeanCircadianStimulus = (horzcat(obj.HourlyMeanCircadianStimulus))';

str0_23 = num2str((0:23)','%02.0f');

HourlyMeanIlluminance_Names = repmat('Hourly_Mean_Illuminance_h',24,1);
HourlyMeanIlluminance_Names = [HourlyMeanIlluminance_Names,str0_23];
HourlyMeanIlluminance_Names = (cellstr(HourlyMeanIlluminance_Names))';

HourlyMeanCircadianLight_Names = repmat('Hourly_Mean_Circadian_Light_h',24,1);
HourlyMeanCircadianLight_Names = [HourlyMeanCircadianLight_Names,str0_23];
HourlyMeanCircadianLight_Names = (cellstr(HourlyMeanCircadianLight_Names))';

HourlyMeanCircadianStimulus_Names = repmat('Hourly_Mean_Circadian_Stimulus_h',24,1);
HourlyMeanCircadianStimulus_Names = [HourlyMeanCircadianStimulus_Names,str0_23];
HourlyMeanCircadianStimulus_Names = (cellstr(HourlyMeanCircadianStimulus_Names))';

VariableNames = [{...
    'Serial_Number',...
    'City_State',...
    'Building_Name',...
    'Session_Name',...
    ...
    'Section_Break_0',...
    ...
    'Wing',...
    'Floor',...
    'Workstation',...
    'Window_Proximity',...
    'Exposure',...
    'Orientation',...
    'Type',...
    ...
    'Section_Break_1'},...
    ...
    HourlyMeanIlluminance_Names,...
    ...
    {'Section_Break_2'},...
    ...
    HourlyMeanCircadianLight_Names,...
    ...
    {'Section_Break_3'},...
    ...
    HourlyMeanCircadianStimulus_Names...
    ];

t = table(...
    SerialNumber,...
    tempCell,... % City_State
    tempCell,... % Building_Name
    tempCell,... % Session_Name
    ...
    sectionBreak,...
    ...
    tempCell,... % Wing
    tempCell,... % Floor
    tempCell,... % Workstation
    tempCell,... % Window_Proximity
    tempCell,... % Exposure
    Orientation,...
    Type,...
    ...
    sectionBreak,...
    ...
    tempNum,... % 00
    tempNum,... % 01
    tempNum,... % 02
    tempNum,... % 03
    tempNum,... % 04
    tempNum,... % 05
    tempNum,... % 06
    tempNum,... % 07
    tempNum,... % 08
    tempNum,... % 09
    tempNum,... % 10
    tempNum,... % 11
    tempNum,... % 12
    tempNum,... % 13
    tempNum,... % 14
    tempNum,... % 15
    tempNum,... % 16
    tempNum,... % 17
    tempNum,... % 18
    tempNum,... % 19
    tempNum,... % 20
    tempNum,... % 21
    tempNum,... % 22
    tempNum,... % 23
    ...
    sectionBreak,...
    ...
    tempNum,... % 00
    tempNum,... % 01
    tempNum,... % 02
    tempNum,... % 03
    tempNum,... % 04
    tempNum,... % 05
    tempNum,... % 06
    tempNum,... % 07
    tempNum,... % 08
    tempNum,... % 09
    tempNum,... % 10
    tempNum,... % 11
    tempNum,... % 12
    tempNum,... % 13
    tempNum,... % 14
    tempNum,... % 15
    tempNum,... % 16
    tempNum,... % 17
    tempNum,... % 18
    tempNum,... % 19
    tempNum,... % 20
    tempNum,... % 21
    tempNum,... % 22
    tempNum,... % 23
    ...
    sectionBreak,...
    ...
    tempNum,... % 00
    tempNum,... % 01
    tempNum,... % 02
    tempNum,... % 03
    tempNum,... % 04
    tempNum,... % 05
    tempNum,... % 06
    tempNum,... % 07
    tempNum,... % 08
    tempNum,... % 09
    tempNum,... % 10
    tempNum,... % 11
    tempNum,... % 12
    tempNum,... % 13
    tempNum,... % 14
    tempNum,... % 15
    tempNum,... % 16
    tempNum,... % 17
    tempNum,... % 18
    tempNum,... % 19
    tempNum,... % 20
    tempNum,... % 21
    tempNum,... % 22
    tempNum,... % 23
    'VariableNames',VariableNames);

for ii = 1:numel(SerialNumber)
    t.City_State{ii,1} = [location(ii).City,', ',location(ii).PostalStateAbbreviation];
    t.Building_Name{ii,1} = location(ii).BuildingName;
    t.Session_Name{ii,1} = session(ii).Name;
    
    t.Wing{ii,1}             = location(ii).Wing;
    t.Floor{ii,1}            = location(ii).Floor;
    t.Workstation{ii,1}      = location(ii).Workstation;
    t.Window_Proximity{ii,1} = location(ii).WindowProximity;
    t.Exposure{ii,1}         = location(ii).Exposure;
end

for jj = 1:24
    t.(HourlyMeanIlluminance_Names{jj}) = HourlyMeanIlluminance(:,jj);
    t.(HourlyMeanCircadianLight_Names{jj}) = HourlyMeanCircadianLight(:,jj);
    t.(HourlyMeanCircadianStimulus_Names{jj}) = HourlyMeanCircadianStimulus(:,jj);
end

end

