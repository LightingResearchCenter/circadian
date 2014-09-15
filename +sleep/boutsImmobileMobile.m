function [immobileBouts,mobileBouts,meanImmobileBoutTime,meanMobileBoutTime,immobile1MinBouts,immobile1MinPercent] = boutsImmobileMobile(time,immobility,sleepStart,sleepEnd,immobileTime,mobileTime,epoch)
%BOUTS Summary of this function goes here
%   Detailed explanation goes here

% Trim data to the assumed sleep period
[~,immobility] = trimData(time,immobility,sleepStart,sleepEnd);

% Find Immobile Bouts and Mobile Bouts
D = diff(immobility);
if immobility(1)
    immobileBouts = numel(D(D == 1)) + 1;
    mobileBouts = numel(D(D == -1));
else
    immobileBouts = numel(D(D == 1));
    mobileBouts = numel(D(D == -1)) + 1;
end

% Calculate Mean Immobile Bout Time in minutes
if immobileBouts == 0
    meanImmobileBoutTime = 0;
else
    meanImmobileBoutTime = immobileTime/immobileBouts;
end

% Claculate Mean Mobile Bout Time in minutes
if mobileBouts == 0
    meanMobileBoutTime = 0;
else
    meanMobileBoutTime = mobileTime/mobileBouts;
end

% Find Immobile Bouts of 1 Minute
n = floor(60/epoch);
if n < 1
    immobile1MinBouts = 0;
    immobile1MinPercent = 0;
else
    immobility = immobility(:); % Make sure vector is vertical
    % Find runs
    vx=[1;diff(immobility)];
    vx=vx~=0;
    val=immobility(vx); % Values of runs
    vc=cumsum(vx);
    len=accumarray(vc,ones(size(vc))); % Length of runs
    minuteBouts = (val == 1) & (len == n); % Immobile runs of one minute
    immobile1MinBouts = sum(minuteBouts); % Number of immobile 1 minute runs
    immobile1MinPercent = immobile1MinBouts/immobileBouts;
end


end

