function CalibrationRatio = determineRatio(obj)
%DETERMINERATION Summary of this function goes here
%   Detailed explanation goes here

if ~isempty(obj.Calibration)
    if isempty(obj.RatioMethod)
        RatioMethod = 'newest';
    else
        RatioMethod = obj.RatioMethod;
    end
    
    switch RatioMethod
        case 'newest'
            CalibrationRatio = newestMethod(obj);
        case 'luxthreshold'
            CalibrationRatio = luxThresholdMethod(obj,30);
        case 'postir'
            CalibrationRatio = postIRMethod(obj);
        otherwise
            CalibrationRatio = newestMethod(obj);
    end
else
    CalibrationRatio = zeros(numel(obj.Time),numel(obj.Calibration));
end

end


% newest method
function CalibrationRatio = newestMethod(obj)
CalibrationRatio = zeros(numel(obj.Time),numel(obj.Calibration));

TCals = table(obj.Calibration);

NewestDate = max(vertcat(TCals.Date));

SelectedPost = TCals(TCals.Date == NewestDate,:);
if size(SelectedPost,1) > 1 % If more than one pick last
    SelectedPost = SelectedPost(end,:);
end
% Find the index of the selection
SelectedIdx = (TCals.Red == SelectedPost.Red) & ...
    (TCals.Green == SelectedPost.Green) & ...
    (TCals.Blue == SelectedPost.Blue) & ...
    (strcmp(TCals.Label,SelectedPost.Label));

CalibrationRatio(:,SelectedIdx) = 1;

end % End of postIRMethod


% luxthreshold method
function CalibrationRatio = luxThresholdMethod(obj,LuxThreshold)
CalibrationRatio = zeros(numel(obj.Time),numel(obj.Calibration));

TCals = table(obj.Calibration);

PreIdx = strcmpi(TCals.Label,'PreIRCorrection');
PostIdx = strcmpi(TCals.Label,'PostIRCorrection');
if any(PreIdx) && any(PostIdx)
    PreCals = TCals(PreIdx,:);
    PostCals = TCals(PostIdx,:);
    
    NewestPreDate = max(vertcat(PreCals.Date));
    NewestPostDate = max(vertcat(PostCals.Date));
    
    if isnat(NewestPreDate) % If no date use last
        SelectedPre = PreCals(end,:);
    else % Use most recent
        SelectedPre = PreCals(PreCals.Date == NewestPreDate,:);
        if size(SelectedPre,1) > 1 % If more than one pick last
            SelectedPre = SelectedPre(end,:);
        end
    end
    % Find the index of the selection
    SelectedPreIdx = (TCals.Red == SelectedPre.Red) & ...
        (TCals.Green == SelectedPre.Green) & ...
        (TCals.Blue == SelectedPre.Blue) & ...
        (strcmp(TCals.Label,SelectedPre.Label));
    
    if isnat(NewestPostDate) % If no date use last
        SelectedPost = PostCals(end,:);
    else % Use most recent
        SelectedPost = PostCals(PostCals.Date == NewestPostDate,:);
        if size(SelectedPost,1) > 1 % If more than one pick last
            SelectedPost = SelectedPost(end,:);
        end
    end
    % Find the index of the selection
    SelectedPostIdx = (TCals.Red == SelectedPost.Red) & ...
        (TCals.Green == SelectedPost.Green) & ...
        (TCals.Blue == SelectedPost.Blue) & ...
        (strcmp(TCals.Label,SelectedPost.Label));
    
    % Calculate PreIRCorrection Illuminance
    PreIRRed = obj.applyCalibration(obj.RedCounts,obj.Calibration(SelectedPreIdx).Red,1);
    PreIRGreen = obj.applyCalibration(obj.GreenCounts,obj.Calibration(SelectedPreIdx).Green,1);
    PreIRBlue = obj.applyCalibration(obj.BlueCounts,obj.Calibration(SelectedPreIdx).Blue,1);
    PreIRCorrectionIlluminance = obj.rgb2lux(PreIRRed,PreIRGreen,PreIRBlue);
    luxUnder = PreIRCorrectionIlluminance < LuxThreshold;
    
    CalibrationRatio(luxUnder,SelectedPreIdx) = 1;
    CalibrationRatio(~luxUnder,SelectedPostIdx) = 1;
end

end % End of luxThresholdMethod



% postir method
function CalibrationRatio = postIRMethod(obj)
CalibrationRatio = zeros(numel(obj.Time),numel(obj.Calibration));

TCals = table(obj.Calibration);

PostIdx = strcmpi(TCals.Label,'PostIRCorrection');
if any(PostIdx)
    PostCals = TCals(PostIdx,:);
    NewestPostDate = max(vertcat(PostCals.Date));
    
    if isnat(NewestPostDate) % If no date use last
        SelectedPost = PostCals(end,:);
    else % Use most recent
        SelectedPost = PostCals(PostCals.Date == NewestPostDate,:);
        if size(SelectedPost,1) > 1 % If more than one pick last
            SelectedPost = SelectedPost(end,:);
        end
    end
    % Find the index of the selection
    SelectedPostIdx = (TCals.Red == SelectedPost.Red) & ...
        (TCals.Green == SelectedPost.Green) & ...
        (TCals.Blue == SelectedPost.Blue) & ...
        (strcmp(TCals.Label,SelectedPost.Label));
    
    CalibrationRatio(:,SelectedPostIdx) = 1;
end

end % End of postIRMethod