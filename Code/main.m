function [] = main()
% Main script for MATLAB multi-tempi, multi-time signature drum machine
% by: Tom Longabaugh
% DST 2

% Description: A 4 track, multi-time signature, multi-tempo, multi-timbral
% drum machine. Dynamic filters are also available, where the center
% frequency for the filter of choice can be drawn along the drum machine
% grid to change the filter's response over time.

% Global sampling rate (pcm samples will be converted to this)
fs = 48000;
% Beat division
beatDiv = 16;
% Number of measures
numMeasures = 1;

% Declare sample names and sound array names for each of the 4 tracks
soundSamp1 = [];
soundSamp2 = [];
soundSamp3 = [];
soundSamp4 = [];
soundArray1 = [];
soundArray2 = [];
soundArray3 = [];
soundArray4 = [];
sampPerBeatDiv1 = [];
sampPerBeatDiv2 = [];
sampPerBeatDiv3 = [];
sampPerBeatDiv4 = [];

% Tempos
tempo1 = 120;
tempo2 = 120;
tempo3 = 120;
tempo4 = 120;

% Meter values
num1 = 4;
den1 = 4;
num2 = 4;
den2 = 4;
num3 = 4;
den3 = 4;
num4 = 4;
den4 = 4;

% Dots for user specification of sound placement on grid
dots1 = [];
dots2 = [];
dots3 = [];
dots4 = [];

% filename/pathname for loading audio files
filename = '';
pathname = '';
audioSample1 = [];
audioSample2 = [];
audioSample3 = [];
audioSample4 = [];

% Create Player with arbitrary output array (output is configured later
% based on the drum machine grid)
output = zeros(1,10);
player = audioplayer(output,fs);


% CREATE THE GUI
%-----------------------------------------------------------------
close all;

% Create the window, center it
guiWindow = figure('Visible', 'off', 'position', [0 0 800 600]);
movegui(guiWindow,'center');

% Create title for GUI
titleText = uicontrol('style', 'text', 'position', [0 0 270 50], ...
    'FontSize', 20, 'String', {'Polyrhythmic Drum Machine',...
    'by Tom Longabaugh'});

% Track labels
track1Text = uicontrol('style', 'text', 'position', [10 550 50 15], ...
    'FontSize', 14, 'String', 'Track 1');
track2Text = uicontrol('style', 'text', 'position', [10 450 50 15], ...
    'FontSize', 14, 'String', 'Track 2');
track3Text = uicontrol('style', 'text', 'position', [10 350 50 15], ...
    'FontSize', 14, 'String', 'Track 3');
track4Text = uicontrol('style', 'text', 'position', [10 250 50 15], ...
    'FontSize', 14, 'String', 'Track 4');

% Create Dropdown menu for synthesis types
t1synthPopup = uicontrol('tag', 't1Synth', 'style', 'popup', 'String',...
    {'808','FM','Sample Load'}, 'position', [10 520 130 20],'callback', @cb_synthTypePopup);
t2synthPopup = uicontrol('tag', 't2Synth', 'style', 'popup', 'String',...
    {'808','FM','Sample Load'}, 'position', [10 420 130 20],'callback', @cb_synthTypePopup);
t3synthPopup = uicontrol('tag', 't3Synth', 'style', 'popup', 'String',...
    {'808','FM','Sample Load'}, 'position', [10 320 130 20],'callback', @cb_synthTypePopup);
t4synthPopup = uicontrol('tag', 't4Synth', 'style', 'popup', 'String',...
    {'808','FM','Sample Load'}, 'position', [10 220 130 20],'callback', @cb_synthTypePopup);

% Create Dropdown menu for sound types
t1soundPopup = uicontrol('tag', 't1Sound', 'style', 'popup', 'String',...
    'Slct Synth Type', 'position', [10 500 130 20],'callback',@cb_soundTypePopup);
t2soundPopup = uicontrol('tag', 't2Sound', 'style', 'popup', 'String',...
    'Slct Synth Type','position', [10 400 130 20],'callback',@cb_soundTypePopup);
t3soundPopup = uicontrol('tag', 't3Sound', 'style', 'popup', 'String',...
    'Slct Synth Type','position', [10 300 130 20],'callback',@cb_soundTypePopup);
