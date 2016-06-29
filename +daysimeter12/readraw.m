function [data,IDnum] = readraw(log_infoPath,data_logPath)
%READRAW Summary of this function goes here
%   Detailed explanation goes here

% read the header file
I = daysimeter12.readloginfo(log_infoPath);

% read the data file
D = daysimeter12.readdatalog(data_logPath);

% find the ID number
IDstr = daysimeter12.parseDeviceSn(I);
IDnum = str2double(IDstr);

% find the start date time
startTime = daysimeter12.parseStartDateTime(I);

% find the log interval
logInterval = daysimeter12.parseLoggingInterval(I);

% seperate data into raw R,G,B,A
n = floor(numel(D)/4)*4;
D = D(1:n);
d = (reshape(D,4,n/4))';
R = d(:,1);
G = d(:,2);
B = d(:,3);
A = d(:,4);

% remove resets (value = 65278) and unwritten (value = 65535)
resets = R == 65278;
unwritten = R == 65535;
q = ~(resets | unwritten);
R = R(q);
G = G(q);
B = B(q);
A = A(q);

% Summarize resets
resets2 = [false;resets(~unwritten)];
cumResets = [cumsum(resets);0];
condResets = cumResets(~resets2);
condResets = condResets(1:end-1);

% create a time array
nEntries = numel(R);
s = logInterval*(0:nEntries-1)';
dv = repmat(startTime,nEntries,1);
dv(:,end) = dv(:,end) + s;
dt = datetime(dv);

% convert activity to rms g
% raw activity is a mean squared value, 1 count = .0039 g's, and the 4 comes
% from four right shifts in the source code
AI = (sqrt(A))*.0039*4;

% Assign output to table
data = table(dt,R,G,B,AI,condResets,'VariableNames',{'datetime','R','G','B','AI','resets'});

end

