classdef WatermarkEvaluationToolkit_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        AudioWatermarkEvaluationToolkitUIFigure  matlab.ui.Figure
        lblTitle               matlab.ui.control.Label
        btnPlay1               matlab.ui.control.Button
        btnUploadAudio         matlab.ui.control.Button
        btnPause1              matlab.ui.control.Button
        btnResume1             matlab.ui.control.Button
        btnStop1               matlab.ui.control.Button
        lblAudioName           matlab.ui.control.Label
        lblCurrent             matlab.ui.control.Label
        btnExit                matlab.ui.control.Button
        TabGroup               matlab.ui.container.TabGroup
        HomeTab                matlab.ui.container.Tab
        lblWelcomeTitle        matlab.ui.control.Label
        txtAdd_2               matlab.ui.control.TextArea
        AddTab                 matlab.ui.container.Tab
        txtAdd                 matlab.ui.control.TextArea
        btnHardClipping        matlab.ui.control.Button
        btnSoftClipping        matlab.ui.control.Button
        lblHardClipping        matlab.ui.control.Label
        lblSoftClipping        matlab.ui.control.Label
        btnWhiteNoise          matlab.ui.control.Button
        lblWhiteNoise          matlab.ui.control.Label
        btnDelay               matlab.ui.control.Button
        lblDelay               matlab.ui.control.Label
        FilterTab              matlab.ui.container.Tab
        txtFilter              matlab.ui.control.TextArea
        btnLowPass             matlab.ui.control.Button
        lblLowPass             matlab.ui.control.Label
        btnHighPass            matlab.ui.control.Button
        lblHighPass            matlab.ui.control.Label
        btnNotchFilter         matlab.ui.control.Button
        lblNotchFilter         matlab.ui.control.Label
        CropTab                matlab.ui.container.Tab
        txtCrop                matlab.ui.control.TextArea
        btnCrop                matlab.ui.control.Button
        lblCrop                matlab.ui.control.Label
        btnCropRegion          matlab.ui.control.Button
        lblCropRegion          matlab.ui.control.Label
        DesynchroniseTab       matlab.ui.container.Tab
        txtSync                matlab.ui.control.TextArea
        btnNormalise           matlab.ui.control.Button
        lblNormalise           matlab.ui.control.Label
        btnTimeStretch         matlab.ui.control.Button
        lblTimeStretch         matlab.ui.control.Label
        btnResample            matlab.ui.control.Button
        lblResample            matlab.ui.control.Label
        btnPitchShift          matlab.ui.control.Button
        lblPitchShift          matlab.ui.control.Label
        btnBits                matlab.ui.control.Button
        lblBits                matlab.ui.control.Label
        btnMonoStereo          matlab.ui.control.Button
        lblMonoStereo          matlab.ui.control.Label
        btnM4A                 matlab.ui.control.Button
        lblMonoStereo_2        matlab.ui.control.Label
        lblFs                  matlab.ui.control.Label
        lblFsValue             matlab.ui.control.Label
        lblChannels            matlab.ui.control.Label
        lblChannelsValue       matlab.ui.control.Label
        lblDuration            matlab.ui.control.Label
        lblDurationValue       matlab.ui.control.Label
        lblBitsPerSample       matlab.ui.control.Label
        lblBitsPerSampleValue  matlab.ui.control.Label
        lblCurrentAudio        matlab.ui.control.Label
        lblName                matlab.ui.control.Label
    end


    properties (Access = public)
        audioChoice;
        newAudio;
        fsNewAudio;
        player;
        currentAudio;
        fsCurrentAudio;
        
        UIFigure;
        confirmMessage;
        
        info;
        filepath;
        name;
        ext;
    end

    methods (Access = public)
    
        function getAudio(app)
            
            %app.audioChoice = uigetfile('*.wav');
            [app.newAudio, app.fsNewAudio] = audioread(app.audioChoice);
            app.player = audioplayer(app.newAudio, app.fsNewAudio);
            
            app.info = audioinfo(app.audioChoice);
            
            [app.filepath, app.name, app.ext] = fileparts(app.audioChoice);
            
            app.lblAudioName.Text = ([app.name, app.ext]);
            app.lblDurationValue.Text = ([num2str(app.info.Duration), ' seconds']);
            app.lblChannelsValue.Text = (num2str(app.info.NumChannels));
            app.lblFsValue.Text = ([num2str(app.info.SampleRate), ' Hz']);
            app.lblBitsPerSampleValue.Text = ([num2str(app.info.BitsPerSample), ' bit']);
            
            
            app.currentAudio = app.newAudio;
            app.fsCurrentAudio = app.fsNewAudio;
            
        end
        
        function audioOutput(app)
        
            fig = uifigure;
            msg = 'Audio processed. Please choose an option.';
            title = 'Audio Processed';
            selection = uiconfirm(fig,msg,title,...
           'Options',{'Save. Continue with current.','Save. Continue with original.','Save. Upload new.'},...
           'DefaultOption',1,'CloseFcn',@(h,e) close(fig));
       
                if strcmpi('Save. Continue with current.', selection)
                    [file, path] = uiputfile('*.wav');
                    audiowrite([path, file], app.currentAudio, app.fsCurrentAudio);
                    app.audioChoice = [path, file];
                    getAudio(app);
                
                else if strcmpi('Save. Continue with original.', selection)
                    [file, path] = uiputfile('*.wav');
                    audiowrite([path, file], app.currentAudio, app.fsCurrentAudio);
            
                else if strcmpi('Save. Upload new.', selection)
                    [file, path] = uiputfile('*.wav');
                    audiowrite([path, file], app.currentAudio, app.fsCurrentAudio);
                    app.audioChoice = uigetfile('*.wav');
                    getAudio(app)
                end
                end
                end

            end
            end



    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            
        end

        % Button pushed function: btnCrop
        function btnCropButtonPushed(app, event)

            cropPrompt = {'Crop from start of signal (seconds):', 'Crop from end of signal (seconds):'};
            dlgtitle = 'Crop Parameters';
            answer = inputdlg(cropPrompt, dlgtitle, [1, 40]);
            
            answer1 = str2double(answer{1});
            answer2 = str2double(answer{2});
            
            app.currentAudio = AWETCropSignal(app.currentAudio, app.fsCurrentAudio, app.info.NumChannels, answer1, answer2);
            
            audioOutput(app);
            
        end

        % Button pushed function: btnExit
        function btnExitButtonPushed(app, event)
            app.delete
        end

        % Button pushed function: btnHardClipping
        function btnHardClippingButtonPushed(app, event)
            
            hardClippingPrompt1 = {'Positive threshold:', 'Negative threshold:'};
            dlgtitle = 'Hard Clipping Threshold';
            answer = inputdlg(hardClippingPrompt1, dlgtitle, [1, 40]);
            
            answer1 = str2double(answer{1});
            answer2 = str2double(answer{2});
            
            app.currentAudio = AWETHardClipping(app.currentAudio, app.info.NumChannels, answer1, answer2);
            
            audioOutput(app);
            
        end

        % Button pushed function: btnNormalise
        function btnNormaliseButtonPushed(app, event)
            
            app.currentAudio = AWETNormalise(app.currentAudio);
            
            audioOutput(app);
            
        end

        % Button pushed function: btnPause1
        function btnPause1ButtonPushed(app, event)
            pause(app.player);
        end

        % Button pushed function: btnPlay1
        function btnPlay1Pushed(app, event)
            play(app.player);
        end

        % Button pushed function: btnResume1
        function btnResume1ButtonPushed(app, event)
            resume(app.player);
        end

        % Button pushed function: btnSoftClipping
        function btnSoftClippingButtonPushed(app, event)
            
            softClippingPrompt = {'Please specify a gain amount'};
            dlgtitle = 'Soft Clipping Gain';
            answer = inputdlg(softClippingPrompt, dlgtitle, [1, 40]);
            
            answer = str2double(answer);
            
            app.currentAudio = AWETSoftClipping(app.currentAudio, answer);
            
            audioOutput(app);
            
            %}
        end

        % Button pushed function: btnStop1
        function btnStop1ButtonPushed(app, event)
            stop(app.player);
        end

        % Button pushed function: btnUploadAudio
        function uploadAudioButtonPushed(app, event)

            app.audioChoice = uigetfile('*.wav');
            getAudio(app);      
           
        end

        % Button pushed function: btnLowPass
        function btnLowPassButtonPushed(app, event)
            
            lowPassPrompt = {'Enter cutoff (Hz):','Enter Q value:'};
            dlgtitle = 'Low Pass Filter';
            dims = [1 35];
            definput = {'100','1'};
            answer = inputdlg(lowPassPrompt,dlgtitle,dims,definput);
            
            answerFreq = str2double(answer{1});
            answerQ = str2double(answer{2});
            
            [a,b] = AWETLowPass(app.fsCurrentAudio, answerFreq, answerQ);
            
            app.currentAudio = filter(b, a, app.currentAudio);
            
            audioOutput(app);
            
        end

        % Button pushed function: btnTimeStretch
        function btnTimeStretchButtonPushed(app, event)
            timeStretchPrompt = {'Enter scale:'};
            dlgtitle = 'Time Stretch Scale';
            dims = [1 35];
            definput = {'1'};
            answer = inputdlg(timeStretchPrompt,dlgtitle,dims,definput);
            
            scaleValue = str2double(answer{1});
            
            app.currentAudio = stretchAudio(app.currentAudio, scaleValue);
            
            audioOutput(app);
            
        end

        % Button pushed function: btnHighPass
        function btnHighPassButtonPushed(app, event)
            
            highPassPrompt = {'Enter cutoff (Hz):','Enter Q value:'};
            dlgtitle = 'High Pass Filter';
            dims = [1 35];
            definput = {'1000','1'};
            answer = inputdlg(highPassPrompt,dlgtitle,dims,definput);
            
            answerFreq = str2double(answer{1});
            answerQ = str2double(answer{2});
            
            [a,b] = AWETHighPass(app.fsCurrentAudio, answerFreq, answerQ);
            
            app.currentAudio = filter(b, a, app.currentAudio);
            
            audioOutput(app);
            
        end

        % Button pushed function: btnResample
        function btnResampleButtonPushed(app, event)
            
            resamplePrompt = {'Resample rate (Hz):'};
            dlgtitle = 'Resample Signal';
            dims = [1 35];
            answer = inputdlg(resamplePrompt,dlgtitle,dims);
            
            resampleAnswer = str2double(answer{1});
            
            app.currentAudio = AWETResample(app.currentAudio, app.fsCurrentAudio, resampleAnswer);
            
            app.fsCurrentAudio = resampleAnswer;
            
            audioOutput(app);
            
            
        end

        % Button pushed function: btnWhiteNoise
        function btnWhiteNoiseButtonPushed(app, event)
            
            whiteNoisePrompt = {'Signal to noise ratio:'};
            dlgtitle = 'Gaussian White Noise';
            dims = [1 35];
            answer = inputdlg(whiteNoisePrompt,dlgtitle,dims);
            
            snrAnswer = str2double(answer{1});
            
            app.currentAudio = awgn(app.currentAudio, snrAnswer, 'measured');
            
            audioOutput(app);
        end

        % Button pushed function: btnPitchShift
        function btnPitchShiftButtonPushed(app, event)
            pitchShiftPrompt = {'Semitones:'};
            dlgtitle = 'Pitch Shift Semitones';
            dims = [1 30];
            answer = inputdlg(pitchShiftPrompt,dlgtitle,dims);
            
            semitonesAnswer = str2double(answer{1});
            
            app.currentAudio = shiftPitch(app.currentAudio, semitonesAnswer);
            
            audioOutput(app);
        end

        % Button pushed function: btnBits
        function btnBitsButtonPushed(app, event)
            bitsPrompt = {'Bits per sample (8, 16, 24, 32, 64):'};
            dlgtitle = 'Bits Per Sample';
            dims = [1 30];
            answer = inputdlg(bitsPrompt, dlgtitle, dims);
            
            bpsAnswer = str2double(answer{1});
            
            fig = uifigure;
            msg = 'Audio processed. Please choose an option.';
            title = 'Audio Processed';
            selection = uiconfirm(fig,msg,title,...
           'Options',{'Save. Continue with current.','Save. Continue with original.','Save. Upload new.'},...
           'DefaultOption',1,'CloseFcn',@(h,e) close(fig));
       
                if strcmpi('Save. Continue with current.', selection)
                    [file, path] = uiputfile('*.wav');
                    audiowrite([path, file], app.currentAudio, app.fsCurrentAudio, "BitsPerSample",bpsAnswer);
                    app.audioChoice = [path, file];
                    getAudio(app);
                
                else if strcmpi('Save. Continue with original.', selection)
                    [file, path] = uiputfile('*.wav');
                    audiowrite([path, file], app.currentAudio, app.fsCurrentAudio, "BitsPerSample",bpsAnswer);
            
                else if strcmpi('Save. Upload new.', selection)
                    [file, path] = uiputfile('*.wav');
                    audiowrite([path, file], app.currentAudio, app.fsCurrentAudio, "BitsPerSample",bpsAnswer);
                    app.audioChoice = uigetfile('*.wav');
                    getAudio(app)
                end
                end
                end
            
        end

        % Button pushed function: btnMonoStereo
        function btnMonoStereoButtonPushed(app, event)
            app.currentAudio = AWETChannels(app.currentAudio, app.info.NumChannels);
            
            audioOutput(app);
        end

        % Button pushed function: btnCropRegion
        function btnCropRegionButtonPushed(app, event)
            cropPrompt = {'Remove region from (seconds):', 'To (seconds):'};
            dlgtitle = 'Region Parameters';
            answer = inputdlg(cropPrompt, dlgtitle, [1, 40]);
            
            answer1 = str2double(answer{1});
            answer2 = str2double(answer{2});
            
            app.currentAudio = AWETCropRegion(app.currentAudio, app.fsCurrentAudio, app.info.NumChannels, answer1, answer2);
            
            audioOutput(app);
        end

        % Button pushed function: btnDelay
        function btnDelayButtonPushed(app, event)
            cropPrompt = {'Delay time (seconds)', 'Delay gain:'};
            dlgtitle = 'Delay Parameters';
            answer = inputdlg(cropPrompt, dlgtitle, [1, 40]);
            
            answer1 = str2double(answer{1});
            answer2 = str2double(answer{2});
            
            app.currentAudio = AWETDelay(app.currentAudio, app.fsCurrentAudio, app.info.NumChannels, answer1, answer2);
            
            audioOutput(app);
        end

        % Callback function
        function btnReverbButtonPushed(app, event)
            
        end

        % Button pushed function: btnNotchFilter
        function btnNotchFilterButtonPushed(app, event)
            notchPrompt = {'Enter cutoff (Hz):','Enter Q value:'};
            dlgtitle = 'Notch Filter';
            dims = [1 35];
            definput = {'1000','1'};
            answer = inputdlg(notchPrompt,dlgtitle,dims,definput);
            
            answerFreq = str2double(answer{1});
            answerQ = str2double(answer{2});
            
            [a,b] = AWETNotch(app.fsCurrentAudio, answerFreq, answerQ);
            
            app.currentAudio = filter(b, a, app.currentAudio);
            
            audioOutput(app);
        end

        % Button pushed function: btnM4A
        function btnM4AButtonPushed(app, event)
            m4aPrompt = {'Enter sampling frequency (44100 or 48000):','Enter bit rate (64, 96, 128, 192, 256, 320:'};
            dlgtitle = 'm4a Parameters';
            dims = [1 35];
            answer = inputdlg(m4aPrompt,dlgtitle,dims);
            
            answerFs = str2double(answer{1});
            answerBR = str2double(answer{2});
            
            if answerFs ~= answerFs
            app.currentAudio = AWETResample(app.currentAudio, app.fsCurrentAudio, answerFs);
            end
            
            fig = uifigure;
            msg = 'Audio processed. Please choose an option.';
            title = 'Audio Processed';
            selection = uiconfirm(fig,msg,title,...
           'Options',{'Save. Continue with original.','Save. Upload new.'},...
           'DefaultOption',1,'CloseFcn',@(h,e) close(fig));
       
                if strcmpi('Save. Continue with original.', selection)
                    [file, path] = uiputfile('*.m4a');
                    audiowrite([path, file], app.currentAudio, app.fsCurrentAudio, "BitRate", answerBR);
            
                else if strcmpi('Save. Upload new.', selection)
                    [file, path] = uiputfile('*.m4a');
                    audiowrite([path, file], app.currentAudio, app.fsCurrentAudio,"BitRate", answerBR);
                    app.audioChoice = uigetfile('*.wav');
                    getAudio(app)
               
                end
                end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create AudioWatermarkEvaluationToolkitUIFigure and hide until all components are created
            app.AudioWatermarkEvaluationToolkitUIFigure = uifigure('Visible', 'off');
            app.AudioWatermarkEvaluationToolkitUIFigure.AutoResizeChildren = 'off';
            app.AudioWatermarkEvaluationToolkitUIFigure.Position = [100 100 921 527];
            app.AudioWatermarkEvaluationToolkitUIFigure.Name = 'Audio Watermark Evaluation Toolkit';
            app.AudioWatermarkEvaluationToolkitUIFigure.Resize = 'off';

            % Create lblTitle
            app.lblTitle = uilabel(app.AudioWatermarkEvaluationToolkitUIFigure);
            app.lblTitle.HorizontalAlignment = 'center';
            app.lblTitle.FontSize = 30;
            app.lblTitle.FontWeight = 'bold';
            app.lblTitle.Position = [200 465 525 40];
            app.lblTitle.Text = 'Audio Watermark Evaluation Toolkit';

            % Create btnPlay1
            app.btnPlay1 = uibutton(app.AudioWatermarkEvaluationToolkitUIFigure, 'push');
            app.btnPlay1.ButtonPushedFcn = createCallbackFcn(app, @btnPlay1Pushed, true);
            app.btnPlay1.Position = [34 368 59.5 20];
            app.btnPlay1.Text = 'PLAY';

            % Create btnUploadAudio
            app.btnUploadAudio = uibutton(app.AudioWatermarkEvaluationToolkitUIFigure, 'push');
            app.btnUploadAudio.ButtonPushedFcn = createCallbackFcn(app, @uploadAudioButtonPushed, true);
            app.btnUploadAudio.Position = [33 406 300 22];
            app.btnUploadAudio.Text = 'Upload Audio';

            % Create btnPause1
            app.btnPause1 = uibutton(app.AudioWatermarkEvaluationToolkitUIFigure, 'push');
            app.btnPause1.ButtonPushedFcn = createCallbackFcn(app, @btnPause1ButtonPushed, true);
            app.btnPause1.Position = [114 368 59.5 20];
            app.btnPause1.Text = 'PAUSE';

            % Create btnResume1
            app.btnResume1 = uibutton(app.AudioWatermarkEvaluationToolkitUIFigure, 'push');
            app.btnResume1.ButtonPushedFcn = createCallbackFcn(app, @btnResume1ButtonPushed, true);
            app.btnResume1.Position = [193 368 60 20];
            app.btnResume1.Text = 'RESUME';

            % Create btnStop1
            app.btnStop1 = uibutton(app.AudioWatermarkEvaluationToolkitUIFigure, 'push');
            app.btnStop1.ButtonPushedFcn = createCallbackFcn(app, @btnStop1ButtonPushed, true);
            app.btnStop1.Position = [274 368 59.5 20];
            app.btnStop1.Text = 'STOP';

            % Create lblAudioName
            app.lblAudioName = uilabel(app.AudioWatermarkEvaluationToolkitUIFigure);
            app.lblAudioName.HorizontalAlignment = 'right';
            app.lblAudioName.Position = [123 258 210 15];
            app.lblAudioName.Text = '';

            % Create lblCurrent
            app.lblCurrent = uilabel(app.AudioWatermarkEvaluationToolkitUIFigure);
            app.lblCurrent.VerticalAlignment = 'top';
            app.lblCurrent.FontWeight = 'bold';
            app.lblCurrent.Position = [33 258 69 15];
            app.lblCurrent.Text = 'Audio File: ';

            % Create btnExit
            app.btnExit = uibutton(app.AudioWatermarkEvaluationToolkitUIFigure, 'push');
            app.btnExit.ButtonPushedFcn = createCallbackFcn(app, @btnExitButtonPushed, true);
            app.btnExit.Position = [33 64 300 22];
            app.btnExit.Text = 'Exit';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.AudioWatermarkEvaluationToolkitUIFigure);
            app.TabGroup.AutoResizeChildren = 'off';
            app.TabGroup.Position = [373 63 520 365];

            % Create HomeTab
            app.HomeTab = uitab(app.TabGroup);
            app.HomeTab.AutoResizeChildren = 'off';
            app.HomeTab.Title = 'Home';

            % Create lblWelcomeTitle
            app.lblWelcomeTitle = uilabel(app.HomeTab);
            app.lblWelcomeTitle.FontSize = 30;
            app.lblWelcomeTitle.FontWeight = 'bold';
            app.lblWelcomeTitle.Position = [21 287 259 40];
            app.lblWelcomeTitle.Text = 'Welcome';

            % Create txtAdd_2
            app.txtAdd_2 = uitextarea(app.HomeTab);
            app.txtAdd_2.Editable = 'off';
            app.txtAdd_2.BackgroundColor = [0.9412 0.9412 0.9412];
            app.txtAdd_2.Position = [21 45 482 220];
            app.txtAdd_2.Value = {'Welcome to Audio Watermark Evaluation Toolkit. This application features a range of processes that can be applied to a watermarked audio signal to evaluate its robustness, imperceptibility and capacity.'; ''; 'How to use:'; ''; '1. Upload an audio signal (mono/stereo wav)'; ''; '2. Choose a function from the tabs above.'; ''; '3. Enter any required parameters to customise the process.'; ''; '4. Save the processed audio. '; ''; '5. Continue with the processed, original or new audio signal.'; ''; ''};

            % Create AddTab
            app.AddTab = uitab(app.TabGroup);
            app.AddTab.AutoResizeChildren = 'off';
            app.AddTab.Title = 'Add';

            % Create txtAdd
            app.txtAdd = uitextarea(app.AddTab);
            app.txtAdd.Editable = 'off';
            app.txtAdd.HorizontalAlignment = 'center';
            app.txtAdd.BackgroundColor = [0.9412 0.9412 0.9412];
            app.txtAdd.Position = [30 257 448 64];
            app.txtAdd.Value = {'Additive attacks distort the signal by applying user defined levels of audio effects, such as clipping and delay. '; ''; 'Choose an attack below:'};

            % Create btnHardClipping
            app.btnHardClipping = uibutton(app.AddTab, 'push');
            app.btnHardClipping.ButtonPushedFcn = createCallbackFcn(app, @btnHardClippingButtonPushed, true);
            app.btnHardClipping.Position = [30 212 96 22];
            app.btnHardClipping.Text = 'Hard Clipping';

            % Create btnSoftClipping
            app.btnSoftClipping = uibutton(app.AddTab, 'push');
            app.btnSoftClipping.ButtonPushedFcn = createCallbackFcn(app, @btnSoftClippingButtonPushed, true);
            app.btnSoftClipping.Position = [30 178 96 22];
            app.btnSoftClipping.Text = 'Soft Clipping';

            % Create lblHardClipping
            app.lblHardClipping = uilabel(app.AddTab);
            app.lblHardClipping.HorizontalAlignment = 'right';
            app.lblHardClipping.VerticalAlignment = 'top';
            app.lblHardClipping.Position = [133 216 345 15];
            app.lblHardClipping.Text = 'Hard clipping of the audio at a specified amplitude.';

            % Create lblSoftClipping
            app.lblSoftClipping = uilabel(app.AddTab);
            app.lblSoftClipping.HorizontalAlignment = 'right';
            app.lblSoftClipping.VerticalAlignment = 'top';
            app.lblSoftClipping.Position = [133 182 345 15];
            app.lblSoftClipping.Text = 'Applies a soft clipping algorithm based on a user defined gain.';

            % Create btnWhiteNoise
            app.btnWhiteNoise = uibutton(app.AddTab, 'push');
            app.btnWhiteNoise.ButtonPushedFcn = createCallbackFcn(app, @btnWhiteNoiseButtonPushed, true);
            app.btnWhiteNoise.Position = [31 143 96 22];
            app.btnWhiteNoise.Text = 'White Noise';

            % Create lblWhiteNoise
            app.lblWhiteNoise = uilabel(app.AddTab);
            app.lblWhiteNoise.HorizontalAlignment = 'right';
            app.lblWhiteNoise.VerticalAlignment = 'top';
            app.lblWhiteNoise.Position = [133 141 345 22];
            app.lblWhiteNoise.Text = 'Add gaussian white noise to the signal.';

            % Create btnDelay
            app.btnDelay = uibutton(app.AddTab, 'push');
            app.btnDelay.ButtonPushedFcn = createCallbackFcn(app, @btnDelayButtonPushed, true);
            app.btnDelay.Position = [30 111 96 22];
            app.btnDelay.Text = 'Delay';

            % Create lblDelay
            app.lblDelay = uilabel(app.AddTab);
            app.lblDelay.HorizontalAlignment = 'right';
            app.lblDelay.VerticalAlignment = 'top';
            app.lblDelay.Position = [133 111 345 22];
            app.lblDelay.Text = 'Add a delay line to the signal.';

            % Create FilterTab
            app.FilterTab = uitab(app.TabGroup);
            app.FilterTab.AutoResizeChildren = 'off';
            app.FilterTab.Title = 'Filter';

            % Create txtFilter
            app.txtFilter = uitextarea(app.FilterTab);
            app.txtFilter.Editable = 'off';
            app.txtFilter.HorizontalAlignment = 'center';
            app.txtFilter.BackgroundColor = [0.9412 0.9412 0.9412];
            app.txtFilter.Position = [30 257 448 64];
            app.txtFilter.Value = {'Filter attacks allow for specified frequencies to be removed from the system.'; ''; ''; 'Choose an attack below:'};

            % Create btnLowPass
            app.btnLowPass = uibutton(app.FilterTab, 'push');
            app.btnLowPass.ButtonPushedFcn = createCallbackFcn(app, @btnLowPassButtonPushed, true);
            app.btnLowPass.Position = [30 212 96 22];
            app.btnLowPass.Text = 'Low Pass';

            % Create lblLowPass
            app.lblLowPass = uilabel(app.FilterTab);
            app.lblLowPass.HorizontalAlignment = 'right';
            app.lblLowPass.VerticalAlignment = 'top';
            app.lblLowPass.Position = [133 212 345 19];
            app.lblLowPass.Text = 'Define frequency and Q value to low pass the signal.';

            % Create btnHighPass
            app.btnHighPass = uibutton(app.FilterTab, 'push');
            app.btnHighPass.ButtonPushedFcn = createCallbackFcn(app, @btnHighPassButtonPushed, true);
            app.btnHighPass.Position = [31 177 96 22];
            app.btnHighPass.Text = 'High Pass';

            % Create lblHighPass
            app.lblHighPass = uilabel(app.FilterTab);
            app.lblHighPass.HorizontalAlignment = 'right';
            app.lblHighPass.VerticalAlignment = 'top';
            app.lblHighPass.Position = [133 177 345 20];
            app.lblHighPass.Text = 'Define frequency and Q value to low pass the signal.';

            % Create btnNotchFilter
            app.btnNotchFilter = uibutton(app.FilterTab, 'push');
            app.btnNotchFilter.ButtonPushedFcn = createCallbackFcn(app, @btnNotchFilterButtonPushed, true);
            app.btnNotchFilter.Position = [31 143 96 22];
            app.btnNotchFilter.Text = 'Notch Filter';

            % Create lblNotchFilter
            app.lblNotchFilter = uilabel(app.FilterTab);
            app.lblNotchFilter.HorizontalAlignment = 'right';
            app.lblNotchFilter.VerticalAlignment = 'top';
            app.lblNotchFilter.Position = [128 141 350 22];
            app.lblNotchFilter.Text = 'Remove specified frequency with adjustable attenuation and Q.';

            % Create CropTab
            app.CropTab = uitab(app.TabGroup);
            app.CropTab.AutoResizeChildren = 'off';
            app.CropTab.Title = 'Crop';

            % Create txtCrop
            app.txtCrop = uitextarea(app.CropTab);
            app.txtCrop.Editable = 'off';
            app.txtCrop.HorizontalAlignment = 'center';
            app.txtCrop.BackgroundColor = [0.9412 0.9412 0.9412];
            app.txtCrop.Position = [30 257 448 64];
            app.txtCrop.Value = {'Crop attacks remove user specified areas from the audio signal in the time domain.'; ''; 'Choose an attack below:'};

            % Create btnCrop
            app.btnCrop = uibutton(app.CropTab, 'push');
            app.btnCrop.ButtonPushedFcn = createCallbackFcn(app, @btnCropButtonPushed, true);
            app.btnCrop.Position = [30 212 96 22];
            app.btnCrop.Text = 'Crop';

            % Create lblCrop
            app.lblCrop = uilabel(app.CropTab);
            app.lblCrop.HorizontalAlignment = 'right';
            app.lblCrop.VerticalAlignment = 'top';
            app.lblCrop.Position = [150 216 328 15];
            app.lblCrop.Text = 'Removes a specified number of samples from audio signal.';

            % Create btnCropRegion
            app.btnCropRegion = uibutton(app.CropTab, 'push');
            app.btnCropRegion.ButtonPushedFcn = createCallbackFcn(app, @btnCropRegionButtonPushed, true);
            app.btnCropRegion.Position = [30 178 96 22];
            app.btnCropRegion.Text = 'Crop Region';

            % Create lblCropRegion
            app.lblCropRegion = uilabel(app.CropTab);
            app.lblCropRegion.HorizontalAlignment = 'right';
            app.lblCropRegion.VerticalAlignment = 'top';
            app.lblCropRegion.Position = [133 175 345 22];
            app.lblCropRegion.Text = 'Define region within signal to remove';

            % Create DesynchroniseTab
            app.DesynchroniseTab = uitab(app.TabGroup);
            app.DesynchroniseTab.AutoResizeChildren = 'off';
            app.DesynchroniseTab.Title = 'Desynchronise';

            % Create txtSync
            app.txtSync = uitextarea(app.DesynchroniseTab);
            app.txtSync.Editable = 'off';
            app.txtSync.HorizontalAlignment = 'center';
            app.txtSync.BackgroundColor = [0.9412 0.9412 0.9412];
            app.txtSync.Position = [30 257 448 64];
            app.txtSync.Value = {'Desynchronisation attacks modify data parameters of the signal to reduce watermark extraction.'; ''; 'Choose an attack below:'};

            % Create btnNormalise
            app.btnNormalise = uibutton(app.DesynchroniseTab, 'push');
            app.btnNormalise.ButtonPushedFcn = createCallbackFcn(app, @btnNormaliseButtonPushed, true);
            app.btnNormalise.Position = [30 212 96 22];
            app.btnNormalise.Text = 'Normalise';

            % Create lblNormalise
            app.lblNormalise = uilabel(app.DesynchroniseTab);
            app.lblNormalise.HorizontalAlignment = 'right';
            app.lblNormalise.VerticalAlignment = 'top';
            app.lblNormalise.Position = [169 216 309 15];
            app.lblNormalise.Text = 'Normalises the signal based on its maximum amplitude.';

            % Create btnTimeStretch
            app.btnTimeStretch = uibutton(app.DesynchroniseTab, 'push');
            app.btnTimeStretch.ButtonPushedFcn = createCallbackFcn(app, @btnTimeStretchButtonPushed, true);
            app.btnTimeStretch.Position = [30 178 96 22];
            app.btnTimeStretch.Text = 'Time Stretch';

            % Create lblTimeStretch
            app.lblTimeStretch = uilabel(app.DesynchroniseTab);
            app.lblTimeStretch.HorizontalAlignment = 'right';
            app.lblTimeStretch.VerticalAlignment = 'top';
            app.lblTimeStretch.Position = [139 177 339 22];
            app.lblTimeStretch.Text = 'Stretch signal in the time domain with a specified scale value.';

            % Create btnResample
            app.btnResample = uibutton(app.DesynchroniseTab, 'push');
            app.btnResample.ButtonPushedFcn = createCallbackFcn(app, @btnResampleButtonPushed, true);
            app.btnResample.Position = [30 111 96 22];
            app.btnResample.Text = 'Resample';

            % Create lblResample
            app.lblResample = uilabel(app.DesynchroniseTab);
            app.lblResample.HorizontalAlignment = 'right';
            app.lblResample.VerticalAlignment = 'top';
            app.lblResample.Position = [132 109 345 22];
            app.lblResample.Text = 'Reconfigure sample rate of signal.';

            % Create btnPitchShift
            app.btnPitchShift = uibutton(app.DesynchroniseTab, 'push');
            app.btnPitchShift.ButtonPushedFcn = createCallbackFcn(app, @btnPitchShiftButtonPushed, true);
            app.btnPitchShift.Position = [31 143 96 22];
            app.btnPitchShift.Text = 'Pitch Shift';

            % Create lblPitchShift
            app.lblPitchShift = uilabel(app.DesynchroniseTab);
            app.lblPitchShift.HorizontalAlignment = 'right';
            app.lblPitchShift.VerticalAlignment = 'top';
            app.lblPitchShift.Position = [133 141 345 22];
            app.lblPitchShift.Text = 'Modify pitch of signal by a specified number of semitones';

            % Create btnBits
            app.btnBits = uibutton(app.DesynchroniseTab, 'push');
            app.btnBits.ButtonPushedFcn = createCallbackFcn(app, @btnBitsButtonPushed, true);
            app.btnBits.Position = [31 78 95 22];
            app.btnBits.Text = 'Bits';

            % Create lblBits
            app.lblBits = uilabel(app.DesynchroniseTab);
            app.lblBits.HorizontalAlignment = 'right';
            app.lblBits.VerticalAlignment = 'top';
            app.lblBits.Position = [132 76 345 22];
            app.lblBits.Text = 'Change the bits per sample of the signal.';

            % Create btnMonoStereo
            app.btnMonoStereo = uibutton(app.DesynchroniseTab, 'push');
            app.btnMonoStereo.ButtonPushedFcn = createCallbackFcn(app, @btnMonoStereoButtonPushed, true);
            app.btnMonoStereo.Position = [31 45 95 22];
            app.btnMonoStereo.Text = 'Mono/Stereo';

            % Create lblMonoStereo
            app.lblMonoStereo = uilabel(app.DesynchroniseTab);
            app.lblMonoStereo.HorizontalAlignment = 'right';
            app.lblMonoStereo.VerticalAlignment = 'top';
            app.lblMonoStereo.Position = [132 43 345 22];
            app.lblMonoStereo.Text = 'Convert between stereo and mono signal';

            % Create btnM4A
            app.btnM4A = uibutton(app.DesynchroniseTab, 'push');
            app.btnM4A.ButtonPushedFcn = createCallbackFcn(app, @btnM4AButtonPushed, true);
            app.btnM4A.Position = [31 13 95 22];
            app.btnM4A.Text = 'Compress';

            % Create lblMonoStereo_2
            app.lblMonoStereo_2 = uilabel(app.DesynchroniseTab);
            app.lblMonoStereo_2.HorizontalAlignment = 'right';
            app.lblMonoStereo_2.VerticalAlignment = 'top';
            app.lblMonoStereo_2.Position = [133 12 345 22];
            app.lblMonoStereo_2.Text = 'Compress wav to .m4a format.';

            % Create lblFs
            app.lblFs = uilabel(app.AudioWatermarkEvaluationToolkitUIFigure);
            app.lblFs.VerticalAlignment = 'top';
            app.lblFs.FontWeight = 'bold';
            app.lblFs.Position = [33 198 82 15];
            app.lblFs.Text = 'Sample Rate:';

            % Create lblFsValue
            app.lblFsValue = uilabel(app.AudioWatermarkEvaluationToolkitUIFigure);
            app.lblFsValue.HorizontalAlignment = 'right';
            app.lblFsValue.Position = [123 198 210 15];
            app.lblFsValue.Text = '';

            % Create lblChannels
            app.lblChannels = uilabel(app.AudioWatermarkEvaluationToolkitUIFigure);
            app.lblChannels.VerticalAlignment = 'top';
            app.lblChannels.FontWeight = 'bold';
            app.lblChannels.Position = [33 218 62 15];
            app.lblChannels.Text = 'Channels:';

            % Create lblChannelsValue
            app.lblChannelsValue = uilabel(app.AudioWatermarkEvaluationToolkitUIFigure);
            app.lblChannelsValue.HorizontalAlignment = 'right';
            app.lblChannelsValue.Position = [123 218 210 15];
            app.lblChannelsValue.Text = '';

            % Create lblDuration
            app.lblDuration = uilabel(app.AudioWatermarkEvaluationToolkitUIFigure);
            app.lblDuration.VerticalAlignment = 'top';
            app.lblDuration.FontWeight = 'bold';
            app.lblDuration.Position = [33 238 58 15];
            app.lblDuration.Text = 'Duration:';

            % Create lblDurationValue
            app.lblDurationValue = uilabel(app.AudioWatermarkEvaluationToolkitUIFigure);
            app.lblDurationValue.HorizontalAlignment = 'right';
            app.lblDurationValue.Position = [123 238 210 15];
            app.lblDurationValue.Text = '';

            % Create lblBitsPerSample
            app.lblBitsPerSample = uilabel(app.AudioWatermarkEvaluationToolkitUIFigure);
            app.lblBitsPerSample.VerticalAlignment = 'top';
            app.lblBitsPerSample.FontWeight = 'bold';
            app.lblBitsPerSample.Position = [33 171 100 22];
            app.lblBitsPerSample.Text = 'Bits Per Sample:';

            % Create lblBitsPerSampleValue
            app.lblBitsPerSampleValue = uilabel(app.AudioWatermarkEvaluationToolkitUIFigure);
            app.lblBitsPerSampleValue.HorizontalAlignment = 'right';
            app.lblBitsPerSampleValue.Position = [123 178 210 15];
            app.lblBitsPerSampleValue.Text = '';

            % Create lblCurrentAudio
            app.lblCurrentAudio = uilabel(app.AudioWatermarkEvaluationToolkitUIFigure);
            app.lblCurrentAudio.HorizontalAlignment = 'center';
            app.lblCurrentAudio.FontWeight = 'bold';
            app.lblCurrentAudio.Position = [130 298 112 15];
            app.lblCurrentAudio.Text = 'Current Audio File:';

            % Create lblName
            app.lblName = uilabel(app.AudioWatermarkEvaluationToolkitUIFigure);
            app.lblName.HorizontalAlignment = 'center';
            app.lblName.FontSize = 10;
            app.lblName.Position = [392 15 115 15];
            app.lblName.Text = '© Henry Hathaway 2020';

            % Show the figure after all components are created
            app.AudioWatermarkEvaluationToolkitUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = WatermarkEvaluationToolkit_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.AudioWatermarkEvaluationToolkitUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.AudioWatermarkEvaluationToolkitUIFigure)
        end
    end
end