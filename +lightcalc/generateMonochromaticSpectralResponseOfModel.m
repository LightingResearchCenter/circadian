%Brainard and Thappan Data
% [wavelength  response]
BandT = [420 0.256; ...
         424 0.815; ...
         440 0.953; ...
         456 1.000; ...
         460 1.000; ...
         472 0.8560; ...
         480 0.7259; ...
         496 0.5869; ...
         505 0.7916; ...
         520 0.5202; ...
         530 0.3958; ...
         548 0.1428; ...
         555 0.1089; ...
         575 0.0554; ...
         600 0.0282];
waveBT = BandT(:,1);
BT = BandT(:,2);

wave = (420:5:600)'; % Wavelength range for calculations

criterion = 300; % Criterion response in units of CLA ("Circadian Light"). CLA is numerically equal to lux for CIE Illuminant A

criterionIrrad = zeros(size(wave)); % initialize array
for j = 1:length(wave)
    spd = zeros(length(wave),1);
    spd(j) = 1;
    steps = -4:0.2:3; % steps of log10(irradiance) (W/m^2)
    CLA = zeros(length(steps),1);
    irrad = zeros(length(steps),1);
    for i = 1:length(steps)
        irrad(i) = 10^steps(i); % irradiance (W/m^2)
        P = spd*irrad(i); % scaled spd
 
        % CLA is "Circadian Light" as given by the phototranduction model
        CLA(i) = CLA_postBerlinCorrMelanopsin_06Feb2014([wave P]);
        
    end
    criterionIrrad(j) = interp1(CLA,irrad,criterion,'linear'); % find the irradiance that gives the criterion response
    display(['Wavelength = ' num2str(wave(j),'%d') ' nm; Stimulus for criterion response = ' num2str(criterionIrrad(j)) ' W/m^2']);
end
Efficacy = 1./criterionIrrad; % efficacy  = 1/(criterion response)
Efficiency = Efficacy/max(Efficacy); % normalize to a maximum of 1

%figure(1)
%hold off
figure(2)
plot(wave,Efficiency,'k--')
axis([400 650 0 1.2])
hold on
plot(waveBT,BT,'rd')
legend('Model','Brainard and Thapan')
