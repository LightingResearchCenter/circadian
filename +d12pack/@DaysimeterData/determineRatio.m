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
            CalibrationRatio = luxThresholdMethod(obj,30,600);
        case 'lowluxthreshold'
            CalibrationRatio = luxThresholdMethod(obj,30);
        case 'postir'
            CalibrationRatio = postIRMethod(obj);
        case 'original+factor'
            CalibrationRatio = originalFactorMethod(obj);
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
if isnat(NewestDate)
    SelectedPost = TCals(end,:);
else
    SelectedPost = TCals(TCals.Date == NewestDate,:);
    if size(SelectedPost,1) > 1 % If more than one pick last
        SelectedPost = SelectedPost(end,:);
    end
end
% Find the index of the selection
SelectedIdx = (TCals.Red == SelectedPost.Red) & ...
    (TCals.Green == SelectedPost.Green) & ...
    (TCals.Blue == SelectedPost.Blue) & ...
    (strcmp(TCals.Label,SelectedPost.Label));

CalibrationRatio(:,SelectedIdx) = 1;

end % End of postIRMethod


% luxthreshold method
function CalibrationRatio = luxThresholdMethod(obj,lowThresh,varargin)
if nargin == 3
    highThresh = varargin{1};
else
    highThresh = inf;
end
CalibrationRatio = zeros(numel(obj.Time),numel(obj.Calibration));

TCals = table(obj.Calibration);

PreIdx = strcmpi(TCals.Label,'PreIRCorrection');
PostIdx = strcmpi(TCals.Label,'PostIRCorrection');
OrigIdx = strcmpi(TCals.Label,'Original');
if any(PostIdx) && (any(PreIdx) || any(OrigIdx))
    if any(PreIdx)
        PreCals = TCals(PreIdx,:);
    else
        PreCals = TCals(OrigIdx,:);
    end
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
    luxUnder = PreIRCorrectionIlluminance < lowThresh;
    luxOver = PreIRCorrectionIlluminance >= highThresh;
    luxMiddle = ~luxUnder | ~luxOver;
    
    CalibrationRatio(luxUnder,SelectedPreIdx) = 1;
    CalibrationRatio(luxMiddle,SelectedPostIdx) = 1;
    
    CalibrationRatio(luxOver,SelectedPreIdx) = 0.2;
    CalibrationRatio(luxOver,SelectedPostIdx) = 0.8;
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


% originalFactorMethod method
function CalibrationRatio = originalFactorMethod(obj)
CalibrationRatio = zeros(numel(obj.Time),numel(obj.Calibration));

TCals = table(obj.Calibration);

orgIdx = strcmpi(TCals.Label,'Original');
if any(orgIdx)
    orgCals = TCals(orgIdx,:);
    oldestORgtDate = min(vertcat(orgCals.Date));
    
    if isnat(oldestORgtDate) % If no date use last
        SelectedPost = orgCals(end,:);
    else % Use least recent
        SelectedPost = orgCals(orgCals.Date == oldestORgtDate,:);
        if size(SelectedPost,1) > 1 % If more than one pick last
            SelectedPost = SelectedPost(end,:);
        end
    end
    % Find the index of the selection
    SelectedPostIdx = (TCals.Red == SelectedPost.Red) & ...
        (TCals.Green == SelectedPost.Green) & ...
        (TCals.Blue == SelectedPost.Blue) & ...
        (strcmp(TCals.Label,SelectedPost.Label));
    
    CalibrationRatio(:,SelectedPostIdx) = obj.CorrectionFactor;
end

end % End of originalFactorMethod