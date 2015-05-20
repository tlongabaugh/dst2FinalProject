function y = createFM(soundType,fs,freqMult)
% Function creates FM sounds of bass clarinet, trombone, trumpet, bell, guitar
% or sitar based on which one the user has selected in the gui

n = 0:1/fs:1;   % time vector (1 second long)
n = n(1:end-1); % chop it correct length

carrFreq = 1;   % initialize frequencies
modFreq = 1;

% Create envelopes
if strcmp(soundType,'Bass Clarinet') == 1
    % create amplitude envelope
    ampEnv = [linspace(0,1,round(.05*fs)) linspace(1,.5,round(.15*fs)) linspace(.5,.4,round(.5*fs)) linspace(.4,0,round(.3*fs))];
    % create magnitude index envelope
    magEnv = [linspace(0,2,round(.1*fs)) linspace(2,1.5,round(.2*fs)) linspace(1.5,1.4,round(.5*fs)) linspace(1.4,0,round(.2*fs))];
    % frequencies
    carrFreq = 300;
    modFreq = 200;
elseif strcmp(soundType,'Trombone') == 1
    % create amplitude envelope
    ampEnv = [linspace(0,2,round(.01*fs)) linspace(2,0.5,round(.6*fs)) linspace(.5,.4,round(.2*fs)) linspace(.4,0,round(.19*fs))];
    % create magnitude index envelpe
    magEnv = [linspace(0,2,round(.1*fs)) linspace(2,0.5,round(.1*fs)) linspace(.5,.4,round(.5*fs)) linspace(.4,0,round(.3*fs))];
    % frequqncies
    carrFreq = 600;
    modFreq = 300;
elseif strcmp(soundType,'Trumpet') == 1
    % create amplitude envelope
    ampEnv = [linspace(0,2,round(.01*fs)) linspace(2,0.5,round(.6*fs)) linspace(.5,.4,round(.2*fs)) linspace(.4,0,round(.19*fs))];
    % create magnitude index envelpe
    magEnv = [linspace(0,2,round(.01*fs)) linspace(2,0.5,round(.6*fs)) linspace(.5,.4,round(.2*fs)) linspace(.4,0,round(.19*fs))];
    % frequqncies
    carrFreq = 400;
    modFreq = 400;
elseif strcmp(soundType,'Bell') == 1
    % create amplitude envelope
    ampEnv = [linspace(0,2,round(.01*fs)) linspace(2,0.5,round(.6*fs)) linspace(.5,.4,round(.2*fs)) linspace(.4,0,round(.19*fs))];
    % create magnitude index envelpe
    magEnv = [linspace(0,1,round(.01*fs)) linspace(1,0.5,round(.6*fs)) linspace(.5,.4,round(.2*fs)) linspace(.4,0,round(.19*fs))];
    % frequqncies
    carrFreq = 300;
    modFreq = 300*1.618;
elseif strcmp(soundType,'Guitar') == 1
    % create amplitude envelope
    ampEnv = [linspace(0,2,round(.01*fs)) linspace(2,0.5,round(.6*fs)) linspace(.5,.4,round(.2*fs)) linspace(.4,0,round(.19*fs))];
    % create magnitude index envelpe
    magEnv = [linspace(0,.6,round(.01*fs)) linspace(.6,0.5,round(.6*fs)) linspace(.5,.4,round(.2*fs)) linspace(.4,0,round(.19*fs))];
    % frequqncies
    carrFreq = 392;
    modFreq = 196;
else % sitar sound
    % create amplitude envelope
    ampEnv = [linspace(0,2,round(.01*fs)) linspace(2,0.5,round(.6*fs)) linspace(.5,.4,round(.1*fs)) linspace(.4,0,round(.29*fs))];
    % create magnitude index envelpe
    magEnv = [linspace(0,5,round(.1*fs)) linspace(5,4,round(.1*fs)) linspace(4,4,round(.4*fs)) linspace(4,0,round(.4*fs))];
    % frequencies
    carrFreq = 600;
    modFreq = 1000;
end


% synthesize signal
y = ampEnv.*sin(2*pi*n*(carrFreq*freqMult) + magEnv.*sin(2*pi*(modFreq*freqMult)*n));
y = y/max(abs(y))*.5;

end