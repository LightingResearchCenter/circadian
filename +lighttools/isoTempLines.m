% Provides a table of isotemperature lines for use with the Robertson Method
% (Robertson, 1968) to interpolate isotemperature lines from the CIE 1960 UCS.
% The spacing of the isotemp lines is very small (1 1/MK) so very little
% interpolation is actually needed for determining CCT. The latest (2002)
% recommended values for the physical constants determining blackbldy
% radiation spectra are used

load('CIE31_1', 'wavelength','xbar','ybar','zbar');
dwave = 1; % wavelength increment (nm)

ubar = (2/3)*xbar;
vbar = ybar;
wbar = -0.5*xbar + (3/2)*ybar + 0.5*zbar;

% 2002 CODATA recommended values
h = 6.6260693e-34
c = 299792458
k = 1.3806505e-23
c1 = 2*pi*h*c^2
c2 = h*c/k

%MrecpK = [.01 10 20 30 40 50 60 70 80 90 100 125 150 175 200 225 250 275 300 ...
%   325 350 375 400 425 450 475 500 525 550 575 600];  % Values in Wyszecki
%   and Sitles, Color Science, 2nd ed. 1982, page 228
MrecpK = [0.01 1:600];
T = 1./(MrecpK*1e-6);
for i = 1:length(T)
   spdref = c1 * (1e-9*wavelength).^-5 ./ (exp(c2./(T(i).* 1e-9*wavelength)) - 1);
   spdref = spdref/max(spdref);
   wave = wavelength*1e-9;
   
   % Equations from Wyszecki and Sitles, Color Science, 2nd ed. 1982, page
   % 226 and 227
   U = sum(spdref.*ubar);
   V = sum(spdref.*vbar);
   W = sum(spdref.*wbar);
   R = U+V+W;
   u(i) = U/R;
   v(i) = V/R;
   
   Uprime = c1*c2*(T(i))^-2*sum(wave.^-6.*ubar.*exp(c2./(wave.*T(i))).*(exp(c2./(wave.*(T(i))))-1).^-2)*dwave;
   Vprime = sum(c1*c2*T(i)^-2*wave.^-6.*vbar.*exp(c2./(wave.*T(i))).*(exp(c2./(wave.*(T(i))))-1).^-2)*dwave;
   Wprime = sum(c1*c2*T(i)^-2*wave.^-6.*wbar.*exp(c2./(wave.*T(i))).*(exp(c2./(wave.*(T(i))))-1).^-2)*dwave;
   Rprime = Uprime+Vprime+Wprime;
   
   sl(i) = (Vprime*R-V*Rprime)/(Uprime*R-U*Rprime);
   m(i) = -1/sl(i);
end
ut = u;
vt = v;
tt = m;
Table = [T' u' v' m'];
% save isoTempLinesNewestFine23Sep05.txt T ut vt tt -ascii
save isoTempLinesNewestFine23Sep05.txt Table -ascii
