function alpha = dfa(epoch,dataArray,order,range_hours)
%DFA Detrended fluctuation analysis (DFA)
%   A scaling analysis method used to estimate long-range power-law 
%   correlation exponents in noise signals.
%
%   WARNING: The function DFA is computationally intensive. Avoid using DFA
%   in loops. Considering using parallel processing if available.
%   
%   Originally introduced by:
%   Peng, C.K. et al. (1994). "Mosaic organization of DNA nucleotides". 
%   Phys. Rev. E 49: 1685–1689. doi:10.1103/physreve.49.1685.
%   
%   Method adapted from:
%   Hu, K. et al (2001). "Effect of trends on detrended fluctuation 
%   analysis". Phys. Rev. E 64 (1): 011114. doi:10.1103/physreve.64.011114.
%   
% Inputs:
%	epoch       - a samplingrate object
%   dataArray	- time series signal that is to be analyzed
%	order       - Local trend polynomial fit order (default 1)
%	range_hours	- range of time scales in hours [min,max] (default [1.5,8])
%   
%   Interpretting alpha
%       alpha < 0.5	: anti-correlated
%       alpha = 0.5	: uncorrelated, white noise
%       alpha > 0.5	: correlated
%       alpha = 1   : 1/f-noise, pink noise
%       alpha > 1   : non-stationary, unbounded
%       alpha = 1.5 : Brownian noise

% Rename the variables to match Hu, et al. 2001
u = dataArray(:);
l = order;

% Integrate the time series u
N = numel(u);
y = zeros(N,1);
for j1 = 1:N
    y(j1) = sum(u(1:j1) - mean(u));
end

% Calculate time scales to test
n = (ceil(range_hours(1)/epoch.hours):floor(range_hours(2)/epoch.hours))';

F = zeros(numel(n),1);
for i1 = 1:numel(n)
    N_max = floor(N/n(i1))*n(i1);
    y2 = y(1:N_max);
    
    y_fit = zeros(size(y2)); % preallocate y_fit
    for i2 = 1:floor(N/n(i1))
        boxIdx = (i2-1)*n(i1)+1:i2*n(i1);
        x = boxIdx';
        % Calculate the local trend (y_fit)
        p = polyfit(x,y2(boxIdx),l);
        y_fit(boxIdx) = polyval(p,x);
    end
    % Calculate the detrended fluctuation function (Y)
    Y = y2 - y_fit;
    
    F(i1) = sqrt(sum(Y.^2)/N_max);
end

logF = log10(F);
logn = log10(n);
p_F = polyfit(logn,logF,1);

alpha = p_F(1);

end

