function s = analysis(obj)
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

HourlyGeometricMeanIlluminance       = (horzcat(obj.HourlyGeometricMeanIlluminance))';
HourlyGeometricMeanCircadianLight    = (horzcat(obj.HourlyGeometricMeanCircadianLight))';
HourlyGeometricMeanCircadianStimulus = (horzcat(obj.HourlyGeometricMeanCircadianStimulus))';

SunnyHourlyMeanIlluminance       = (horzcat(obj.SunnyHourlyMeanIlluminance))';
SunnyHourlyMeanCircadianLight    = (horzcat(obj.SunnyHourlyMeanCircadianLight))';
SunnyHourlyMeanCircadianStimulus = (horzcat(obj.SunnyHourlyMeanCircadianStimulus))';

SunnyHourlyGeometricMeanIlluminance       = (horzcat(obj.SunnyHourlyGeometricMeanIlluminance))';
SunnyHourlyGeometricMeanCircadianLight    = (horzcat(obj.SunnyHourlyGeometricMeanCircadianLight))';
SunnyHourlyGeometricMeanCircadianStimulus = (horzcat(obj.SunnyHourlyGeometricMeanCircadianStimulus))';


CloudyHourlyMeanIlluminance       = (horzcat(obj.CloudyHourlyMeanIlluminance))';
CloudyHourlyMeanCircadianLight    = (horzcat(obj.CloudyHourlyMeanCircadianLight))';
CloudyHourlyMeanCircadianStimulus = (horzcat(obj.CloudyHourlyMeanCircadianStimulus))';

CloudyHourlyGeometricMeanIlluminance       = (horzcat(obj.CloudyHourlyGeometricMeanIlluminance))';
CloudyHourlyGeometricMeanCircadianLight    = (horzcat(obj.CloudyHourlyGeometricMeanCircadianLight))';
CloudyHourlyGeometricMeanCircadianStimulus = (horzcat(obj.CloudyHourlyGeometricMeanCircadianStimulus))';

str0_23 = num2str((0:23)','%02.0f');

HourlyTemplate_Names = repmat('prefix_h',24,1);
HourlyTemplate_Names = [HourlyTemplate_Names,str0_23];
HourlyTemplate_Names = (cellstr(HourlyTemplate_Names))';

HourlyMeanIlluminance_Names = regexprep(HourlyTemplate_Names,'prefix','Hourly_Mean_Illuminance');
HourlyMeanCircadianLight_Names = regexprep(HourlyTemplate_Names,'prefix','Hourly_Mean_Circadian_Light');
HourlyMeanCircadianStimulus_Names = regexprep(HourlyTemplate_Names,'prefix','Hourly_Mean_Circadian_Stimulus');

HourlyGeometricMeanIlluminance_Names = regexprep(HourlyTemplate_Names,'prefix','Hourly_Geometric_Mean_Illuminance');
HourlyGeometricMeanCircadianLight_Names = regexprep(HourlyTemplate_Names,'prefix','Hourly_Geometric_Mean_Circadian_Light');
HourlyGeometricMeanCircadianStimulus_Names = regexprep(HourlyTemplate_Names,'prefix','Hourly_Geometric_Mean_Circadian_Stimulus');

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
    ...
    {'Section_Break_4'},...
    ...
    HourlyGeometricMeanIlluminance_Names,...
    ...
    {'Section_Break_5'},...
    ...
    HourlyGeometricMeanCircadianLight_Names,...
    ...
    {'Section_Break_6'},...
    ...
    HourlyGeometricMeanCircadianStimulus_Names...
    ];

t_overall = table(...
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
    ...
    'VariableNames',VariableNames);

t_sunny = t_overall;
t_cloudy = t_overall;

for ii = 1:numel(SerialNumber)
    t_overall.City_State{ii,1} = [location(ii).City,', ',location(ii).PostalStateAbbreviation];
    t_overall.Building_Name{ii,1} = location(ii).BuildingName;
    t_overall.Session_Name{ii,1} = session(ii).Name;
    
    t_overall.Wing{ii,1}             = location(ii).Wing;
    t_overall.Floor{ii,1}            = location(ii).Floor;
    t_overall.Workstation{ii,1}      = location(ii).Workstation;
    t_overall.Window_Proximity{ii,1} = location(ii).WindowProximity;
    t_overall.Exposure{ii,1}         = location(ii).Exposure;
