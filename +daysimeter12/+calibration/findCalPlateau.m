function [startTimes,endTimes] = findCalPlateau(data)
%FINDCALPLATEAU Summary of this function goes here
%   Detailed explanation goes here

X = data.R(:);

greaterThan10 = X > 10;

dX = diff(X);
dXLessThanEqual2 = [false;(abs(dX) <= 2)];

Y = greaterThan10 & dXLessThanEqual2;

if ~any(Y)
    idx = false(size(X));
    return;
end

% Find bouts of flattness
dY = [diff(Y);0];
starts = find(dY == 1);
ends = find(dY == -1);
ends = ends - 1;
if ends(1) < starts(1)
    ends(1) = [];
end
nStarts = numel(starts);
nEnds = numel(ends);
if nStarts ~= nEnds
    n = min([nStarts,nEnds]);
    starts = starts(1:n);
    ends = ends(1:n);
end
boutLengths = ends - starts;

idxShort = boutLengths < 3;
boutLengths(idxShort) = [];
starts(idxShort) = [];
ends(idxShort) = [];

[boutLengths,idxSort] = sort(boutLengths,'descend');
starts = starts(idxSort);
ends = ends(idxSort);

% % Find the longest flat
% [M,longest] = max(boutLengths);
% up = ups(longest);
% down = downs(longest);
% if M >= 4 % If it is a long flat bring in the ends
%     up = up + 1;
%     down = down - 1;
% end
% 
% % Convert up/down numbers to index array
% n = (1:numel(X))';
% idx = (n >= up) & (n <= down);

startTimes = data.datetime(starts);
endTimes = data.datetime(ends);

end

