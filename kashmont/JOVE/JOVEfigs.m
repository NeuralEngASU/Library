%% Load data

load('E:\data\human CNS\JOVE\Case1.mat')
load('E:\data\human CNS\JOVE\Case2.mat')
load('E:\data\human CNS\JOVE\Case3.mat')
load('E:\data\human CNS\JOVE\Case4.mat')
load('E:\data\human CNS\JOVE\Case5.mat')
load('E:\data\human CNS\JOVE\Case6.mat')

load('D:\Data\JOVE\Case1.mat')
load('D:\Data\JOVE\Case2.mat')
load('D:\Data\JOVE\Case3.mat')
load('D:\Data\JOVE\Case4.mat')
load('D:\Data\JOVE\Case5.mat')
load('D:\Data\JOVE\Case6.mat')

c(1,:) = Case1(5,t);
c(2,:) = Case2(10,t);
c(3,:) = Case3(2,t);
c(4,:) = Case4(12,t);
c(5,:) = Case5(12,t);
c(6,:) = Case6(16,t);

%% Raw plots
ch = 10;
L=1:10*Fs;
t = [1000:(1000+Header.Fs*30)];

figure;
subplot(2,3,1)
plot(Case1(ch,L));
subplot(2,3,2)
plot(Case2(ch,L));
subplot(2,3,3)
plot(Case3(ch,L));
subplot(2,3,4)
plot(Case4(ch,L));
subplot(2,3,5)
plot(Case5(ch,L));
subplot(2,3,6)
plot(Case6(ch,L));

%% Average

for c = 1:6
%     x = double(eval(['Case' num2str(c)]));
    csavg(c,:) = nanmean(x_filt);
    
    subplot(2,3,c)
    plot(csavg(c,:))
end

%% High-pass filter

for ch = 1:15
%     x = double(eval(['Case' num2str(c)]));
    Fs = Header.Fs; % sampling frequency
    L = size(Case1,2); % length of signal
    tt = 0:1/Fs:(L-1)/Fs; % time base
    NFFT = 2^14;
    f = Fs/2*linspace(0,1,NFFT/2+1); % single sided spectrum
    
    % high-pass filter
    order = 3;
    Fc = 3; % cutoff frequency
    [z,p,k] = butter(order,Fc/(Fs/2),'high');
    [SOS,G] = zp2sos(z,p,k);% convert to SOS structure to use filter analysis tool
    
    x_filt(ch,:) = filtfilt(SOS,G,double(Case3(ch,t)));
    
%     subplot(2,3,ch)
%     plot(x_filt(ch,:))
%     ylim([-.0006 .0006])
    
    clear z p k SOS G
end

% figure;
% % high-pass filter
% order = 3;
% Fc = 3; % cutoff frequency
% [z,p,k] = butter(order,Fc/(Fs/2),'high');
% [SOS,G] = zp2sos(z,p,k);% convert to SOS structure to use filter analysis tool
% 
% for ch = 1:15;
%     x(ch,:) = filtfilt(SOS,G,double(Case3(ch,t)));
% 
%     subplot(3,5,ch)
%     plot(x(ch,:))
%     ylim([-.0005 .0005])
% end

%% Spectrums

% data = [Case1;Case2;Case3;Case4;Case5;Case6];
% data = double(data(:,(1:30*Fs)));

for c = 1:6%size(data,1)
    [pxx,f] = pmtm(csavg(c,:),9,NFFT,Fs);
    p(c,:) = pxx;
end
% 
% c1pow = nanmean(p((1:15),:));
% c2pow = nanmean(p((16:30),:));
% c3pow = nanmean(p((31:45),:));
% c4pow = nanmean(p((46:60),:));
% c5pow = nanmean(p((61:75),:));
% c6pow = nanmean(p((76:120),:));

cpow = [c1pow;c2pow;c3pow;c4pow;c5pow;c6pow];
figure;
for c = 1:6   
    subplot(2,3,c);
     loglog(f,xfilt(c,:));
%    plot(f,10*log10(cpow(c,:)))
    title('Multi-taper Spectrum');
    xlabel('Frequency (Hz)')
    ylabel('Power')
end


figure;
for c = 1:6
    [pxx,f] = pmtm(data(c,:),9,NFFT,Fs);
    
    subplot(2,3,c);
%     loglog(f,pxx);
    plot(f,10*log10(pxx))
    title('Multi-taper Spectrum');
    xlabel('Frequency (Hz)')
    ylabel('Power')
    
