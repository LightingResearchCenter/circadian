function [h,hLine,hHead] = phasorarrow(vector,varargin)
%PHASORARROW Summary of this function goes here
%   Detailed explanation goes here

p = inputParser;
addRequired(p,'vector');
addOptional(p,'scale',1);
parse(p);
scale = p.Results.scale;

h = hggroup;

% Make line slightly shorter than the vector.
th = angle(vector);
mag = abs(vector);
offset = .05*scale;
[x2,y2] = pol2cart(th,mag-offset);
% Plot the line.
hLine = line([0,x2],[0,y2]);
set(hLine,'Parent',h);

% Plot the arrowhead.
hHead = arrowhead(vector,scale,hLine);
set(hHead,'Parent',h);

end

function hHead = arrowhead(vector,scale,hLine)

% Create arrowhead points
xx = [1,(1-.1*scale),(1-.1*scale),1].';
yy = scale.*[0,(.02*scale),(-.02*scale),0].';
arrow = xx + yy.*1i;

% Calculate new vector with same angle but magnitude of 1
th = angle(vector);
[x2,y2] = pol2cart(th,1);
vector2 = x2 + y2*1i;

% Find difference between vectors
dVec = vector2 - vector;

% Calculate arrowhead points in transformed space.
a = arrow * vector2.' - dVec;
xA = real(a);
yA = imag(a);
cA = zeros(size(a));

% Plot and format arrowhead.
hHead = patch(xA,yA,cA);
set(hHead,'EdgeColor','none');
set(hHead,'FaceColor',get(hLine,'Color'));

end