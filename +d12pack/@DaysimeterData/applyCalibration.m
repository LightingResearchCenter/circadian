function CalibratedValue = applyCalibration(Value,CalibrationArray,CalibrationRatio)
%APPLYCALIBRATION Mix and apply calibration (single channel)
%   Detailed explanation goes here

MixedCalibration = bsxfun(@times,CalibrationRatio,(CalibrationArray(:))');

ExpandedValue = repmat(Value,1,numel(CalibrationArray));
if ~isempty(ExpandedValue)
    CalibratedValue = sum(ExpandedValue.*MixedCalibration,2);
else
    CalibratedValue = [];
end

end

