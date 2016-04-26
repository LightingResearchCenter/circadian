function CircadianLight = rgb2cla(Red,Green,Blue)
%RGB2CLA Summary of this function goes here
%   Detailed explanation goes here

C = [0.617848 3.221534 0.265128 2.309656];

M = [0.000254 0.167237 0.261462];

Sm = [-0.005701 -0.014015 0.241859];

Vm = [0.381876 0.642883 0.067544];

Vp = [0.004458 0.360213 0.189536];

% CircadianLight = zeros(numel(Red),1); % Preallocate CircadianLight
% for i1 = 1:length(Red)
%     RGB = [Red(i1) Green(i1) Blue(i1)];
%     Scone(i1,1) = sum(Sm.*RGB);
%     Vmaclamda(i1,1) = sum(Vm.*RGB);
%     Melanopsin(i1,1) = sum(M.*RGB);
%     Vprime(i1,1) = sum(Vp.*RGB);
%     
%     if(Scone(i1,1) > C(3)*Vmaclamda(i1,1))
%         CircadianLight(i1,1) = Melanopsin(i1,1) + C(1)*(Scone(i1,1) - C(3)*Vmaclamda(i1,1)) - C(2)*683*(1 - 2.71^(-(Vprime(i1,1)/(683*6.5))));
%     else
%         CircadianLight(i1,1) = Melanopsin(i1,1);
%     end
%     
%     CircadianLight(i1,1) = C(4)*CircadianLight(i1,1);
% end

RGB2 = horzcat(Red(:),Green(:),Blue(:));
Scone2 = sum(bsxfun(@times,Sm,RGB2),2);
Vmaclamda2 = sum(bsxfun(@times,Vm,RGB2),2);
Melanopsin2 = sum(bsxfun(@times,M,RGB2),2);
Vprime2 = sum(bsxfun(@times,Vp,RGB2),2);
intermediateCircadianLight2 = Melanopsin2;
idx = Scone2 > C(3)*Vmaclamda2;
intermediateCircadianLight2(idx) = Melanopsin2(idx) + C(1).*(Scone2(idx) - C(3).*Vmaclamda2(idx)) - C(2).*683.*(1 - 2.71.^(-(Vprime2(idx)./(683.*6.5))));
CircadianLight = C(4)*intermediateCircadianLight2;

end

