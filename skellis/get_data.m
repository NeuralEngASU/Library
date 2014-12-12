% Function get_data()
%  Read out neural data from NS* files.  Returns 3-D matrix: 
%    trials X channels X samples
%
%  Input: 
%    NS - use NSX_open to return this struct
%    timestamps - vector of timestamps to read out from
%
%  Optional input (defaults):
%    Fs - downsample to this sampling rate (100)
%    win_size - number of seconds to read in for each trial (2)
%    win_align - align the window to this point (in seconds) (1)
%    chan_list - specify which channels to read in (NS.Channel_ID)
%    padding - data to read out, in seconds, before & after window
%
%  Output:
%    data - trials X channels X samples matrix
%
%  Usage:
%    data = get_data(NS,timestamps);
%
%  Specify optional inputs:
%    data = get_data(NS,timestamps,'Fs',100,'win_size',2);
%

function data = get_data(NS,timestamps,varargin)

% options
Fs         = 1000;     % downsample to this sampling rate
win_size   = 2;  % num seconds to read out per trial
win_align  = 1; % align the window to this point (in seconds)
chan_list  = NS.Channel_ID; % read out these channels
padding    = 0; % seconds to pad (e.g. for filtering)

% user specified options
if(~isempty(varargin))
    for k=1:2:length(varargin)
        switch(varargin{k})
            case 'Fs'
                Fs = varargin{k+1};
            case 'win_size'
                win_size = varargin{k+1};
            case 'win_align'
                win_align = varargin{k+1};
            case 'chan_list'
                chan_list = varargin{k+1};
            case 'padding'
                padding = varargin{k+1};
            otherwise
                disp(['Input option ' varargin{k} ' not supported']);
        end
    end
end

% update if padding
win_size = win_size + 2*padding;
win_align = win_align + padding;

% pre-allocate
channel_count = numel(chan_list);
sample_count = win_size*Fs;
trial_count  = length(timestamps);
data = zeros(trial_count,channel_count,sample_count);

% set the downsampling factor
m = (1/NS.Period) / Fs;
if(floor(m)~=m)
    m=floor(m);
    disp('Warning: non-integer downsampling was attempted but foiled!');
    disp(['  -> floor(' num2str(1/Data_NS.Period) '/' num2str(experiment.options.TARGET_FS) ') = ' num2str(m)]);
end
if(m>10)
    m = factor(m);
    if(m(1) * m(2) <= 10)
        m = [m(1) * m(2) m(3:end)];
    end
    disp(['Warning: downsampling factor was larger than 10, so downsampling will occur in stages (' num2str(m) ')']);
end

% read data
for s=1:length(timestamps)
    start = timestamps(s) - win_align;
    if(start<0)
        start=0;
    end
    time = win_size;
    first_chan = min(chan_list);
    num_chan = max(chan_list)-min(chan_list)+1;
    alldata = NSX_read(NS,first_chan,num_chan,start,time,'s','s',1);
    
    % get rid of channels not in chan_list
    alldata(setdiff(first_chan:(first_chan+num_chan-1),chan_list),:) = [];

    parfor c=1:channel_count
        if(m(1)>1)
            tmp = alldata(c,:);
            for k=m
                tmp = decimate(tmp,k);
            end
            data(s,c,:) = tmp;
        else
            data(s,c,:) = alldata(c,:);
        end
    end
end