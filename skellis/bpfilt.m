function Hd = bpfilt(varargin)
%BPFILT Returns a discrete-time filter object.
% Chebyshev Type II Bandpass filter designed using FDESIGN.BANDPASS.

% All frequency values are in Hz.
Fs = 30000;  % Default sampling frequency

% loop over inputs
for k=1:nargin
    if(~ischar(varargin{k}))
        if(numel(varargin{k})==1)
            Fs=varargin{k};
        else
            fpass=varargin{k};
            Fstop1 = fpass(1)-1;      % First Stopband Frequency
            Fpass1 = fpass(1);        % First Passband Frequency
            Fpass2 = fpass(2);        % Second Passband Frequency
            Fstop2 = fpass(2)+1;      % Second Stopband Frequency
            Astop1 = 60;              % First Stopband Attenuation (dB)
            Apass  = 1;               % Passband Ripple (dB)
            Astop2 = 80;              % Second Stopband Attenuation (dB)
            match  = 'stopband';      % Band to match exactly
        end
    else
        switch(varargin{k})
            case 'hi'
                Fstop1 = 79;          % First Stopband Frequency
                Fpass1 = 80;          % First Passband Frequency
                Fpass2 = 200;         % Second Passband Frequency
                Fstop2 = 201;         % Second Stopband Frequency
                Astop1 = 60;          % First Stopband Attenuation (dB)
                Apass  = 1;           % Passband Ripple (dB)
                Astop2 = 80;          % Second Stopband Attenuation (dB)
                match  = 'stopband';  % Band to match exactly
                
            case 'lo'
                Fstop1 = 3;           % First Stopband Frequency
                Fpass1 = 4;           % First Passband Frequency
                Fpass2 = 30;          % Second Passband Frequency
                Fstop2 = 31;          % Second Stopband Frequency
                Astop1 = 60;          % First Stopband Attenuation (dB)
                Apass  = 1;           % Passband Ripple (dB)
                Astop2 = 80;          % Second Stopband Attenuation (dB)
                match  = 'stopband';  % Band to match exactly
                
            case 'alpha'
                Fstop1 = 7;           % First Stopband Frequency
                Fpass1 = 8;           % First Passband Frequency
                Fpass2 = 12;          % Second Passband Frequency
                Fstop2 = 13;          % Second Stopband Frequency
                Astop1 = 60;          % First Stopband Attenuation (dB)
                Apass  = 1;           % Passband Ripple (dB)
                Astop2 = 80;          % Second Stopband Attenuation (dB)
                match  = 'stopband';  % Band to match exactly
                
            case 'beta'
                Fstop1 = 11;          % First Stopband Frequency
                Fpass1 = 12;          % First Passband Frequency
                Fpass2 = 30;          % Second Passband Frequency
                Fstop2 = 31;          % Second Stopband Frequency
                Astop1 = 60;          % First Stopband Attenuation (dB)
                Apass  = 1;           % Passband Ripple (dB)
                Astop2 = 80;          % Second Stopband Attenuation (dB)
                match  = 'stopband';  % Band to match exactly
                
            case 'gamma'
                Fstop1 = 29;          % First Stopband Frequency
                Fpass1 = 30;          % First Passband Frequency
                Fpass2 = 80;          % Second Passband Frequency
                Fstop2 = 81;          % Second Stopband Frequency
                Astop1 = 60;          % First Stopband Attenuation (dB)
                Apass  = 1;           % Passband Ripple (dB)
                Astop2 = 80;          % Second Stopband Attenuation (dB)
                match  = 'stopband';  % Band to match exactly
                
            case 'chi'
                Fstop1 = 79;          % First Stopband Frequency
                Fpass1 = 80;          % First Passband Frequency
                Fpass2 = 150;         % Second Passband Frequency
                Fstop2 = 151;         % Second Stopband Frequency
                Astop1 = 60;          % First Stopband Attenuation (dB)
                Apass  = 1;           % Passband Ripple (dB)
                Astop2 = 80;          % Second Stopband Attenuation (dB)
                match  = 'stopband';  % Band to match exactly
        end
    end
end

% Construct an FDESIGN object and call its CHEBY2 method.
h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, Astop2, Fs);
Hd = design(h, 'cheby2', 'MatchExactly', match);