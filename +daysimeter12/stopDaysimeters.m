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
for iDaysim = 1:length(daysims)
    logInfoTxt = daysimeter12.readloginfo(fullfile(daysims{iDaysim},'log_info.txt'));
    device = daysimeter12.parseDeviceSn(logInfoTxt);
    message = daysimeter12.setStatus(fullfile(daysims{iDaysim},'log_info.txt'), stop);
    if isempty(message)
    else
        set(handels.error,'visible','on');
        set(handels.errorControl.instructBlock,'String',['There was an error writing the Status to daysimeter in daysimeter ',  device]);
    end
    newFileName = daysimeter12.makeNameStub(device);
    copyfile(fullfile(daysims{iDaysim},'log_info.txt'),fullfile(saveloc,[newFileName,'-LOG.txt']));
    x = x+1;

    waitbar(x/(length(daysims)*2),h,'Writing Daysimeter to Default Folder');
    copyfile(fullfile(daysims{iDaysim},'data_log.txt'),fullfile(saveloc,[newFileName,'-DATA.txt']));
    x = x+1;

    waitbar(x/(length(daysims)*2),h,'Writing Daysimeter to Default Folder');
end
delete(h);
set(handels.daysimSearch,'visible','on');
set(handels.search.instructBlock,'string',sprintf('Daysimeters Stopped and Downloaded. \nPlease Select what you would like to do.'));
end

