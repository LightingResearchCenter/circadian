function [lux, CLA] = dimeluxCLA_09Aug2011(Red, Green, Blue, id)

import dimesimeter.*;

[Sm, Vm, M, Vp, V, C] = dimeconstants_09Aug2011(id);

lux = V(1)*Red + V(2)*Green + V(3)*Blue;

for i = 1:length(Red)
    RGB = [Red(i) Green(i) Blue(i)];
    Scone(i) = sum(Sm.*RGB);
    Vmaclamda(i) = sum(Vm.*RGB);
    Melanopsin(i) = sum(M.*RGB);
    Vprime(i) = sum(Vp.*RGB);
    
%     C(4)*Melanopsin
%     C(4)*C(1)*(Scone(i) - C(3)*Vmaclamda(i))
%     C(4)*C(2)*683*(1 - exp(-(Vprime(i)/(683*6.5))))
    
    if(Scone(i) > C(3)*Vmaclamda(i))
        CLA(i) = Melanopsin(i) + C(1)*(Scone(i) - C(3)*Vmaclamda(i)) - C(2)*683*(1 - 2.71^(-(Vprime(i)/(683*6.5))));
    else
        CLA(i) = Melanopsin(i);
    end
    
    CLA(i) = C(4)*CLA(i);
end
CLA = CLA';