end

t_sunny.City_State = t_overall.City_State;
t_sunny.Building_Name = t_overall.Building_Name;
t_sunny.Session_Name = t_overall.Session_Name;
t_sunny.Wing = t_overall.Wing;
t_sunny.Floor = t_overall.Floor;
t_sunny.Workstation = t_overall.Workstation;
t_sunny.Window_Proximity = t_overall.Window_Proximity;
t_sunny.Exposure = t_overall.Exposure;

t_cloudy.City_State = t_overall.City_State;
t_cloudy.Building_Name = t_overall.Building_Name;
t_cloudy.Session_Name = t_overall.Session_Name;
t_cloudy.Wing = t_overall.Wing;
t_cloudy.Floor = t_overall.Floor;
t_cloudy.Workstation = t_overall.Workstation;
t_cloudy.Window_Proximity = t_overall.Window_Proximity;
t_cloudy.Exposure = t_overall.Exposure;

for jj = 1:24
    t_overall.(HourlyMeanIlluminance_Names{jj}) = HourlyMeanIlluminance(:,jj);
    t_overall.(HourlyMeanCircadianLight_Names{jj}) = HourlyMeanCircadianLight(:,jj);
    t_overall.(HourlyMeanCircadianStimulus_Names{jj}) = HourlyMeanCircadianStimulus(:,jj);
    
    t_sunny.(HourlyMeanIlluminance_Names{jj}) = SunnyHourlyMeanIlluminance(:,jj);
    t_sunny.(HourlyMeanCircadianLight_Names{jj}) = SunnyHourlyMeanCircadianLight(:,jj);
    t_sunny.(HourlyMeanCircadianStimulus_Names{jj}) = SunnyHourlyMeanCircadianStimulus(:,jj);
    
    t_cloudy.(HourlyMeanIlluminance_Names{jj}) = CloudyHourlyMeanIlluminance(:,jj);
    t_cloudy.(HourlyMeanCircadianLight_Names{jj}) = CloudyHourlyMeanCircadianLight(:,jj);
    t_cloudy.(HourlyMeanCircadianStimulus_Names{jj}) = CloudyHourlyMeanCircadianStimulus(:,jj);
    
    
    t_overall.(HourlyGeometricMeanIlluminance_Names{jj}) = HourlyGeometricMeanIlluminance(:,jj);
    t_overall.(HourlyGeometricMeanCircadianLight_Names{jj}) = HourlyGeometricMeanCircadianLight(:,jj);
    t_overall.(HourlyGeometricMeanCircadianStimulus_Names{jj}) = HourlyGeometricMeanCircadianStimulus(:,jj);
    
    t_sunny.(HourlyGeometricMeanIlluminance_Names{jj}) = SunnyHourlyGeometricMeanIlluminance(:,jj);
    t_sunny.(HourlyGeometricMeanCircadianLight_Names{jj}) = SunnyHourlyGeometricMeanCircadianLight(:,jj);
    t_sunny.(HourlyGeometricMeanCircadianStimulus_Names{jj}) = SunnyHourlyGeometricMeanCircadianStimulus(:,jj);
    
    t_cloudy.(HourlyGeometricMeanIlluminance_Names{jj}) = CloudyHourlyGeometricMeanIlluminance(:,jj);
    t_cloudy.(HourlyGeometricMeanCircadianLight_Names{jj}) = CloudyHourlyGeometricMeanCircadianLight(:,jj);
    t_cloudy.(HourlyGeometricMeanCircadianStimulus_Names{jj}) = CloudyHourlyGeometricMeanCircadianStimulus(:,jj);
end

s = struct;
s.Overall = t_overall;
s.Sunny = t_sunny;
s.Cloudy = t_cloudy;

end

