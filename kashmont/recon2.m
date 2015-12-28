[header, data] = genclip('D:\human CNS\PCH\2015PP01\XLTek data\2015PP01_D03','22:03:40',4,128);

t1 = 6.113e4;
t2 = 6.304e4;

%% High pass filter

clear z p k SOS G Fc order

order = 5;
Fc = 3; % cutoff frequency
[z,p,k] = butter(order,Fc/(Fs/2),'high');
[SOS,G] = zp2sos(z,p,k);% convert to SOS structure to use filter analysis toolgm

xl46high = filtfilt(SOS,G,data(46,:));
xl43high = filtfilt(SOS,G,data(43,:));
xl36high = filtfilt(SOS,G,data(36,:));

d1high = filtfilt(SOS,G,d1);
d2high = filtfilt(SOS,G,d2);


%% Low pass filter

clear z p k SOS G Fc order

Fs = 500;
order = 5;
Fc = 249; % cutoff frequency
[z,p,k] = butter(order,Fc/(Fs/2),'low');
[SOS,G] = zp2sos(z,p,k);% convert to SOS structure to use filter analysis toolgm

xlfilt36 = filtfilt(SOS,G,xl36high);
xlfilt43 = filtfilt(SOS,G,xl43high);
xlfilt46 = filtfilt(SOS,G,xl46high);

d1filt = filtfilt(SOS,G,d1high);
d2filt = filtfilt(SOS,G,d2high);


t1 = 500*120;
t2 = 500*149;


clear z p k SOS G Fc order

Fs = Header.Fs;
order = 5;
Fc = 249; % cutoff frequency
[z,p,k] = butter(order,Fc/(Fs/2),'low');
[SOS,G] = zp2sos(z,p,k);% convert to SOS structure to use filter analysis toolgm

cl_xlfilt361 = filtfilt(SOS,G,cl36filt{1});
cl_xlfilt362 = filtfilt(SOS,G,cl36filt{2});
cl_xlfilt336 = filtfilt(SOS,G,cl36filt{3});

Fs = header.Fs; % sampling frequency
L = size(data,2); % length of signal
t = 0:1/Fs:(L-1)/Fs; % time base
NFFT = 1024;%2^14;%2^nextpow2(size(m,2));
ff = Fs/2*linspace(0,1,NFFT/2+1); % single sided spectrum

%% Spectrums

[pxx,f] = pmtm(sample,9,NFFT,Fs);
pxl36 = pxx;
clear pxx

[pxx,ff] = pmtm(cl_xlfilt336,9,NFFT,Fs);
pxl336= pxx;
clear pxx

[pxx,f] = pmtm(xlfilt46,9,NFFT,Fs);
pxl46 = pxx;

figure;
subplot(3,1,1)
loglog(f,pxl36)
%         title('Multi-taper Spectrum');
%         xlabel('Frequency (Hz)')
%         ylabel('Power')
% xlim([0 2000])
% ylim([10e-18 10e-7])

subplot(3,1,2)
loglog(f,pxl43)
%         title('Multi-taper Spectrum');
%         xlabel('Frequency (Hz)')
%         ylabel('Power')
% xlim([0 2000])
% ylim([10e-18 10e-7])

subplot(3,1,3)
loglog(f,pxl46)
%         title('Multi-taper Spectrum');
%         xlabel('Frequency (Hz)')
%         ylabel('Power')
% xlim([0 2000])
% ylim([10e-18 10e-7])

%%

[pxx,f] = pmtm(cl_xlfilt36,9,NFFT,Fs);
pxlcl36 = pxx;
clear pxx

[pxx,f] = pmtm(cl_xlfilt43,9,NFFT,Fs);
pxlcl43 = pxx;
clear pxx

[pxx,f] = pmtm(cl_xlfilt46,9,NFFT,Fs);
pclxl46 = pxx;

figure;
subplot(3,1,1)
loglog(f,pclxl36)
%         title('Multi-taper Spectrum');
%         xlabel('Frequency (Hz)')
%         ylabel('Power')
% xlim([0 2000])
% ylim([10e-18 10e-7])

subplot(3,1,2)
loglog(f,pclxl43)
%         title('Multi-taper Spectrum');
%         xlabel('Frequency (Hz)')
%         ylabel('Power')
% xlim([0 2000])
% ylim([10e-18 10e-7])

subplot(3,1,3)
loglog(f,pclxl46)

%%
header.ClipStartTime;

%First three time points contain potential interictal activity; last three
%time points are baseline-like data
idpoints{3} = [2.78e6 4.597e6 9.121e6 8.829e6 1.323e7 1.819e7];

for id = 1:3;
    for p = 1:6;
pts{id}(:,p) = (idpoints{id}(:,p)/Fs)*500;
    end
end

for idp = 1:6
    t1(1,idp) = pts{3}(1,idp)-(500*5);
    t2(1,idp) = pts{3}(1,idp)+(500*5);
end

for idp = 1:6
depth2seg(:,idp) = depth2()
