%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SpikeSort
%   Desc: A short function for spike sorting the semester project data from
%         Artificial Neural Computation EEE Class.
%
%   Authors: Taylor Hearn, Kevin O'Neill, Denise Oswalt
%
%   The purpose of this function is to prepare the data for the selected
%   sorting method.
%
%
%   Params:
%       Fs:         [Hz] The sampling rate of the data to be sorted.
%
%       numUnits:        (optional) The number of unique units in the data.  
%                        Or the number you want to classify. For new data, 
%                        there may be more or less than the ammount you
%                        specify. Specifying a number locks the sorter to 
%                        look for that many units.
%
%       method:    [1-3] Determins which method to use for sorting.
%                     (1): Use PCA + K-means, interate k for best match or
%                          use defined numUnits.
%                       2: ANN.
%
%       verbose:   [0-2] Determine how verbose to be.
%                     (0): Low. Updates user with the current phase of the
%                          program. Only outputs the analyzed data.
%                       1: Debug interface. Detailed outputs on code
%                          progress.
%                       2: Full verbosity. Figures and plots will be
%                          provided as well as the previous levels.
%
%       preProcess [0-3] Determine the ammount of preprocess to use before
%                        spike sorting.
%                       0: None. Use the raw data to spike sort.
%                       1: Filter. Highpass the signal. Use hpFs param to
%                          set the cuttoff frequency. Default is 250 Hz.
%                       2: Remove line noise and filter. Uses detrend() and
%                          the Chronux toolbox's rmlinenoise() to remove
%                          offset and 60Hz signals. Afterwards filter.
%                     (3): Remove line noise, auto-CAR, filter. Remove
%                          line noise/detrend, common average reference,
%                          filter.
%
%       hpFs        [Hz] The cuttoff frequency for a 4th order elliptic 
%                        high-pass filter.
%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = SpikeSort(Header, params, data)

%% Parse Input
if ~isfield(params, 'Fs');         Fs         = 500; else Fs         = params.Fs; end
if ~isfield(params, 'numSpikes');  numNeuron  =  -1; else numNeuron  = params.numNeuron; end
if ~isfield(params, 'method');     method     =   1; else method     = params.method; end
if ~isfield(params, 'preProcess'); preProcess =   3; else preProcess = params.preProcess; end
if ~isfield(params, 'hpFs');       hpFs       = 250; else hpFs       = params.hpFs; end


%% Preprocess

% Define a time vector. Currently in [seconds]
time = linspace(0, size(data,2)/Fs, size(data,2));
timeLimits = [time(1), time(end)];
timeLabel = 'Time, seconds';

voltageLimits = [-1.1*max(-1*data), 1.1*max(data)];
voltageLabel = ['Voltage, uV'];

switch(preProcess)
    case 0;
        % Do nothing
        preProcessTitle = 'Raw data';
    case 1;
        preProcessTitle = ['High-pass filter at ', num2str(hpFs), ' Hz'];
    case 2;
        preProcessTitle = ['Detrended, High-pass filter at ', num2str(hpFs), ' Hz'];
    case 3;
        preProcessTitle = ['Detrended, Auto-CAR, High-pass filter at ', num2str(hpFs), ' Hz'];
    otherwise
end

% Plot sample of data

% subplot?
% sampleIdx?

plot(time, data, 'k')
xlim(timeLimits)
ylim(voltageLimits)

xlabel(timeLabel, 'FontSize', 14)
ylabel(voltageLabel, 'FontSize', 14)
title(preProcessTitle, 'FontSize', 16)

figWidth  = 5;
figHeight = 3;
set(gcf, 'Position', [2, 2, figWidth, figHeight])



%% Find Spikes

% Look at Neural Engineering Code

if true
    
    sigma = 0:0.05:6;
    % find spikes above sigma and plot numSpikes vs sigma
    
    % surf (or whatever) plot the ISI for each sigma.
end

% Plot spikes. Look at SpikeWaveform.
% Use 'spaghetti' and 'patch-confidence' plots.
    

%% Sort Spikes

switch(method)
    case 0;
        % Plot PCA + cluster centers as well
    case 1;
    case 2;
    otherwise
end

for u = 1:numUnits
    % Plot ISI for each Unit
    % Plot spike waveform for each unit
        % spaghetti and patch-confidence
end % END FOR

end % END FUNCTION

% EOF