t4soundPopup = uicontrol('tag', 't4Sound', 'style', 'popup', 'String',...
    'Slct Synth Typed','position', [10 200 130 20],'callback',@cb_soundTypePopup);

% Create dropdown menus for meter
t1Meter = uicontrol('tag','t1Meter','style','popup','String',{'4/4','6/8',...
    '7/4','9/8'},'position',[10 477 70 20],'callback',@cb_meter);
t2Meter = uicontrol('tag','t2Meter','style','popup','String',{'4/4','6/8',...
    '7/4','9/8'},'position',[10 377 70 20],'callback',@cb_meter);
t3Meter = uicontrol('tag','t3Meter','style','popup','String',{'4/4','6/8',...
    '7/4','9/8'},'position',[10 277 70 20],'callback',@cb_meter);
t4Meter = uicontrol('tag','t4Meter','style','popup','String',{'4/4','6/8',...
    '7/4','9/8'},'position',[10 177 70 20],'callback',@cb_meter);

% Create tempo sliders
t1Tempo = uicontrol('tag', 't1Tempo', 'Style', 'slider','Min',60,'Max',140,...
    'Value',120,'sliderstep',[1/80 1/80],'Position', [80 480 70 15],'Callback', @cb_tempo); 
t2Tempo = uicontrol('tag', 't2Tempo', 'Style', 'slider','Min',60,'Max',140,...
    'Value',120,'sliderstep',[1/80 1/80],'Position', [80 380 70 15],'Callback', @cb_tempo); 
t3Tempo = uicontrol('tag', 't3Tempo', 'Style', 'slider','Min',60,'Max',140,...
    'Value',120,'sliderstep',[1/80 1/80],'Position', [80 280 70 15],'Callback', @cb_tempo); 
t4Tempo = uicontrol('tag', 't4Tempo', 'Style', 'slider','Min',60,'Max',140,...
    'Value',120,'sliderstep',[1/80 1/80],'Position', [80 180 70 15],'Callback', @cb_tempo); 

% Create axis for the drum grid, set mouseDown callback for them
track1axes = createAxes([175, 485, 600, 70],num1,den1,1);
set(track1axes, 'ButtonDownFcn', @cb_mouseDown);
plotSequence(1);
track2axes = createAxes([175, 385, 600, 70],num2,den2,2);
set(track2axes, 'ButtonDownFcn', @cb_mouseDown);
plotSequence(2);
track3axes = createAxes([175, 285, 600, 70],num3,den3,3);
set(track3axes, 'ButtonDownFcn', @cb_mouseDown);
plotSequence(3);
track4axes = createAxes([175, 185, 600, 70],num4,den4,4);
set(track4axes, 'ButtonDownFcn', @cb_mouseDown);
plotSequence(4);

% Play Button
playButton = uicontrol('style', 'pushbutton', 'position', [50 100 100 25],...
    'String','Play','callback',@cb_playButton);

stopButton = uicontrol('style', 'pushbutton', 'position', [160 100 100 25],...
    'String','Stop','enable','off','callback',@cb_stopButton);

% Loop amount of time dropdown
loopAmt = 1;
loopText = uicontrol('style', 'text', 'position', [50 70 100 15], ...
    'FontSize', 14, 'String', 'Loop Length'); 
loopPopup = uicontrol('tag','loop','style','popup','position',[160 63 100 25],...
    'String',{'1','2','4'},'callback', @cb_loopPopup);

% Run synthesis menu callback functions to initialize sounds
cb_synthTypePopup(t1synthPopup);
cb_synthTypePopup(t2synthPopup);
cb_synthTypePopup(t3synthPopup);
cb_synthTypePopup(t4synthPopup);

% Make the GUI window visible now that we have set it up
set(guiWindow, 'Visible', 'on');



