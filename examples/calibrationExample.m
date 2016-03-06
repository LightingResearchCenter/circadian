
%% Reset MATLAB
close all
clear
clc

%% Enable dependencies
[circadianDir,~,~] = fileparts(pwd);
addpath(circadianDir);

%% Specify test data files
dataFolder = '\\root\projects\DaysimeterAndDimesimeterReferenceFiles\Daysimeter Calibration Fix All\Daysimeter_Recal_2,23to2,24';
listing = dir([dataFolder,filesep,'*DATA.txt']);
data_logs = fullfile(dataFolder,{listing.name}');
log_infos = regexprep(data_logs,'DATA','LOG');
notesPath = fullfile(dataFolder,'BarPhotometer_Daysimeter_Calibration_2,23,16_plus_CharliesAddedCalibrations.xlsx');
previousCalPath = '\\root\projects\DaysimeterAndDimesimeterReferenceFiles\data\Day12 RGB Values.txt';

%% Initialize figure
h = figure;

%% Import previous calibration
[IDnum,R,G,B] = daysimeter12.calibration.importfileCal(previousCalPath);
previousCalTbl = table(IDnum,R,G,B);

%% Import lab notes
notes = daysimeter12.calibration.importNotes(notesPath,1,2,80);

%% Preallocate output table
nFile = numel(data_logs);

matTemplate = NaN(nFile,1);
cellTemplate = cell(nFile,1);

daysimeter	= matTemplate;
redCal      = matTemplate;
greenCal	= matTemplate;
blueCal     = matTemplate;

selectedStartTime	= cellTemplate;
selectedEndTime     = cellTemplate;

illuminancePreviousCal      = matTemplate;
illuminanceCurrentCal       = matTemplate;
redDrift_countsPerSecond	= matTemplate;
geenDrift_countsPerSecond	= matTemplate;
blueDrift_countsPerSecond	= matTemplate;

output = table(daysimeter,...
    redCal,...
    greenCal,...
    blueCal,...
    selectedStartTime,...
    selectedEndTime,...
    illuminancePreviousCal,...
    illuminanceCurrentCal,...
    redDrift_countsPerSecond,...
    geenDrift_countsPerSecond,...
    blueDrift_countsPerSecond);

%% Iterate through files
for iFile = 1:nFile
    % Read data from Daysimeter files
    log_infoPath = log_infos{iFile};
    data_logPath = data_logs{iFile};
    [data,IDnum] = daysimeter12.readraw(log_infoPath,data_logPath);
    output.daysimeter(iFile) = IDnum;
    
    notesIdx = notes.Daysimeter == IDnum;
    if ~any(notesIdx)
        continue;
    end
    
    previousIdx = previousCalTbl.IDnum == IDnum;
    if ~any(previousIdx)
        previousCal = NaN(1,3);
    else
        previousCal = [previousCalTbl.R(previousIdx),previousCalTbl.G(previousIdx),previousCalTbl.B(previousIdx)];
    end
    
    referenceIlluminance = notes.IlluminanceAverage(notesIdx);
    
    isLast = iFile == nFile;
    
    % Call calibration UI
    [selectedStart,selectedEnd,currentCal,previousLux,currentLux,driftRates] = daysimeter12.calibration.uiCalibration(data,IDnum,h,previousCal,referenceIlluminance,isLast);
    
    % Assign output
    output.redCal(iFile)	= currentCal(1);
    output.greenCal(iFile)	= currentCal(2);
    output.blueCal(iFile)	= currentCal(3);
    
    output.selectedStartTime{iFile}	= selectedStart;
    output.selectedEndTime{iFile}	= selectedEnd;
    
    output.illuminancePreviousCal(iFile)	= previousLux;
    output.illuminanceCurrentCal(iFile)     = currentLux;
    
    output.redDrift_countsPerSecond(iFile)	= driftRates(1);
    output.geenDrift_countsPerSecond(iFile)	= driftRates(2);
    output.blueDrift_countsPerSecond(iFile)	= driftRates(3);
    
    if ~ishandle(h)
        break;
    end
end

%% Export output table to Excel
savePath = 'calibration_results.xlsx';
writetable(output,savePath);
winopen(savePath);