function [ output_args ] = writeStartInfo( handels )


currentDate = datevec(now);
potentialDate = (currentDate(1):currentDate(1)+10);
month = (get(handels.logInfoControl.startMonth,'Value'))-1;
day = (get(handels.logInfoControl.startDay,'Value'))-1;
year = potentialDate((get(handels.logInfoControl.startYear,'Value'))-1);
hour = (get(handels.logInfoControl.startHour,'Value'))-1;
minute = (get(handels.logInfoControl.startMinute,'Value'))-1;
if month<10
    if day<10
        if hour<10
            if minute<10
                date_string1 = ['0',num2str(month),'/','0',num2str(day),'/',num2str(year),' ','0',num2str(hour),':','0',num2str(minute)];
            else
                date_string1 = ['0',num2str(month),'/','0',num2str(day),'/',num2str(year),' ','0',num2str(hour),':',num2str(minute)];
            end
        else
            if minute<10
                date_string1 = ['0',num2str(month),'/','0',num2str(day),'/',num2str(year),' ',num2str(hour),':','0',num2str(minute)];
            else
                date_string1 = ['0',num2str(month),'/','0',num2str(day),'/',num2str(year),' ',num2str(hour),':',num2str(minute)];
            end
        end
    else
        if hour<10
            if minute<10
                date_string1 = ['0',num2str(month),'/',num2str(day),'/',num2str(year),' ','0',num2str(hour),':','0',num2str(minute)];
            else
                date_string1 = ['0',num2str(month),'/',num2str(day),'/',num2str(year),' ','0',num2str(hour),':',num2str(minute)];
            end
        else
            if minute<10
                date_string1 = ['0',num2str(month),'/',num2str(day),'/',num2str(year),' ',num2str(hour),':','0',num2str(minute)];
            else
                date_string1 = ['0',num2str(month),'/',num2str(day),'/',num2str(year),' ',num2str(hour),':',num2str(minute)];
            end
        end
    end
else
    if day<10
        if hour<10
            if minute<10
                date_string1 = [num2str(month),'/','0',num2str(day),'/',num2str(year),' ','0',num2str(hour),':','0',num2str(minute)];
            else
                date_string1 = [num2str(month),'/','0',num2str(day),'/',num2str(year),' ','0',num2str(hour),':',num2str(minute)];
            end
        else
            if minute<10
                date_string1 = [num2str(month),'/','0',num2str(day),'/',num2str(year),' ',num2str(hour),':','0',num2str(minute)];
            else
                date_string1 = [num2str(month),'/','0',num2str(day),'/',num2str(year),' ',num2str(hour),':',num2str(minute)];
            end
        end
    else
        if hour<10
            if minute<10
                date_string1 = [num2str(month),'/',num2str(day),'/',num2str(year),' ','0',num2str(hour),':','0',num2str(minute)];
            else
                date_string1 = [num2str(month),'/',num2str(day),'/',num2str(year),' ','0',num2str(hour),':',num2str(minute)];
            end
        else
            if minute<10
                date_string1 = [num2str(month),'/',num2str(day),'/',num2str(year),' ',num2str(hour),':','0',num2str(minute)];
            else
                date_string1 = [num2str(month),'/',num2str(day),'/',num2str(year),' ',num2str(hour),':',num2str(minute)];
            end
        end
    end
end

Date1 = datenum(date_string1,'mm/dd/yyyy HH:MM');
date_string2 = datestr(Date1,'mm/dd/yyyy HH:MM');
if ~(strcmp(date_string1,date_string2))
    set(handels.logInfoControl.instructBlock,'string','Invalid date Please Select a proper date.') ;
    return
end
set(handels.logInfo,'visible','off');
potentialLogInterval = get(handels.logInfoControl.startLogInterval,'string');
index = get(handels.logInfoControl.startLogInterval,'value');
logInterval = str2double(potentialLogInterval{index});
daysims = daysimeter12.getDaysimeters();
start = daysimeter12.daysimeterStatus(2);
for iDaysim = length(daysims)
    message = daysimeter12.setStatus(fullfile(daysims{iDaysim},'log_info.txt'), start);
    if isempty(message)
        message = daysimeter12.setStartDateTime(fullfile(daysims{iDaysim},'log_info.txt'), Date1);
        if isempty(message)
            message = daysimeter12.setLoggingInterval(fullfile(daysims{iDaysim},'log_info.txt'), logInterval);
            if ~isempty(message)
                set(handels.error,'visible','on');
                set(handels.errorControl.instructBlock,'String',['There was an error writing the Log Interval to daysimeter in drive ',  daysims(iDaysim)]);
            end
        else
            set(handels.error,'visible','on');
            set(handels.errorControl.instructBlock,'String',['There was an error writing the Date to daysimeter in drive ',  daysims(iDaysim)]);
        end
    else
        set(handels.error,'visible','on');
        set(handels.errorControl.instructBlock,'String',['There was an error writing the Status to daysimeter in drive ',  daysims(iDaysim)]);
    end
    
end

end

