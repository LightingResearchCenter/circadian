function amplitudeArray = enrightperiodogram(dataArray,testPeriodArray)
% ENRIGHTPERIODOGRAM Calculates the Enright periodogram on column vector
%   dataArray using range of periods given by testPeriodArray. Formulation 
%   taken from Philip G. Sokolove adn Wayne N. Bushell, The Chi Square 
%   Periodogram: Its Utility for Analysis of Circadian Rhythms, J. Theor. 
%   Biol. (1978) Vol 72, pp 131-160.

n = numel(dataArray);
nPeriods = numel(testPeriodArray);
amplitudeArray = zeros(nPeriods,1);
for i1 = 1:nPeriods
    P = testPeriodArray(i1); % true as long as p is an integer, i.e. no fractional periods (for now)
    K = floor(n/P);
    dataArraySubset = dataArray(1:K*P);
    M = (reshape(dataArraySubset,P,K))';
    if n/P > K
        % fill empty cells with mean taken along 1st dimension
        partialRow = [(dataArray(K*P+1:end))' mean(M(:,n-K*P+1:P),1)];
        M = [M;partialRow];
    end
    Xmean = mean(M); % column means
    Xp = mean(Xmean);
    amplitudeArray(i1) = sqrt(1/P*sum((Xmean-Xp).^2));
end
