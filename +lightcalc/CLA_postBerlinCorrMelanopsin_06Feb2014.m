function CLA = CLA_postBerlinCorrMelanopsin_06Feb2014(spd,varargin)
% Revised May 11, 2011
% Revised June 27, 2014
% Revised February 6, 2014 
%   Conforms to Corrigendum, Lighting Res. Technol. 2012; 44: 516
%   for the publication: Rea MS, Figueiro MG, Bierman A, Hamner R.
%   Modeling the spectral sensitivity of the human circadian system.
%   Lighting Research and Technology 2012; 44(4): 386–396. 
% Calculates the circadian stimulus for the given spd
% spd is assumed to be in units of W/m^2
% CS is scaled to be equal to lux for illuminanct A (2856 K)
% spd is two column matrix with wavelength (nm) in the first column
% and spectral irradiance (W/(m^2 nm) in the second column
% OR spd is a column vector and start, end and increment wavelength values
% are specified as additional arguements (e.g. f(spd,400,700,10))

if length(varargin)==0
    [rows columns] = size(spd);
    if columns > 2
        error('Not column oriented data. Try transposing spd');
    end
    wavelength_spd = spd(:,1);
	spd = spd(:,2);
else
    startw = varargin{1}
    endw = varargin{2}
    incrementw = varargin{3}
    wavelength_spd = (startw:incrementw:endw)';
    [rows columns] = size(spd);
    if columns > 1
        error('Detected multiple columns of data. Try transposing spd');
    end
end

Vlamda = load('Vlamda.txt');
Vlambda = interp1(Vlamda(:,1),Vlamda(:,2),wavelength_spd,'linear',0.0);

Vprime = load('Vprime.txt');
Vprime = interp1(Vprime(:,1),Vprime(:,2),wavelength_spd,'linear',0.0);
Vprime = Vprime/max(Vprime);

Scone = load('Scone.txt');
Scone = interp1(Scone(:,1),Scone(:,2),wavelength_spd,'linear',0.0);

Macula = load('MacularPigmentODfromSnodderly.txt');
thickness = 1.0; % macular thickness factor
macularT = 10.^(-Macula(:,2)*thickness);
macularTi = interp1(Macula(:,1),macularT,wavelength_spd,'linear',1.0);

Scone = Scone./macularTi;
Scone = Scone/(max(Scone));

Vlambda = Vlambda./macularTi;
Vlambda = Vlambda/max(Vlambda);

%Melanopsin = load('Melanopsin with corrected lens.txt');
Melanopsin = load('MelanopsinWlensBy2nm_02Oct2012.txt'); % lens data from Wyszecki and Stiles Table 1(2.4.6) Norren and Vos(1974) data
M = interp1(Melanopsin(:,1),Melanopsin(:,2),wavelength_spd,'linear',0.0);
%M = M/macularTi;
M = M/max(M);


rodSat = 35000; % Scotopic Trolands
retinalE = [1 3 10 30 100 300 1000 3000 10000 30000 100000];
pupilDiam = [7.1 7 6.9 6.8 6.7 6.5 6.3 5.65 5 3.65 2.3];
diam = interp1(retinalE,pupilDiam,rodSat,'linear');
rodSat = rodSat/(diam^2/4*pi)*pi/1700;

a1 = 1;                           %0.285
b1 = 0.0;                             %0.01  
a2 = 0.7000;  % a_(b-y)  was 0.6201 prior to 06Feb2014     %0.2
b2 = 0.0;                             %0.001
k =  0.2616;                            %0.31
a3 = 3.3000;  % a_rod  was 3.2347 prior to 06Feb2014      %0.72

P = spd;
if (trapz(wavelength_spd,Scone.*spd)-k*trapz(wavelength_spd,Vlambda.*spd)) >= 0
    CS1 = a1*trapz(wavelength_spd,M.*spd)-b1;
    if CS1 < 0
        CS1 = 0; % remove negative values that are below threshold set by constant b1.
    end
    CS2 = a2*(trapz(wavelength_spd,Scone.*spd)-k*trapz(wavelength_spd,Vlambda.*spd))-b2;
    if CS2 < 0
        CS2 = 0; % This is the important diode operator, the (b-y) term cannot be less than zero
    end
    Rod = a3*(1-exp(-trapz(wavelength_spd,Vprime.*spd)/rodSat));%*(1 - exp(-20*(trapz(wavelength_spd,Scone.*spd)-k*trapz(wavelength_spd,V10.*spd))));
    %disp(Rod)
    CS = (CS1 + CS2 - Rod);
    if CS < 0
        CS = 0; % Rod inhibition cannot make the CS less than zero
    end
    %disp('(B-Y) > 0')
else
    CS = (a1*trapz(wavelength_spd,M.*P)-b1);
    if CS < 0
        CS = 0; % Negative values mean stimulus is below threshold set by constant b1
    end
    %disp('(B-Y) < 0')
end
CLA = CS*1547.9; % sets equal to photopic value for 1000 lux of 2856 K. Was 1622.5 prior to 27-Jun-2014 for previous melanopsin curve

%BoverY = trapz(wavelength_spd,Scone.*spd)/trapz(wavelength_spd,Vlambda.*spd)
