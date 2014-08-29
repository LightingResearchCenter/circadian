function Tc = CCTfromxy(x,y)
% CCT (Correlated Color Temperature)
% Calculates the correlated color temperature (CCT) from CIE x, y values.
% Uses method by Allen Robertson as references in W&S (1982).
% Needs file 'isoTempLines.mat' for isotemperature lines from W&S (1982) or
% similarly calculated.
% Function arguments are:
%	x - CIE x value
%	y - CIE y valuestartw - starting wavelength of spd in nanometers,

%load('isoTempLinesNewestFine.mat','T','ut','vt','tt');
M = load('P:\hamner\Photometry reference files\Lookup Tables\isoTempLinesNewestFine23Sep05.txt');
T = M(1,:);
ut = M(2,:);
vt = M(3,:);
tt = M(4,:);

u = 4*x/(-2*x+12*y+3);
v = 6*y/(-2*x+12*y+3);

% Find adjacent lines to (us,vs)
n = length(T);
index = 0;
d1 = ((v-vt(1)) - tt(1)*(u-ut(1)))/sqrt(1+tt(1)*tt(1));
for i=2:n
	d2 = ((v-vt(i)) - tt(i)*(u-ut(i)))/sqrt(1+tt(i)*tt(i));
	if (d1/d2 < 0)
		index = i;
		break;
	else
		d1 = d2;
	end
end
if index == 0
	Tc = -1; % Not able to calculate CCT, u,v coordinates outside range.
	return
end

% Calculate CCT by interpolation between isotemperature lines
Tc = 1/(1/T(index-1)+d1/(d1-d2)*(1/T(index)-1/T(index-1)));
