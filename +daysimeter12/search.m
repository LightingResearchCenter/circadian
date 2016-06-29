function [] = search(handels)
%SEARCH will change the Hub GUI if there are daysimeters on the Computer
%   This function will determine if there are daysimeters on the computer,
%   and will update the StartStopHub GUI depending on if it found it or
%   not. 
%   NOTE: there is a needed check that has to be added to this file. It
%   needs to check the daysimeters it finds to see if any of them are
%   corrupted or if any are ok. if there are corrupted files it should
%   display that on the GUI instead of trying to continue the function. 

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
    set(handels.found.startbutton,'enable','off');
    set(handels.found.stopbutton,'enable','on');
else
    if output == 4
        set(handels.found.continuebutton,'enable','off');
        set(handels.found.startbutton,'enable','off');
        set(handels.found.stopbutton,'enable','on');
    end
    if output == 2
        set(handels.found.continuebutton,'enable','off');
        set(handels.found.startbutton,'enable','off');
        set(handels.found.stopbutton,'enable','on');
    end
    if output == 0
        set(handels.found.continuebutton,'enable','off');
        set(handels.found.startbutton,'enable','on');
        set(handels.found.stopbutton,'enable','off');
    end
end
end