end


% nfft = 2^nextpow2(size(x_filt,2));
% ff = Fs*linspace(0,1,nfft/2+1);
% 
% %Apply fft to each grouping of microelectrodes
% for ch = 1:6
%     FFTcase(ch,:) = fft(x_filt(ch,:),nfft)/size(x_filt,2);
% 
% % subplot(2,3,c)
% % plot(f,2*abs(FFTcase(c,1:nfft/2+1))); %ylim([0 100]); xlim([0 500]); title('Macro 10');
% end
% % multi-taper power spectrum with 95% confidence bounds.
% for c = 1:6
% [pxx,f,pxxc] = pmtm(x_filt(c,:),9,NFFT,Fs,'ConfidenceLevel',0.95);
% title('Multitaper PSD Estimate with 95%-Confidence Bounds')
% subplot(2,3,c)
%     plot(x_filt(c,:))

%% Spectrograms

params.tapers = [4,9];
params.pad = 2;
params.Fs = Fs;

figure
for c = 1:6
[S,t,f]=mtspecgramc(x_filt(c,:),[1 75],params);
subplot(2,3,c)
colormap (jet); imagesc(t,f,(10*log10(S)'))
axis xy; colorbar;
% caxis([0 80]);
 ylim([0 500]);
end

%%

figure;

for ch=1:15
% subplot(4,6,ch)
% plot(c(ch,:))
% xlim([0 61036])
% title('Raw Data');
% set (gca,'xtick',[0 Fs*5 Fs*10]);

% set (gca,'xticklabel',[0 5 10]);

subplot(3,5,ch)
plot(x_filt(ch,:))
xlim([0 size(x_filt,2)])
% ylim([-.0008 .0008])
title('High-Pass Filtered Data');
xlabel('Time (s)')
ylabel('Voltage (uV)')
set (gca,'xtick',[0 Fs*5 Fs*10]);
set (gca,'xticklabel',[0 5 10]);
end

figure;

% subplot(4,6,(ch+12))
% plot(ff,2*abs(FFTcase(ch,1:nfft/2+1)));
% xlim([0 (Fs/2)])
% ylim([0 5e-5])
% title('Spectrum');
% xlabel('Frequency (Hz)')
% ylabel('Power (dB)')
for ch = 1:15
subplot(3,5,ch)
[pxx,f] = pmtm(x_filt(ch,:),9,NFFT,Fs);
% % plot(f,10*log10(pxx))
% plot(f,pxx
loglog(f,pxx)
xlim([10e-1 10e3])
% ylim([10e-18 10e-8])
ylim([10e-14 10e-3])
title('Multi-taper Spectrum');
xlabel('Frequency (Hz)')
ylabel('Power')

end

%%
L=(30*Fs);
st = 4;
t = [st:(st+L)];
clear x_filt

for ch = 1:45
%     x = double(eval(['Case' num2str(c)]));
    Fs = Header.Fs; % sampling frequency
    L = size(t,2); % length of signal
    tt = 0:1/Fs:(L-1)/Fs; % time base
    NFFT = 2^14;
    f = Fs/2*linspace(0,1,NFFT/2+1); % single sided spectrum
    
    % high-pass filter
    order = 5;
    Fc = 3; % cutoff frequency
    [z,p,k] = butter(order,Fc/(Fs/2),'high');
    [SOS,G] = zp2sos(z,p,k);% convert to SOS structure to use filter analysis tool
    
    x_filt(ch,:) = filtfilt(SOS,G,double(Case6(ch,t)));

    clear z p k SOS G
end

figure;
for ch = 1:45
    
subplot(5,9,ch)
[pxx,f] = pmtm(x_filt(ch,:),9,NFFT,Fs);
% % plot(f,10*log10(pxx))
% plot(f,pxx
loglog(f,pxx)
xlim([10e-1 10e3])
ylim([10e-18 10e-8])
title('Multi-taper Spectrum');
xlabel('Frequency (Hz)')
ylabel('Power')
end


%% 
L=(30*Header.Fs);
st = 4;
t = [st:(st+L)];

norm(1,:) = Case1(5,t);
norm(2,:) = Case2(10,t);
norm(3,:) = Case3(2,t);
norm(4,:) = Case4(12,t);
norm(5,:) = Case5(12,t);
norm(6,:) = Case6(16,t);