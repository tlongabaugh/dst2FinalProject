function y = create808(soundType,fs)
% Function creates 808 kick, snare, or hi hat sound based on user
% specification in the GUI

if strcmp(soundType,'808 Snare') == 1
    % Generate the snare sound with 2 noise signals and adsr envelope
    disp('snare');
    % create white noise and adsr envelopes
    noise = rand(1,fs).*2 - 1;
    lowAdsr = [linspace(0, 1, 0.001*fs) linspace(1, 0, 0.049*fs)...
        linspace(0,0,.95*fs)];
    bandAdsr = [linspace(0, 1, 0.001*fs) linspace(1, 0, 0.089*fs)...
        linspace(0,0,.91*fs)];
    
    % create lowpass filter
    wnLow = 400/(fs/2);
    [bLow,aLow] = butter(6,wnLow,'low');
    
    % create bandpass filter
    wnBand = [2000 9000]/(fs/2);
    [bBand,aBand] = butter(12,wnBand,'bandpass');
    
    % filter the noise and apply envelope
    snareLow = filter(bLow,aLow,noise).*lowAdsr;
    snareHigh = filter(bBand,aBand,noise).*bandAdsr;
    y = (snareLow+snareHigh)/2;
    
elseif strcmp(soundType,'808 Kick') == 1
    % Generate the kick sound using noise and sine with adsr envelope
    disp('kick');
    % Make sine wave, noise for kick, adsr envelopes
    sine = sin(2*pi*60*(1:fs)/fs);
    impulse = linspace(1,1,1*fs);
    sineAdsr = [linspace(0, 1, 0.01*fs) linspace(1, 1, 0.39*fs)...
        linspace(1,0,.4*fs) linspace(0,0,.2*fs)];
    impulseAdsr = [linspace(1, 1, 0.01*fs) linspace(1, 0, 0.01*fs)...
        linspace(0,0,.98*fs)];
    
    % create lowpass filter
    wn = 700/(fs/2);    % bandpass filter
    [b,a] = butter(6,wn,'low');
    
    % apply adsr envelopes
    sine = sine.*sineAdsr;
    impulse = (filter(b,a,impulse).*impulseAdsr)/2;
    y = (sine+impulse)/2;
    
else % Hi-Hat sound
    % Generate the Hi-Hat sound with 6 square waves and adsr envelope
    disp('hi-hat');
    % Make square waves and sum together
    square1 = square(2*pi*421*(1:fs)/fs);
    square2 = square(2*pi*562*(1:fs)/fs);
    square3 = square(2*pi*660*(1:fs)/fs);
    square4 = square(2*pi*400*(1:fs)/fs);
    square5 = square(2*pi*473*(1:fs)/fs);
    square6 = square(2*pi*263*(1:fs)/fs);
    hat =(square1+square2+square3+square4+square5+square6)/6;
    
    % create bandpass filter
    wnBand = [8000 14000]/(fs/2);
    [bBand,aBand] = butter(3,wnBand,'bandpass');
    
    % create highpass filter
    wnHi = 500/(fs/2);
    [bHi,aHi] = butter(2,wnHi,'high');
    
    % create adsr envelope
    hatAdsr = [linspace(0, 1, 0.001*fs) linspace(1, .8, 0.01*fs)...
        linspace(1,0,.05*fs) linspace(0,0,.939*fs)];
    
    % Apply filters and envelope
    hat = filter(bBand,aBand,hat);
    hat = filter(bHi,aHi,hat);
    y = hat.*hatAdsr;
    
end

% Normalize output
y = y/max(abs(y));

end