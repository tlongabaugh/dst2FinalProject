function x = loadAudioFile(filePath, globalFs)
% Loads an audio file, converts it to mono signal at the global sampling
% rate, and then returns it

% read in an audio file, make mono if necessary
[x,fs] = audioread(filePath);
[~, channels] = size(x);
if channels > 1               % more than 1 channel
    x = x(:,1);               % just use first channel
end

% change to global sample rate if necessary
if fs ~= globalFs
    % get ratio and resample
    [p, q] = rat(48000/44100);
    x = resample(x,p,q);
end

end