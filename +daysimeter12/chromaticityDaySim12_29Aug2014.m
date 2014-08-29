function [chromaticity] = chromaticityDaySim12_29Aug2014(RGB,chromMatrix)
% Calculates chromaticity values (x,y) using the CIE 1931 Standard Observer
%
% RGB is a row vector (or [3 x n] matrix for multiple readings) of
% calibrated Red, Green, and Blue values of a Daysimeter reading(s).
% chromMatrix is a 3 x 3 matrix of calibration coefficients used to
% calculate chromaticity.

triStim = RGB*chromMatrix;
sumTriStim = sum(triStim,2); % sum across columns (X+Y+Z)
chromaticity = triStim./[sumTriStim,sumTriStim,sumTriStim];
%{
chromMatrix =

   0.656101046989039   0.284972476979684   0.001350826922588
   0.282587880840379   0.594774181063281  -0.016664361759463
   0.053124114946539   0.026110017695902   0.378902846794248

%}
