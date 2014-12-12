function Hd = bsfilt(varargin)
%BSFILT Returns a discrete-time filter object.
% Butterworth Bandstop filter designed using FDESIGN.BANDSTOP.

% All frequency values are in Hz.
Fs = 30000;  % Default sampling frequency

% loop over inputs
for k=1:nargin
        if(numel(varargin{k})==1)
            Fs=varargin{k};
        else
            fpass=varargin{k};
            Fpass1 = fpass(1);      % First Passband Frequency
            Fstop1 = fpass(1)+0.5;  % First Stopband Frequency
            Fstop2 = fpass(2)-0.5;  % Second Stopband Frequency
            Fpass2 = fpass(2);      % Second Passband Frequency
            Apass1 = 0.1;             % First Passband Ripple (dB)
            Astop  = 3;            % Stopband Attenuation (dB)
            Apass2 = 0.1;             % Second Passband Ripple (dB)
            match  = 'stopband';    % Band to match exactly
        end
end

% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandstop(Fpass1, Fstop1, Fstop2, Fpass2, Apass1, Astop, Apass2, Fs);
Hd = design(h, 'butter', 'MatchExactly', match);