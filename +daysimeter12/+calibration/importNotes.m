function tableout = importNotes(workbookFile,sheetName,startRow,endRow)
%IMPORTFILE Import data from a spreadsheet
%   DATA = IMPORTFILE(FILE) reads data from the first worksheet in the
%   Microsoft Excel spreadsheet file named FILE and returns the data as a
%   table.
%
%   DATA = IMPORTFILE(FILE,SHEET) reads from the specified worksheet.
%
%   DATA = IMPORTFILE(FILE,SHEET,STARTROW,ENDROW) reads from the specified
%   worksheet for the specified row interval(s). Specify STARTROW and
%   ENDROW as a pair of scalars or vectors of matching size for
%   dis-contiguous row intervals. To read to the end of the file specify an
%   ENDROW of inf.%
% Example:
%   notes = importfile('BarPhotometer_Daysimeter_Calibration_2,23,16_plus_CharliesAddedCalibrations.xlsx','Summery',2,80);
%
%   See also XLSREAD.

% Auto-generated by MATLAB on 2016/02/29 10:49:25

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If row start and end points are not specified, define defaults
if nargin <= 3
    startRow = 2;
    endRow = 80;
end

%% Import the data, extracting spreadsheet dates in Excel serial date format
[~, ~, raw, dates] = xlsread(workbookFile, sheetName, sprintf('A%d:I%d',startRow(1),endRow(1)),'' , @convertSpreadsheetExcelDates);
for block=2:length(startRow)
    [~, ~, tmpRawBlock,tmpDateNumBlock] = xlsread(workbookFile, sheetName, sprintf('A%d:I%d',startRow(block),endRow(block)),'' , @convertSpreadsheetExcelDates);
    raw = [raw;tmpRawBlock]; %#ok<AGROW>
    dates = [dates;tmpDateNumBlock]; %#ok<AGROW>
end
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
cellVectors = raw(:,9);
raw = raw(:,[1,4,5,6,7]);
dates = dates(:,[2,3,8]);

%% Create output variable
I = cellfun(@(x) ischar(x), raw);
raw(I) = {NaN};
data = reshape([raw{:}],size(raw));

%% Create table
tableout = table;

%% Allocate imported array to column variable names
tableout.Daysimeter = data(:,1);
dates(~cellfun(@(x) isnumeric(x) || islogical(x), dates)) = {NaN};
tableout.TimeStart = datetime([dates{:,1}].', 'ConvertFrom', 'Excel');
tableout.TimeStop = datetime([dates{:,2}].', 'ConvertFrom', 'Excel');
tableout.Position = data(:,2);
tableout.IlluminanceStart = data(:,3);
tableout.IlluminanceEnd = data(:,4);
tableout.IlluminanceAverage = data(:,5);
tableout.MeasurementDate = datetime([dates{:,3}].', 'ConvertFrom', 'Excel', 'Format', 'MM/dd/yyyy');
tableout.Experimenter = cellVectors(:,1);

% For code requiring serial dates (datenum) instead of datetime, uncomment
% the following line(s) below to return the imported dates as datenum(s).

% tableout.TimeStart=datenum(tableout.TimeStart);
% tableout.TimeStop=datenum(tableout.TimeStop);
% tableout.MeasurementDate=datenum(tableout.MeasurementDate);

