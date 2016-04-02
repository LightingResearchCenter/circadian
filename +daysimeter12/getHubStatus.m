function [output, status ] = getHubStatus( )
%GETHUBSTATUS get the status of the daysimeters connected to the hub 
%   GETHUBSTATUS(  ) will return what shared state all of the daysimeters that
%   are connected to the hub are. If there is more then one state of daysimeter
%   connected it will return an output of -1 and a list of the states of each 
%   of the daysimeters.
% 
%   if there are no daysimeters connected to the computer then it will return an
%   output of -1 and a status of -1.
% 
%   output = shared status of the hub, or -1 if there is more than one status is
%            present
% 
%   status = a cell array of the status of the daysimeters connected to the hub.
%% Prep section
daysims = daysimeter12.getDaysimeters();
if isempty(daysims) == 1 
    output = -1;
    status = -1;
    return;
end

%% Keep section
logInfoString = cell(length(daysims),1);
for index = 1:length(daysims)
   logInfoString{index} = 'log_info.txt'; 
end
logInfoPaths = cellfun(@fullfile,daysims,logInfoString,'UniformOutput',0); 
daysimsTxt = cellfun(@daysimeter12.readloginfo,logInfoPaths,'UniformOutput',0);
status = cellfun(@daysimeter12.parseStatus,daysimsTxt,'UniformOutput',0);
status = [status{1:end,1}];
if all([status(1,1:end)] == status(1,1))
    output = daysimeter12.daysimeterStatus(status(1));
else
    output = -1;
end
end

