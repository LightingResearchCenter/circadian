function [ output_args ] = stopDaysimeters( handels )
%STOPDAYSIMETERS will stop any daysimeter connted to the computer
%   This function will stop any daysimeter connected to the computer as
%   well as download all of their data and log information to the users
%   default directory.
set(handels.daysimFound,'visible','off');
pause(0.0001)
daysims = daysimeter12.getDaysimeters();
stop = daysimeter12.daysimeterStatus(0);
x = 0;
h = waitbar(x,'Writing Daysimeter to Default Folder'); 
saveloc = getenv('DAYSIMSAVELOC');
device = cell(length(daysims),1);
startTime = cell(length(daysims),1);
logInterval = cell(length(daysims),1);
downloadTime = cell(length(daysims),1);
for iDaysim = 1:length(daysims)
    %Parse the Daysimeter's log_info file
    logInfoTxt = daysimeter12.readloginfo(fullfile(daysims{iDaysim},'log_info.txt'));
    device{iDaysim} = daysimeter12.parseDeviceSn(logInfoTxt);
    startTime{iDaysim}= datestr(daysimeter12.parseStartDateTime(logInfoTxt),'yyyy-mm-dd-HH-MM-SS');
    logInterval{iDaysim} = daysimeter12.parseLoggingInterval(logInfoTxt);
    %set Status and error check
    downloadTime{iDaysim} = datestr(now,'yyyy-mm-dd-HH-MM-SS');
    message = daysimeter12.setStatus(fullfile(daysims{iDaysim},'log_info.txt'), stop);
    if isempty(message)
    else
        set(handels.error,'visible','on');
        set(handels.errorControl.instructBlock,'String',['There was an error writing the Status to daysimeter ',  (device{iDevice})]);
        return
    end
    %Save outputs ( copies of Log_info, and Data_log, a readable Data_log)
    newFileName = daysimeter12.makeNameStub(device{iDaysim});
    copyfile(fullfile(daysims{iDaysim},'log_info.txt'),fullfile(saveloc,[newFileName,'-LOG.txt']));
    x = x+1;
    waitbar(x/(length(daysims)*3),h,['Writing Daysimeter ', num2str(device{iDaysim}),' to Default Folder']);
    copyfile(fullfile(daysims{iDaysim},'data_log.txt'),fullfile(saveloc,[newFileName,'-DATA.txt']));
    x = x+1;
    waitbar(x/(length(daysims)*3),h,'Writing Daysimeter to Default Folder');
    dayTable = daysimeter12.readraw(fullfile(saveloc,[newFileName,'-LOG.txt']),fullfile(saveloc,[newFileName,'-DATA.txt']));
    writetable(dayTable,fullfile(saveloc,[newFileName,'.csv']),'filetype','text','Delimiter',',');
    waitbar(x/(length(daysims)*2),h,['Writing Daysimeter ', device{iDaysim},' to Default Folder']);
    x = x+1;
    waitbar(x/(length(daysims)*3),h,['Writing Daysimeter ', device{iDaysim},' to Default Folder']);
end
% create a table with all stopped info
stopTable = table(device, startTime, logInterval, downloadTime);
newFileName = datestr(now,'yyyy-mm-dd-HH-MM-SS');
writetable(stopTable,fullfile(saveloc,['downloadInfo',newFileName ,'.csv']),'filetype','text','Delimiter',',')
delete(h);
% function clean up
set(handels.daysimSearch,'visible','on');
set(handels.search.instructBlock,'string',sprintf('Daysimeters Stopped and Downloaded. \nPlease Select what you would like to do.'));
end