% GUI CALLBACK FUNCTIONS
%-------------------------------------------------------------
    function cb_synthTypePopup(object, event)
        % Reads the type of sound generation the user selects, creates
        % appropriate menu options for sounds of that synthesis type
        
        synthType = get(object,'value');
        soundPopupStr = setSoundTypePopup(synthType);
        
        if isequal(get(object,'tag'), 't1Synth')
            % set the t1 sound option menu
            set(t1soundPopup,'string',soundPopupStr);
            cb_soundTypePopup(t1soundPopup);
        elseif isequal(get(object,'tag'), 't2Synth')
            % set the t2 sound option menu
            set(t2soundPopup,'string',soundPopupStr);
            cb_soundTypePopup(t2soundPopup);
        elseif isequal(get(object,'tag'), 't3Synth')
            % set the t3 sound option menu
            set(t3soundPopup,'string',soundPopupStr);
            cb_soundTypePopup(t3soundPopup);
        else % t4Synth
            % set the t4 sound option menu
            set(t4soundPopup,'string',soundPopupStr);
            cb_soundTypePopup(t4soundPopup);
        end
    end

    function cb_soundTypePopup(object, event)
        % Based on the synthesis and sound type, create the sound
        
        str = get(object,'string');
        val = get(object,'value');
        soundStr = str{val};
        if isequal(soundStr,'Audio File')
            % load an audio file
            [filename,pathname] = uigetfile({'*.wav'},'Load Wav File');
            % if user hits "ok" then load the file
            if isequal(filename,0) == 0
                temp = loadAudioFile([pathname filename],fs);
            else % user hit cancel, so just return array of zeros
                temp = zeros(1,fs);
            end
            
            if isequal(get(object, 'tag'),'t1Sound')
                audioSample1 = temp;
            elseif isequal(get(object, 'tag'),'t2Sound')
                audioSample2 = temp;
            elseif isequal(get(object, 'tag'),'t3Sound')
                audioSample3 = temp;
            else
                audioSample4 = temp;
            end
        end
                
    end

    function cb_meter(object, event)
        % callback for when the user changes the meter of a track
        
        str = get(object,'string');
        val = get(object,'value');
        meterStr = str{val};
        
        % get the numerator and denominator according to user's choice
        if isequal(meterStr,'4/4')
            num = 4;
            den = 4;
        elseif isequal(meterStr,'6/8')
            num = 6;
            den = 8;
        elseif isequal(meterStr,'7/4')
            num = 7;
            den = 4;
        else
            num = 9;
            den = 8;
        end
        
        % set the appropriate track meter num and den, update the axes
        if isequal(get(object, 'tag'),'t1Meter')
            num1 = num;
            den1 = den;
            % Delete and replace the axes
            delete(track1axes);
            track1axes = createAxes([175, 485, 600, 70],num1,den1,1);
            set(track1axes, 'ButtonDownFcn', @cb_mouseDown);
            plotSequence(1);
        elseif isequal(get(object, 'tag'),'t2Meter')
            num2 = num;
            den2 = den;
            % Delete and replace the axes
            delete(track2axes);
            track2axes = createAxes([175, 385, 600, 70],num2,den2,2);
            set(track2axes, 'ButtonDownFcn', @cb_mouseDown);
            plotSequence(2);
        elseif isequal(get(object, 'tag'),'t3Meter')
            num3 = num;
            den3 = den;
            % Delete and replace the axes
            delete(track3axes);
            track3axes = createAxes([175, 285, 600, 70],num3,den3,3);
            set(track3axes, 'ButtonDownFcn', @cb_mouseDown);
            plotSequence(3);
        else % 4
            num4 = num;
            den4 = den;
            % Delete and replace the axes
            delete(track4axes);
            track4axes = createAxes([175, 185, 600, 70],num4,den4,4);
            set(track4axes, 'ButtonDownFcn', @cb_mouseDown);
            plotSequence(4);
        end 
    end

    function cb_tempo(object, event)
        % callback for when the user changes the tempo of a track
        
        newTempo = round(get(object,'value'));
        disp(newTempo);
        
        % recalculate the length of the track array, and add the sounds
        % into it according to the new tempo
        if isequal(get(object, 'tag'),'t1Tempo')
            tempo1 = newTempo;
        elseif isequal(get(object, 'tag'),'t2Tempo')
            tempo2 = newTempo;
        elseif isequal(get(object, 'tag'),'t3Tempo')
            tempo3 = newTempo;
        else % 4
            tempo4 = newTempo;
        end 
    end

    function cb_mouseDown(object, event)
        % callback for when an axes object is clicked. gets the x and y
        % coordinates, and assigns velocity to the closest beat division
        
        % get the beat and velocity values of the mouse click
        currPoint = get(object,'Currentpoint');
        
        % Set the velocity for the appropriate track based on the mouse
        % click position
        if isequal(get(object, 'tag'),'axes1')
            setVelocity(1,currPoint);
        elseif isequal(get(object, 'tag'),'axes2')
            setVelocity(2,currPoint);
        elseif isequal(get(object, 'tag'),'axes3')
            setVelocity(3,currPoint);
        else % axes4
            setVelocity(4,currPoint);
        end 
    end

    function cb_playButton(object, event)
        % callback function for playButton, sums the audio arrays together
        % and plays them using audioplay

        % enable stop button, disable play button
        set(playButton,'enable','off');
        set(stopButton,'enable','on');
        
        % sum all the arrays together:
        sequenceSounds();
        
        % find the longest array, pad them all to that length
        longest = max([length(soundArray1) length(soundArray2)...
            length(soundArray3) length(soundArray4)]);
        soundArray1temp = padarray(soundArray1,[0 longest-length(soundArray1)],'post');
        soundArray2temp = padarray(soundArray2,[0 longest-length(soundArray2)],'post');
        soundArray3temp = padarray(soundArray3,[0 longest-length(soundArray3)],'post');
        soundArray4temp = padarray(soundArray4,[0 longest-length(soundArray4)],'post');
        
        % Create the output
        output = (soundArray1temp+soundArray2temp+soundArray3temp+soundArray4temp);
        figure(2);plot(output);
        
        % Play the audio until the stop button is hit
        player = audioplayer(output,fs);
        player.StopFcn = @audioplayer_stop;
        play(player);
        
    end

    function cb_stopButton(object, event)
        % callback function for playButton, sums the audio arrays together
        % and plays them using audioplay
        
        % enable play button, disable stop button
        set(stopButton,'enable','off');
        set(playButton,'enable','on');
        
        % stop audio
        stop(player);
    end

    function cb_loopPopup(object, event)
        % callback funciton for loop popup, which tells how many times the
        % audio should be looped
        
        % get the value
        val = get(object,'value');
        loopAmt = val;
    end


