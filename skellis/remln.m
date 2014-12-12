function v=remln(v,fs)
% REMLN   Remove line noise and harmonics from neural data
%    REMLN(V,FS) removes line noise which is at least 20dB above baseline
%    by creating a notch filter approximately the same size as the line
%    noise peak in the spectra.  The input V should be a 2D matrix with
%    channels of data in columns (i.e., rows are samples in time).  The
%    input FS is the sampling rate of the input data.

% chronux parameters
params.Fs = fs; % sampling frequency
params.fpass = [0 500]; % frequency of interest
params.tapers = [5 9]; % tapers
params.trialave = 0; % average over trials
params.err = 0; % no error computation
params.pad = 1;

% check availability of chronux
if(~exist('mtspectrumc','file'))
    error('remln:chronux','Unable to find chronux function mtspectrumc');
end

% check orientation of input V
transposeflag=0;
if(size(v,2)>size(v,1))
    transposeflag=1;
    v=v';
end

% generate spectra
[allS,f]=mtspectrumc(v(1:min(200e3,size(v,1)),:),params);
allS=10*log10(allS);
% % Sorig=S;

% find peaks in the spectra
for k=1:size(allS,2)
    S=allS(:,k);

    % find and remove the power-law trend
    trend=smooth(S,fix(0.1*length(S))); % smooth using 10% of samples
    S=S-trend;

    % find the peaks in the de-trended spectra
    idx=find(S>20); % ~15 dB above baseline
    pts=idx(diff([1 idx'])>(20/500)*length(S)); % at least 20 Hz apart

    % % % find the peak maxes
    % % for m=1:length(pts)
    % %     [dummy,maxidx]=max(S(pts(m):pts(m)+fix(10/500*length(S))));
    % %     pts(m)=pts(m)+maxidx-1;
    % % end

    % find the peak centers, bandwidths
    peaks=zeros(length(pts),2);
    for m=1:length(pts)
        pkstart=find(S(pts(m):-1:1)<(mean(S)+std(S)),1,'first');
        pkstart=pts(m)-pkstart+1;
        pkend=find(S(pts(m):end)<(mean(S)+std(S)),1,'first');
        pkend=pts(m)+pkend-1;
        peaks(m,:)=[pkstart pkend];
        pts(m)=fix((pkstart+pkend)/2);

        % [dummy,maxidx]=max(S(pkstart:pkend));
        % pts(m)=pkstart+maxidx-1;
    end

    % create reversal notch filters
    for m=1:length(pts)
        Wo=f(pts(m))/(fs/2); % notch position normalized to [0,1]
        peak_factor=diff(f(peaks(m,:)))/2.1; % try to scale according to peak width
        BW=peak_factor/(fs/2); % bandwidth of the notch at 3db
        Ab=S(pts(m))/2;
        %if(m>1),Ab=Ab/1.5;end%S(pts(m)); % will be using filtfilt which has 2x magnitude response

        % inputs are normalized by pi.
        BW = BW*pi;
        Wo = Wo*pi;
        Gb   = 10^(-Ab/20);
        beta = (sqrt(1-Gb.^2)/Gb)*tan(BW/2);
        gain = 1/(1+beta);
        num  = gain*[1 -2*cos(Wo) 1];
        den  = [1 -2*gain*cos(Wo) (2*gain-1)];

        % filter the data
        v(:,k)=filtfilt(num,den,v(:,k));
        
        % % % re-plot to check
        % % [tmpS,f]=mtspectrumc(v(1:min(200e3,size(v,1)),k),params);
        % % tmpS=10*log10(tmpS);
        % % figure;
        % % plot(f,allS(:,k));
        % % hold on
        % % plot(f,tmpS,'r');
        % % title(['Channel ' num2str(k) ', filter ' num2str(m) '/' num2str(length(pts))]);
    end
end

% re-orient v if necessary
if(transposeflag==1)
    v=v';
end