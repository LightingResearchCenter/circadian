function chromaticity = rgb2chrom(red,green,blue)
%RGB2CHROM Calculates chromaticity using the CIE 1931 Standard Observer
%   RGB is a row vector (or [n x 3] matrix for multiple readings) of
%	calibrated Red, Green, and Blue values of a Daysimeter reading(s).
%	chromMatrix is a 3 x 3 matrix of calibration coefficients used to
%	calculate chromaticity.

% Create chromMatrix.
chromMatrix = ...
    [0.656101046989039,	0.284972476979684,  0.001350826922588; ...
	 0.282587880840379, 0.594774181063281, -0.016664361759463; ...
	 0.053124114946539, 0.026110017695902,  0.378902846794248];

% Combine red, green, and blue into RGB.
red   = red(:);
green = green(:);
blue  = blue(:);
RGB   = [red,green,blue];

triStim = RGB*chromMatrix;
sumTriStim = sum(triStim,2); % sum across columns (X+Y+Z)
tempChrom = triStim./[sumTriStim,sumTriStim,sumTriStim];

chromaticity = chromcoord('x',tempChrom(:,1),'y',tempChrom(:,2),'z',tempChrom(:,3));

end

