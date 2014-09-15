function totalActivity = a2ta(activity,epoch)
%A2TA Convert activity to total activity
%   epoch = sampling epoch in seconds

% Set scaling factors
k1 = 1;
k2 = .2;
k3 = .04;
setSize = ceil(60/epoch);

% Find the number of activity counts
nAC = numel(activity);

% group 3 outer values
group3_1 = zeros(nAC,1);
group3_2 = zeros(nAC,1);
for i3 = setSize+1:setSize*2
    group3_1 = circshift(activity,i3) + group3_1;
    group3_2 = circshift(activity,-i3) + group3_2;
end
group3 = k3*(group3_1 + group3_2);

% group 2 middle values
group2_1 = zeros(nAC,1);
group2_2 = zeros(nAC,1);
for i2 = 1:setSize
    group2_1 = circshift(activity,i2) + group2_1;
    group2_2 = circshift(activity,-i2) + group2_2;
end
group2 = k2*(group2_1 + group2_2);

% group 1 center/inner value
group1 = k1*activity;

% Total activity counts
totalActivity = (group1 + group2 + group3)./setSize;

end

