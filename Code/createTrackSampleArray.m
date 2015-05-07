 function [x, samplesPerBeatDiv] = createTrackSampleArray(num,den,bpm,measures)
    % Calculates and returns an array of samples equal to the length of the
    % measure, as well as how many samples per beat division.
    fs = 48000;
    beatDiv = 16;
    
    % number of samples per minute
    samplesPerMin = fs*60;

    % number of samples per division 
    samplesPerBeatDiv = round(samplesPerMin/(bpm*beatDiv));

    % calculate the number of divisions in the array
    numDiv = 1:den/beatDiv:(num+1-den/beatDiv);

    len = samplesPerBeatDiv*length(numDiv)*measures;
    x = zeros(1,len);
disp(len)

    end