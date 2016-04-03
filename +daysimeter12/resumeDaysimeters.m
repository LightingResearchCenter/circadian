function [ output_args ] = resumeDaysimeters( handels )
%RESUMEDAYSIMETERS Summary of this function goes here
%   Detailed explanation goes here
set(handels.daysimFound,'visible','off');
daysims = daysimeter12.getDaysimeters();
resume = daysimeter12.daysimeterStatus(4);

saveloc = getenv('DAYSIMSAVELOC');
for iDaysim = 1:length(daysims)
    logInfoTxt = daysimeter12.readloginfo(fullfile(daysims{iDaysim},'log_info.txt'));
    device = daysimeter12.parseDeviceSn(logInfoTxt);
    message = daysimeter12.setStatus(fullfile(daysims{iDaysim},'log_info.txt'), resume);
    if isempty(message)
    else
        set(handels.error,'visible','on');
        set(handels.errorControl.instructBlock,'String',['There was an error writing the Status to daysimeter in daysimeter ',  device]);
    end
    newFileName = daysimeter12.makeNameStub(device);
    copyfile(fullfile(daysims{iDaysim},'log_info.txt'),fullfile(saveloc,[newFileName,'-LOG.txt']));
end
set(handels.daysimSearch,'visible','on');
set(handels.search.instructBlock,'string',sprintf('Daysimeters Resumed. \nPlease Select what you would like to do.'));
end



