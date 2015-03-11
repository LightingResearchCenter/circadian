function cla = rgb2cla(red,green,blue)
%RGB2CLA Summary of this function goes here
%   Detailed explanation goes here
import daysimeter12.*

[Sm, Vm, M, Vp, V, C] = constants;

for i1 = 1:length(red)
    RGB = [red(i1) green(i1) blue(i1)];
    Scone(i1) = sum(Sm.*RGB);
    Vmaclamda(i1) = sum(Vm.*RGB);
    Melanopsin(i1) = sum(M.*RGB);
    Vprime(i1) = sum(Vp.*RGB);
    
    if(Scone(i1) > C(3)*Vmaclamda(i1))
        cla(i1) = Melanopsin(i1) + C(1)*(Scone(i1) - C(3)*Vmaclamda(i1)) - C(2)*683*(1 - 2.71^(-(Vprime(i1)/(683*6.5))));
    else
        cla(i1) = Melanopsin(i1);
    end
    
    cla(i1) = C(4)*cla(i1);
end

end

