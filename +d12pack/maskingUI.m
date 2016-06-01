classdef maskingUI < matlab.mixin.SetGet
    
    %% Properties
    % Properties that correspond to app components
    properties (Access = public)
        Figure                      matlab.ui.Figure                % UI Figure
        DataAxes                    matlab.graphics.axis.Axes       % Daysimeter...
        ButtonGroup                 matlab.ui.container.ButtonGroup	% Mask Type
        ObservationRadioButton      matlab.ui.control.UIControl     % Observation
        ErrorRadioButton            matlab.ui.control.UIControl     % Error
        NoncomplianceRadioButton	matlab.ui.control.UIControl     % Noncompliance
        ShowBedLabel                matlab.ui.control.UIControl     % Show in Be...
        ShowBedSwitch               matlab.ui.control.UIControl     % 0, 1
        ShowWorkLabel               matlab.ui.control.UIControl     % Show in Wo...
        ShowWorkSwitch              matlab.ui.control.UIControl     % 0, 1
        ChangesSavedLabel           matlab.ui.control.UIControl     % Changes Saved
        ChangesSavedLamp            d12pack.lamp
        StartButton                 matlab.ui.control.UIControl     % Select Start
        EndButton                   matlab.ui.control.UIControl     % Select End
        SaveButton                  matlab.ui.control.UIControl     % Save Changes
        CancelButton                matlab.ui.control.UIControl     % Cancel Cha...
        SubjectIDLabel              matlab.ui.control.UIControl     % Subject ID:
        SubjectID                   matlab.ui.control.UIControl     % SubjectID
        DaysimeterSNLabel           matlab.ui.control.UIControl     % Daysimeter...
        DaysimeterSN                matlab.ui.control.UIControl     % DaysimeterSN
        ExitButton                  matlab.ui.control.UIControl     % Save & Exit
    end
    
    properties (Access = public, SetObservable)
        Data % Description
    end
    
    properties (Access = private, SetObservable)
        hCS
        hAI
        hBed % Description
        hWork
        TempData
    end
    
    properties (Access = private)
        Blue   = [180, 211, 227]/255; % circadian stimulus
        Grey   = [226, 226, 226]/255; % excluded data
        Red    = [255, 215, 215]/255; % error
        Yellow = [255, 255, 191]/255; % noncompliance
        Purple = [186, 141, 186]/255; % in bed
        Green  = [124, 197, 118]/255; % at work
    end
    
    %% Public Methods
    methods (Access = public)
        % Construct app
        function app = maskingUI(varargin)
            
            % Create and configure components
            app.createComponents;
            
            % Execute the startup function
            app.startupFcn;
            
            if nargin > 0
                app.loadData(varargin{1});
            end
            
            if nargout == 0
                clear app
            end
        end
        
        % Code that executes before app deletion
        function delete(app)
            
            % Delete Figure when app is deleted
            delete(app.Figure)
        end
        
        % Load data from obj
        function app = loadData(app,DataObj)
            app.Data = DataObj;
            app.SubjectID.String = app.Data.ID;
            app.DaysimeterSN.String = num2str(app.Data.SerialNumber);
            app.plotData;
        end
        
        
        % Save changes
        function app = saveChanges(app)
            app.Data = app.TempData;
        end
        
        %Discard changes
        function app = discardCahnges(app)
            app.TempData = app.Data;
        end
        
    end
    
    %% Private Methods
    methods (Access = private)
        
        % Code that executes after component creation
        function app = startupFcn(app)
            addlistener(app,'Data','PostSet',@app.DataSavedCallback);
            addlistener(app,'TempData','PostSet',@app.DataChangedCallback);
        end
        
        function app = plotData(app)
            hold(app.DataAxes,'on');
            
            t0 = datenum(app.Data.Time);
            t1 = [t0(1);t0;t0(end)];
            
            app.hBed = patch;
            app.hBed.Parent = app.DataAxes;
            app.hBed.XData = t1;
            app.hBed.YData = [0;double(app.Data.InBed);0];
            app.hBed.EdgeColor = 'none';
            app.hBed.FaceColor = app.Purple;
            app.hBed.DisplayName = 'In Bed';
            
            app.hWork = patch;
            app.hWork.Parent = app.DataAxes;
            app.hWork.XData = t1;
            app.hWork.YData = [0;double(app.Data.AtWork);0];
            app.hWork.EdgeColor = 'none';
            app.hWork.FaceColor = app.Green;
            app.hWork.DisplayName = 'At Work';
            
            app.hCS = patch;
            app.hCS.Parent = app.DataAxes;
            app.hCS.XData = t1;
            app.hCS.YData = [0;app.Data.CircadianStimulus;0];
            app.hCS.DisplayName = 'Circadian Stimulus (CS)';
            app.hCS.EdgeColor = 'none';
            app.hCS.FaceColor = app.Blue;
            
            app.hAI = plot(app.DataAxes,...
                app.Data.Time,app.Data.ActivityIndex,...
                'Color','black',...
                'LineWidth',0.5);
            app.hAI.DisplayName = 'Activity Index';
            
            hold(app.DataAxes,'off');
            
            app.ShowBedSwitchValueChanged;
        end
        
        function app = refreshdata(app)
            t0 = datenum(app.Data.Time);
            t1 = [t0(1);t0;t0(end)];
            
            app.hCS.XData = t1;
            app.hCS.YData = [0;app.Data.CircadianStimulus;0];
            
            app.hAI.XData = t0;
            app.hAI.YData = app.Data.ActivityIndex;
            
            app.hBed.XData = t1;
            app.hBed.YData = [0;double(app.Data.InBed);0];
            
            app.hWork.XData = t1;
            app.hWork.YData = [0;double(app.Data.AtWork);0];
        end
        
    end
    
    %% App initialization and construction
    methods (Access = private)
        
        % Create Figure and components
        function createComponents(app)
            
            % Create Figure
            app.Figure = figure;
            app.Figure.Units = 'pixels';
            ScreenSize = get(groot,'ScreenSize');
            app.Figure.Position = [100 100 ScreenSize(3)-200 ScreenSize(4)-300];
            app.Figure.Name = 'Figure';
            
            % Create SubjectIDLabel
            app.SubjectIDLabel = uicontrol(app.Figure);
            app.SubjectIDLabel.Style = 'text';
            app.SubjectIDLabel.HorizontalAlignment = 'right';
            app.SubjectIDLabel.FontUnits = 'pixels';
            app.SubjectIDLabel.FontSize = 18;
            app.SubjectIDLabel.Position = [20 app.Figure.Position(4)-43 130 23];
            app.SubjectIDLabel.String = 'Subject ID:';
            
            % Create SubjectID
            app.SubjectID = uicontrol(app.Figure);
            app.SubjectID.Style = 'text';
            app.SubjectID.HorizontalAlignment = 'left';
            app.SubjectID.FontUnits = 'pixels';
            app.SubjectID.FontSize = 18;
            app.SubjectID.Position = [160 app.Figure.Position(4)-43 100 23];
            app.SubjectID.String = 'SubjectID';
            
            % Create DaysimeterSNLabel
            app.DaysimeterSNLabel = uicontrol(app.Figure);
            app.DaysimeterSNLabel.Style = 'text';
            app.DaysimeterSNLabel.HorizontalAlignment = 'right';
            app.DaysimeterSNLabel.FontUnits = 'pixels';
            app.DaysimeterSNLabel.FontSize = 18;
            app.DaysimeterSNLabel.Position = [20 app.Figure.Position(4)-86 130 23];
            app.DaysimeterSNLabel.String = 'Daysimeter SN:';
            
            % Create DaysimeterSN
            app.DaysimeterSN = uicontrol(app.Figure);
            app.DaysimeterSN.Style = 'text';
            app.DaysimeterSN.HorizontalAlignment = 'left';
            app.DaysimeterSN.FontUnits = 'pixels';
            app.DaysimeterSN.FontSize = 18;
            app.DaysimeterSN.Position = [160 app.Figure.Position(4)-86 100 23];
            app.DaysimeterSN.String = 'DaysimeterSN';
            
            % Create DataAxes
            app.DataAxes = axes(app.Figure);
            app.DataAxes.Units = 'pixels';
            title(app.DataAxes, 'Daysimeter Data');
            xlabel(app.DataAxes, 'Time');
            ylabel(app.DataAxes, 'Circadian Stimulus & Activity Index');
            app.DataAxes.FontName = 'Arial';
            app.DataAxes.Box = 'on';
            app.DataAxes.XGrid = 'on';
            app.DataAxes.YGrid = 'on';
            app.DataAxes.OuterPosition = [220 20 app.Figure.Position(3)-240 app.Figure.Position(4)-40];
            app.DataAxes.YLim = [0 1];
            app.DataAxes.YLimMode = 'manual';
            
            % Create ButtonGroup
            app.ButtonGroup = uibuttongroup(app.Figure);
            app.ButtonGroup.BorderType = 'line';
            app.ButtonGroup.TitlePosition = 'lefttop';
            %             app.ButtonGroup.Title = 'Mask Type';
            app.ButtonGroup.FontName = 'Helvetica';
            app.ButtonGroup.FontUnits = 'pixels';
            app.ButtonGroup.FontSize = 12;
            app.ButtonGroup.Units = 'pixels';
            app.ButtonGroup.Position = [17 314 188 88];
            app.ButtonGroup.Clipping = 'off';
            
            % Create ObservationRadioButton
            app.ObservationRadioButton = uicontrol(app.ButtonGroup);
            app.ObservationRadioButton.Style = 'radiobutton';
            app.ObservationRadioButton.String = 'Observation';
            app.ObservationRadioButton.Position = [10 62 85 16];
            app.ObservationRadioButton.Value = true;
            
            % Create ErrorRadioButton
            app.ErrorRadioButton = uicontrol(app.ButtonGroup);
            app.ErrorRadioButton.Style = 'radiobutton';
            app.ErrorRadioButton.String = 'Error';
            app.ErrorRadioButton.Position = [10 36 46 16];
            
            % Create NoncomplianceRadioButton
            app.NoncomplianceRadioButton = uicontrol(app.ButtonGroup);
            app.NoncomplianceRadioButton.Style = 'radiobutton';
            app.NoncomplianceRadioButton.String = 'Noncompliance';
            app.NoncomplianceRadioButton.Position = [10 10 105 16];
            
            % Create ShowBedLabel
            app.ShowBedLabel = uicontrol(app.Figure);
            app.ShowBedLabel.Style = 'text';
            app.ShowBedLabel.HorizontalAlignment = 'center';
            app.ShowBedLabel.Position = [28 440 101 15];
            app.ShowBedLabel.String = 'Show in Bed Mask';
            
            % Create ShowBedSwitch
            app.ShowBedSwitch = uicontrol(app.Figure);
            app.ShowBedSwitch.Style = 'checkbox';
            app.ShowBedSwitch.Callback = @app.ShowBedSwitchValueChanged;
            app.ShowBedSwitch.Position = [160 437 45 20];
            app.ShowBedSwitch.Value = app.ShowBedSwitch.Max;
            
            % Create ShowWorkLabel
            app.ShowWorkLabel = uicontrol(app.Figure);
            app.ShowWorkLabel.Style = 'text';
            app.ShowWorkLabel.HorizontalAlignment = 'center';
            app.ShowWorkLabel.Position = [28 410 101 15];
            app.ShowWorkLabel.String = 'Show at Work Mask';
            
            % Create ShowWorkSwitch
            app.ShowWorkSwitch = uicontrol(app.Figure);
            app.ShowWorkSwitch.Style = 'checkbox';
            app.ShowWorkSwitch.Callback = @app.ShowWorkSwitchValueChanged;
            app.ShowWorkSwitch.Position = [160 407 45 20];
            app.ShowWorkSwitch.Value = app.ShowBedSwitch.Max;
            
            % Create LabelLamp
            app.ChangesSavedLabel = uicontrol(app.Figure);
            app.ChangesSavedLabel.Style = 'text';
            app.ChangesSavedLabel.HorizontalAlignment = 'right';
            app.ChangesSavedLabel.Position = [28 480 88 15];
            app.ChangesSavedLabel.String = 'Changes Saved';
            
            % Create ChangesSavedLamp
            app.ChangesSavedLamp = d12pack.lamp(app.Figure);
            app.ChangesSavedLamp.Position = [160 477 20 20];
            
            % Create StartButton
            app.StartButton = uicontrol(app.Figure);
            app.StartButton.Style = 'pushbutton';
            app.StartButton.Position = [61 272 100 22];
            app.StartButton.String = 'Select Start';
            app.StartButton.Callback = @app.StartButtonCallback;
            
            % Create EndButton
            app.EndButton = uicontrol(app.Figure);
            app.EndButton.Style = 'pushbutton';
            app.EndButton.Position = [61 230 100 22];
            app.EndButton.String = 'Select End';
            app.EndButton.Callback = @app.EndButtonCallback;
            app.EndButton.Enable = 'off';
            
            % Create SaveButton
            app.SaveButton = uicontrol(app.Figure);
            app.SaveButton.Style = 'pushbutton';
            app.SaveButton.Position = [61 188 100 22];
            app.SaveButton.String = 'Save Changes';
            app.SaveButton.Callback = @app.SaveButtonCallback;
            app.SaveButton.Enable = 'off';
            
            % Create CancelButton
            app.CancelButton = uicontrol(app.Figure);
            app.CancelButton.Style = 'pushbutton';
            app.CancelButton.Position = [61 146 100 22];
            app.CancelButton.String = 'Cancel Changes';
            app.CancelButton.Callback = @app.CancelButtonCallback;
            app.CancelButton.Enable = 'off';
            
            % Create ExitButton
            app.ExitButton = uicontrol(app.Figure);
            app.ExitButton.Style = 'pushbutton';
            app.ExitButton.Position = [61 41 100 22];
            app.ExitButton.String = 'Save & Exit';
            app.ExitButton.Callback = @app.ExitButtonCallback;
        end
    end
    
    %% Callbacks
    methods
        % ShowBedSwitch value changed function
        function ShowBedSwitchValueChanged(app,src,callbackData)
            value = app.ShowBedSwitch.Value;
            switch value
                case app.ShowBedSwitch.Max % On state
                    app.hBed.Visible = 'on';
                    app.refreshdata;
                case app.ShowBedSwitch.Min % Off state
                    app.hBed.Visible = 'off';
                otherwise
                    error('ShowBedSwitch value not recognized');
            end
        end
        
        % ShowWorkSwitch value changed function
        function ShowWorkSwitchValueChanged(app,src,callbackData)
            value = app.ShowWorkSwitch.Value;
            switch value
                case app.ShowWorkSwitch.Max % On state
                    app.hWork.Visible = 'on';
                    app.refreshdata;
                case app.ShowWorkSwitch.Min % Off state
                    app.hWork.Visible = 'off';
                otherwise
                    error('ShowBedSwitch value not recognized');
            end
        end
        
        % Data saved callback
        function DataSavedCallback(app,src,evnt)
            app.ChangesSavedLamp.Value = 'on';
        end
        
        % TempData modified callback
        function DataChangedCallback(app,src,evnt)
            app.ChangesSavedLamp.Value = 'off';
        end
        
        function StartButtonCallback(app,src,callbackData)
            app.StartButton.Enable = 'off';
            app.EndButton.Enable = 'on';
        end
        
        function EndButtonCallback(app,src,callbackData)
            
            app.EndButton.Enable = 'off';
            app.SaveButton.Enable = 'on';
            app.CancelButton.Enable = 'on';
        end
        
        function SaveButtonCallback(app,src,callbackData)
            
            app.SaveButton.Enable = 'off';
            app.CancelButton.Enable = 'off';
            app.StartButton.Enable = 'on';
        end
        
        function CancelButtonCallback(app,src,callbackData)
            
            app.SaveButton.Enable = 'off';
            app.CancelButton.Enable = 'off';
            app.StartButton.Enable = 'on';
        end
        
        function ExitButtonCallback(app,src,callbackData)
            app.saveChanges;
            app.delete;
        end
    end
end