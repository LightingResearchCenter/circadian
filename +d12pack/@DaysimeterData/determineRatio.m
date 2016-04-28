function CalibrationRatio = determineRatio(obj)
%DETERMINERATION Summary of this function goes here
%   Detailed explanation goes here
CalibrationRatio = zeros(numel(obj.Time),numel(obj.Calibration));

if ~isempty(obj.Calibration)
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
            SelectedPost = PreCals(PostCals.Date == NewestPostDate,:);
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
        luxUnder30 = PreIRCorrectionIlluminance < 30;
        
        CalibrationRatio(luxUnder30,SelectedPreIdx) = 1;
        CalibrationRatio(~luxUnder30,SelectedPostIdx) = 1;
    end
end
end

