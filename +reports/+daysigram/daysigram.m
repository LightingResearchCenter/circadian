function daysigram(sheetTitle,timeArray,masks,activityArray,lightArray,lightMeasure,lightRange,nDaysPerSheet,printDir,fileID)
%DAYSIGRAM Summary of this function goes here
%   Detailed explanation goes here
%   lightMeasure = 'cs' or 'lux'

import reports.daysigram.*;

[hFigure,width,height,units] = initializefigure(2,'on');
excludedData = ~masks.observation;
notInUse = masks.bed | ~masks.compliance;
Days = bindata2days(timeArray,excludedData,notInUse,activityArray,lightArray);
nDays = numel(Days);

nSheets = ceil(nDays/nDaysPerSheet);

for i1 = 1:nSheets
    startDay = 1 + i1*nDaysPerSheet - nDaysPerSheet;
    stopDay = min([i1*nDaysPerSheet,nDays]);
    
    if nSheets > 1
        sheetTitle2 = {sheetTitle;...
            ['(page ',num2str(i1),' of ',num2str(nSheets),')']};
        printName = strcat('daysigram_',datestr(now,'yyyy-mm-dd_HHMM'),...
            '_',fileID,'_page',num2str(i1),'of',num2str(nSheets));
    elseif iscell(sheetTitle)
        sheetTitle2 = sheetTitle;
        printName = strcat('daysigram_',datestr(now,'yyyy-mm-dd_HHMM'),'_',fileID);
    else
        sheetTitle2 = {sheetTitle};
        printName = strcat('daysigram_',datestr(now,'yyyy-mm-dd_HHMM'),'_',fileID);
    end
    
    plotheader(hFigure,sheetTitle2);
    plotfooter(hFigure);
    
    position = [0.875,1.5,width-1.25,height-2];
    plotsheet(Days(startDay:stopDay),lightMeasure,lightRange,position,nDaysPerSheet,units);
    
    printPath = fullfile(printDir,printName);
    print(hFigure,'-dpdf',printPath,'-painters');
    
    clf(hFigure);
end

close(hFigure);

end

