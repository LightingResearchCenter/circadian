function [] = search(handels)
%SEARCH Summary of this function goes here
%   Detailed explanation goes here

daysim = daysimeter12.getDaysimeters();
if isempty(daysim)
    set(handels.search.instructBlock,...
        'string',   ['There are no daysimeters connected.',char(10),'Connect Daysimeters and click search']);
    return
end
set(handels.daysimSearch,'visible','off');
set(handels.daysimFound,'visible','on');
[output, ~ ] = daysimeter12.getHubStatus( );
if (output == -1)
    set(handels.found.instructBlock,...
        'string',   ['Daysimeters were found, but there is more then one status.',char(10),'Click the status you wish them to all have.']);
    set(handels.found.continuebutton,'enable','on');
    set(handels.found.startbutton,'enable','on');
    set(handels.found.stopbutton,'enable','on');
else
    if output == 4
        set(handels.found.continuebutton,'enable','off');
        set(handels.found.startbutton,'enable','on');
        set(handels.found.stopbutton,'enable','on');
    end
    if output == 2
        set(handels.found.continuebutton,'enable','on');
        set(handels.found.startbutton,'enable','off');
        set(handels.found.stopbutton,'enable','on');
    end
    if output == 0
        set(handels.found.continuebutton,'enable','on');
        set(handels.found.startbutton,'enable','on');
        set(handels.found.stopbutton,'enable','off');
    end
end
end

