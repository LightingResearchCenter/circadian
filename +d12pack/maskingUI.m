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
        LabelSwitch                 matlab.ui.control.UIControl     % Show in Be...
        ShowBedSwitch               matlab.ui.control.UIControl     % On, Off
        LabelLamp                   matlab.ui.control.UIControl     % Changes Saved
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
    
    properties (Access = private)
        hCS
        hAI
        hBed % Description
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
        
    end
    
    %% Private Methods
    methods (Access = private)
        
        % Code that executes after component creation
        function app = startupFcn(app)
            addlistener(app,'Data','PostSet',@app.DataChanged);
        end
        
        function app = plotData(app)
            hold(app.DataAxes,'on');
            
            app.hBed = patch;
            app.hBed.Parent = app.DataAxes;
            app.hBed.XData = datenum([app.Data.Time(1);app.Data.Time;app.Data.Time(end)]);
            app.hBed.YData = [0;double(app.Data.InBed);0];
            app.hBed.EdgeColor = 'none';
            app.hBed.FaceColor = [186, 141, 186]/255;
            app.hBed.DisplayName = 'In Bed';
            
            app.hCS = patch;
            app.hCS.Parent = app.DataAxes;
            app.hCS.XData = datenum([app.Data.Time(1);app.Data.Time;app.Data.Time(end)]);
            app.hCS.YData = [0;app.Data.CircadianStimulus;0];
            app.hCS.DisplayName = 'Circadian Stimulus (CS)';
            app.hCS.EdgeColor = 'none';
            app.hCS.FaceColor = [180, 211, 227]/255;
            
            app.hAI = plot(app.DataAxes,app.Data.Time,app.Data.ActivityIndex);
            app.hAI.DisplayName = 'Activity Index';
            app.hAI.Color = 'black';
            
            hold(app.DataAxes,'off');
            
            app.ShowBedSwitchValueChanged;
        end
        
        function app = refreshdata(app)
            app.hCS.XData = datenum([app.Data.Time(1);app.Data.Time;app.Data.Time(end)]);
            app.hCS.YData = [0;app.Data.CircadianStimulus;0];
            
            app.hAI.XData = datenum(app.Data.Time);
            app.hAI.YData = app.Data.ActivityIndex;
            
            app.hBed.XData = datenum([app.Data.Time(1);app.Data.Time;app.Data.Time(end)]);
            app.hBed.YData = [0;double(app.Data.InBed);0];
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
            
            % Create LabelSwitch
            app.LabelSwitch = uicontrol(app.Figure);
            app.LabelSwitch.Style = 'text';
            app.LabelSwitch.HorizontalAlignment = 'center';
            app.LabelSwitch.Position = [28 440 101 15];
            app.LabelSwitch.String = 'Show in Bed Mask';
            
            % Create ShowBedSwitch
            app.ShowBedSwitch = uicontrol(app.Figure);
            app.ShowBedSwitch.Style = 'checkbox';
            app.ShowBedSwitch.Callback = @app.ShowBedSwitchValueChanged;
            app.ShowBedSwitch.Position = [160 437 45 20];
            app.ShowBedSwitch.Value = app.ShowBedSwitch.Max;
            
            % Create LabelLamp
            app.LabelLamp = uicontrol(app.Figure);
            app.LabelLamp.Style = 'text';
            app.LabelLamp.HorizontalAlignment = 'right';
            app.LabelLamp.Position = [28 480 88 15];
            app.LabelLamp.String = 'Changes Saved';
            
            % Create ChangesSavedLamp
            app.ChangesSavedLamp = d12pack.lamp(app.Figure);
            app.ChangesSavedLamp.Position = [160 477 20 20];
            
            % Create StartButton
            app.StartButton = uicontrol(app.Figure);
            app.StartButton.Style = 'pushbutton';
            app.StartButton.Position = [61 272 100 22];
            app.StartButton.String = 'Select Start';
            
            % Create EndButton
            app.EndButton = uicontrol(app.Figure);
            app.EndButton.Style = 'pushbutton';
            app.EndButton.Position = [61 230 100 22];
            app.EndButton.String = 'Select End';
            
            % Create SaveButton
            app.SaveButton = uicontrol(app.Figure);
            app.SaveButton.Style = 'pushbutton';
            app.SaveButton.Position = [61 188 100 22];
            app.SaveButton.String = 'Save Changes';
            
            % Create CancelButton
            app.CancelButton = uicontrol(app.Figure);
            app.CancelButton.Style = 'pushbutton';
            app.CancelButton.Position = [61 146 100 22];
            app.CancelButton.String = 'Cancel Changes';
            
            % Create ExitButton
            app.ExitButton = uicontrol(app.Figure);
            app.ExitButton.Style = 'pushbutton';
            app.ExitButton.Position = [61 41 100 22];
            app.ExitButton.String = 'Save & Exit';
        end
    end
    
    %% Callbacks
    methods
        % ShowBedSwitch value changed function
        function ShowBedSwitchValueChanged(app,src,callbackData)
            value = app.ShowBedSwitch.Value;
            switch value
                case app.ShowBedSwitch.Max % On state
                    app.refreshdata;
                    app.hBed.Visible = 'on';
                case app.ShowBedSwitch.Min % Off state
                    app.hBed.Visible = 'off';
                otherwise
                    error('ShowBedSwitch value not recognized');
            end
        end
        
        % Data value changed function
        function DataChanged(app,src,evnt)
            app.ChangesSavedLamp.Value = 'off';
        end
    end
end