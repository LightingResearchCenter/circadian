function CircadianLight = rgb2cla(Red,Green,Blue)
%RGB2CLA Convert Daysimeter Red, Green, and Blue channels (RGB) to
% Circadian Light (CLA)

% Define constants
C  = [ 0.617848  3.221534 0.265128 2.309656];
M  = [ 0.000254  0.167237 0.261462];
Sm = [-0.005701 -0.014015 0.241859];
Vm = [ 0.381876  0.642883 0.067544];
Vp = [ 0.004458  0.360213 0.189536];

RGB = horzcat(Red(:),Green(:),Blue(:));

Scone      = sum(bsxfun(@times, Sm, RGB), 2);
Vmaclamda  = sum(bsxfun(@times, Vm, RGB), 2);
Melanopsin = sum(bsxfun(@times, M,  RGB), 2);
Vprime     = sum(bsxfun(@times, Vp, RGB), 2);

Temp = Melanopsin;
idx  = Scone > C(3)*Vmaclamda;
Temp(idx) = Melanopsin(idx) ...
    + C(1)*(Scone(idx) - C(3)*Vmaclamda(idx)) ...
    - C(2)*683*(1 - 2.71.^(-(Vprime(idx)/(683*6.5))));

CircadianLight = C(4)*Temp;

end