% HELPER FUNCTIONS
% -------------------------------------------------

    function y = makeSound(soundName,trackNum)
        % Creates the sound based on the string name passed in
        
        switch soundName
            case {'808 Kick','808 Snare','808 Hi-hat'}
                % create 808 sound
                y = create808(soundName,fs);
            case {'Trombone','Sitar','Bass Clarinet'}
                % FM synthesis
                y = createFM(soundName,fs);
            otherwise % PCM, baby!
                % load an audio file
                switch trackNum
                    case 1
                        y = audioSample1;
                    case 2
                        y = audioSample2;
                    case 3
                        y = audioSample3;
                    case 4
                        y = audioSample4;
                end
        end
    end
    
    function string = setSoundTypePopup(synthType)
        % Sets the synthType popup menu
        
        if synthType == 1
            % set the 808 sound option menu
            string = {'808 Kick', '808 Snare', '808 Hi-hat'};
        elseif synthType == 2
            % set the FM sound option menu
            string = {'Trombone', 'Sitar', 'Bass Clarinet'};
        else
            % User is opening an audio file, so return blank string
            string = {'Audio File'};
        end
    end

    function axesHandle = createAxes(position,num,den,trackNum)
        % Creates an axes at the given position with the time signature
        % numerator and denominator
        
        % create the axes at the given position
        axesHandle = axes('units','pixels','position', position,...
            'nextplot','replaceChildren','yticklabelmode','manual');
        
        % label axis (Note: this math only works if the beat division is
        % greater then the meter denominator, as is expected for this
        % project)
        xTickEnd = num+1-den/beatDiv;
        xTicks = 1:den/beatDiv:xTickEnd;
        
        % Create arrays of dot positions and velocitys based on the time
        % signature and division. set axes id tag used by cb_mouseDown
        switch trackNum
            case 1
                dots1.position = xTicks;
                dots1.velocity = zeros(1,length(xTicks));
                set(axesHandle,'tag','axes1');
            case 2
                dots2.position = xTicks;
                dots2.velocity = zeros(1,length(xTicks));
                set(axesHandle,'tag','axes2');
            case 3
                dots3.position = xTicks;
                dots3.velocity = zeros(1,length(xTicks));
                set(axesHandle,'tag','axes3');
            case 4
                dots4.position = xTicks;
                dots4.velocity = zeros(1,length(xTicks));
                set(axesHandle,'tag','axes4');
        end
        
        % turn on the grid to the correct time signature
        set(axesHandle,'ylim',[0 1],'yticklabel',[0 1],'ytick',[0 1],...
            'xlim',[1 xTickEnd+den/beatDiv],'xtick',xTicks);
        grid on; 
    end

    function [] = setVelocity(trackNum,currPoint)
        % sets the velocity for the specified tracknumber and mouse
        % position
        
        % get velocity from mouse pointer, set it to within bounds
        velocity = currPoint(1,2);
        if velocity > 1
            velocity = 1;
        elseif velocity < 0
            velocity = 0;
        end
        switch trackNum
            case 1
                % rounds mouse x pos to beat grid
                quant = dots1.position(2)-dots1.position(1);
                beat = round(currPoint(1,1)*1/quant)/(1/quant);
                [~,idx] = max(beat == dots1.position);
                if dots1.velocity(idx) > 0
                    % turn off note (0 velocity)
                    dots1.velocity(idx) = 0;
                else
                    % set note to current velocity
                    dots1.velocity(idx) = velocity;
                end
                % Update the sequence in the gui
                plotSequence(1);
            case 2
                % rounds mouse x pos to beat grid
                quant = dots2.position(2)-dots2.position(1);
                beat = round(currPoint(1,1)*1/quant)/(1/quant);
                [~,idx] = max(beat == dots2.position);
                if dots2.velocity(idx) > 0
                    % turn off note (0 velocity)
                    dots2.velocity(idx) = 0;
                else
                    % set note to current velocity
                    dots2.velocity(idx) = velocity;
                end
                % Update the sequence in the gui
                plotSequence(2);
            case 3
                % rounds mouse x pos to beat grid
                quant = dots3.position(2)-dots3.position(1);
                beat = round(currPoint(1,1)*1/quant)/(1/quant);
                [~,idx] = max(beat == dots3.position);
                if dots3.velocity(idx) > 0
                    % turn off note (0 velocity)
                    dots3.velocity(idx) = 0;
                else
                    % set note to current velocity
                    dots3.velocity(idx) = velocity;
                end
                % Update the sequence in the gui
                plotSequence(3);
            case 4
                % rounds mouse x pos to beat grid
                quant = dots4.position(2)-dots4.position(1);
                beat = round(currPoint(1,1)*1/quant)/(1/quant);
                [~,idx] = max(beat == dots4.position);
                if dots4.velocity(idx) > 0
                    % turn off note (0 velocity)
                    dots4.velocity(idx) = 0;
                else
                    % set note to current velocity
                    dots4.velocity(idx) = velocity;
                end
                % Update the sequence in the gui
                plotSequence(4);
        end
        
    end

    function [] = addSoundToArray(sound,trackNum,soundIdx)
        % adds the track's specified sound to the corresponding track array
        switch trackNum
            case 1
                % get start position in samples
                sampPosition = soundIdx*sampPerBeatDiv1-(sampPerBeatDiv1-1);
                
                % Add this into the whole sample array for the track
                i=1;
                while i <= length(sound)
                    soundArray1(sampPosition) = dots1.velocity(soundIdx)...
                        *soundSamp1(i);
                    
                    % Don't out of bounds if soundSamp is longer than end
                    % of array
                    if sampPosition >= length(soundArray1)
                        break;
                    end
                    i = i+1;
                    sampPosition = sampPosition+1;
                end
            case 2
                % get start position in samples
                sampPosition = soundIdx*sampPerBeatDiv2-(sampPerBeatDiv2-1);
                
                % Add this into the whole sample array for the track
                i=1;
                while i <= length(sound)
                    soundArray2(sampPosition) = dots2.velocity(soundIdx)...
                        *soundSamp2(i);
                    
                    % Don't out of bounds if soundSamp is longer than end
                    % of array
                    if sampPosition >= length(soundArray2)
                        break;
                    end
                    i = i+1;
                    sampPosition = sampPosition+1;
                end
            case 3
                % get start position in samples
                sampPosition = soundIdx*sampPerBeatDiv3-(sampPerBeatDiv3-1);
                
                % Add this into the whole sample array for the track
                i=1;
                while i <= length(sound)
                    soundArray3(sampPosition) = dots3.velocity(soundIdx)...
                        *soundSamp3(i);
                    
                    % Don't out of bounds if soundSamp is longer than end
                    % of array
                    if sampPosition >= length(soundArray3)
                        break;
                    end
                    i = i+1;
                    sampPosition = sampPosition+1;
                end
            case 4
                % get start position in samples
                sampPosition = soundIdx*sampPerBeatDiv4-(sampPerBeatDiv4-1);
                
                % Add this into the whole sample array for the track
                i=1;
                while i <= length(sound)
                    soundArray4(sampPosition) = dots4.velocity(soundIdx)...
                        *soundSamp4(i);
                    
                    % Don't out of bounds if soundSamp is longer than end
                    % of array
                    if sampPosition >= length(soundArray4)
                        break;
                    end
                    i = i+1;
                    sampPosition = sampPosition+1;
                end
        end
    end

    function [] = sequenceSounds()
        % Sequences the appropriate sounds into the corresponding track's
        % output array
        
        disp('Constructing sound output');
        
        % Construct the output arrays
        [soundArray1,sampPerBeatDiv1] = createTrackSampleArray(num1,den1,tempo1,numMeasures);
        [soundArray2,sampPerBeatDiv2] = createTrackSampleArray(num2,den2,tempo2,numMeasures);
        [soundArray3,sampPerBeatDiv3] = createTrackSampleArray(num3,den3,tempo3,numMeasures);
        [soundArray4,sampPerBeatDiv4] = createTrackSampleArray(num4,den4,tempo4,numMeasures);
        
        % create the t1 Sounds, add them to the track array
        str = get(t1soundPopup,'string');
        val = get(t1soundPopup,'value');
        soundSamp1 = makeSound(str{val},1);
        for i=1:length(dots1.position)
            if dots1.velocity(i) ~= 0
                addSoundToArray(soundSamp1,1,i);
            end
        end

        % create the t2 Sounds, add them to the track array
        str = get(t2soundPopup,'string');
        val = get(t2soundPopup,'value');
        soundSamp2 = makeSound(str{val},2);
        for i=1:length(dots2.position)
            if dots2.velocity(i) ~= 0
                addSoundToArray(soundSamp2,2,i);
            end
        end
            
        % create the t3 Sounds, add them to the track array
        str = get(t3soundPopup,'string');
        val = get(t3soundPopup,'value');
        soundSamp3 = makeSound(str{val},3);
        for i=1:length(dots3.position)
            if dots3.velocity(i) ~= 0
                addSoundToArray(soundSamp3,3,i);
            end
        end
        
        % create the t4 Sounds, add them to the track array
        str = get(t4soundPopup,'string');
        val = get(t4soundPopup,'value');
        soundSamp4 = makeSound(str{val},4);
        for i=1:length(dots4.position)
            if dots4.velocity(i) ~= 0
                addSoundToArray(soundSamp4,4,i);
            end
        end
    end

    function [] = plotSequence(trackNum)
        % Plots the dots on to the specified axis, mimicking a drum grid.
        
        % plot the dots based on inputted track number
        switch trackNum
            case 1
                for i=1:(length(dots1.position)-1)
                    plot(track1axes,dots1.position,dots1.velocity, 'o');
                end
            case 2
                for i=1:(length(dots2.position)-1)
                    plot(track2axes,dots2.position,dots2.velocity, 'o');
                end
            case 3
                for i=1:(length(dots3.position)-1)
                    plot(track3axes,dots3.position,dots3.velocity, 'o');
                end
            case 4
                for i=1:(length(dots4.position)-1)
                    plot(track4axes,dots4.position,dots4.velocity, 'o');
                end
        end
    end

    function [x, samplesPerBeatDiv] = createTrackSampleArray(num,den,bpm,measures)
        % Calculates and returns an array of samples equal to the length of 
        % the measure, as well as how many samples per beat division.

        % samples per beat
        samplesPerBeat = (60/bpm)*fs;
        
        % samples per beat division
        samplesPerBeatDiv = round(samplesPerBeat*den/beatDiv*4/den);

        % calculate the number of divisions in the array
        numDiv = 1:den/beatDiv:(num+1-den/beatDiv);

        % set x to that length
        len = samplesPerBeatDiv*length(numDiv)*measures;
        x = zeros(1,len);
    end

    function audioplayer_stop(obj,event)
        stop(obj);
        set(stopButton,'enable','off');
        set(playButton,'enable','on');
    end

end