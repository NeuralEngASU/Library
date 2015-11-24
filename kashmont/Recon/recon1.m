%Load data
load('E:\data\human CNS\PCH\2015PP01\2015PP01_Recon\2015PP01_2015PP01_Recon.mat')

%Collect data from electrodes of interest
cl36 = double(eval(['C' num2str(13)]));
cl43 = double(eval(['C' num2str(6)]));
cl46 = double(eval(['C' num2str(3)]));

m46=[];
%microelectrodes #161-184
ch = [106 105 104 103 102 101 100 99 98 128 127 126 125 124 123 122 121 120 119 118 117 116 115 114];
for c = 1:size(ch,2)
    x = double(eval(['C' num2str(ch(c))]));
    y = x(:,1:size(C25,2));
    m46=[m46; y];
    clear x y
end
clear ch

m43=[];
%microelectrodes #137-160
ch = [68 67 66 96 95 94 93 92 91 90 89 88 87 86 85 84 83 82 112 111 110 109 108 107];
for c = 1:size(ch,2)
    x = double(eval(['C' num2str(ch(c))]));
    y = x(:,1:size(C25,2));
    m43=[m43; y];
    clear x y
end
clear ch

m36=[];
%microelectrodes #113-136
ch = [61 60 59 58 57 56 55 54 53 52 51 50 80 79 78 77 76 75 74 73 72 71 70 69];
for c = 1:size(ch,2)
    x = double(eval(['C' num2str(ch(c))]));
    y = x(:,1:size(C25,2));
    m36=[m36; y];
    clear x y
end

cl46 = cl46(:,(1:size(m46,2)));
cl43 = cl43(:,(1:size(m43,2)));
cl36 = cl36(:,(1:size(m36,2)));

save('E:\data\human CNS\Recon\clinical46','cl46');
save('E:\data\human CNS\Recon\clinical43','cl43');
save('E:\data\human CNS\Recon\clinical36','cl36');
save('E:\data\human CNS\Recon\micros46','m46','-v7.3');
save('E:\data\human CNS\Recon\micros43','m43','-v7.3');
save('E:\data\human CNS\Recon\micros36','m36','-v7.3');
save('E:\data\human CNS\Recon\Header','Header');

%% Load saved data

%Clinical/macro electrodes
load('E:\data\human CNS\Recon\clinical36.mat')
load('E:\data\human CNS\Recon\clinical43.mat')
load('E:\data\human CNS\Recon\clinical46.mat')

%Micro electrodes
load('E:\data\human CNS\Recon\micros46.mat')
load('E:\data\human CNS\Recon\micros36.mat')
load('E:\data\human CNS\Recon\micros43.mat')

%% Create 10 min data clip
%10 min time frame:  (1.437e7-(Fs*600)):1.437e7)
Fs = Header.Fs;

tenmincl36rawsamp = cl36(:,(1.437e7-(Fs*600)):1.437e7);
tenmincl43rawsamp = cl43(:,(1.437e7-(Fs*600)):1.437e7);
tenmincl46rawsamp = cl46(:,(1.437e7-(Fs*600)):1.437e7);

tenminmicro36rawsamp = m36(:,(1.437e7-(Fs*600)):1.437e7);
tenminmicro43rawsamp = m43(:,(1.437e7-(Fs*600)):1.437e7);
tenminmicro46rawsamp = m46(:,(1.437e7-(Fs*600)):1.437e7);
%% Define variables

Fs = Header.Fs; % sampling frequency
L = size(m46,2); % length of signal
t = 0:1/Fs:(L-1)/Fs; % time base
NFFT = 1024;%2^14;%2^nextpow2(size(m,2));
ff = Fs/2*linspace(0,1,NFFT/2+1); % single sided spectrum

macros = [36 43 46];

%% High pass filter
order = 3;
Fc = 2; % cutoff frequency
[z,p,k] = butter(order,Fc/(Fs/2),'high');
[SOS,G] = zp2sos(z,p,k);% convert to SOS structure to use filter analysis toolgm

for c = 1:size(macros,2)
    mm=macros(c);
    x = eval(['tenminmicro' num2str(macros(c)) 'rawsamp']);
    for ch = 1:size(x,1)
        mhigh{c}(ch,:) = filtfilt(SOS,G,x(ch,:));
    end
    clear x
end

for c = 1:size(macros,2)
    x = eval(['tenmincl' num2str(macros(c)) 'rawsamp']);
    clhigh{c} = filtfilt(SOS,G,x);
    clear x
end

%% Low pass filter
order = 3;
Fc = 2000; % cutoff frequency
[z,p,k] = butter(order,Fc/(Fs/2),'low');
[SOS,G] = zp2sos(z,p,k);% convert to SOS structure to use filter analysis toolgm

for c = 1:size(macros,2)
    for ch = 1:size(m36,1)
        mfilt{c}(ch,:) = filtfilt(SOS,G,mhigh{c}(ch,:));
    end
end

for c = 1:size(macros,2)
    clfilt{c} = filtfilt(SOS,G,clhigh{c});
end

% save('E:\data\human CNS\Recon\clinical_filtered','clfilt');
% save('E:\data\human CNS\Recon\micro_filtered','mfilt','-v7.3');

%% Isolate time of interest
% 
% %First three time points contain potential interictal activity; last three
% %time points are baseline-like data
% idpoints{1} = [4.073e5 2.618e6 5.166e6 9.659e5 9.429e6 1.682e7];
% idpoints{2} = [2.308e6 4.597e6 1.95e7 9.963e5 8.21e6 1.502e7];
% idpoints{3} = [2.78e6 4.597e6 9.121e6 8.829e6 1.323e7 1.819e7];
% 
% for c = 1:size(macros,2)
%     for idp = 1:6
%         t1{c}(1,idp) = idpoints{c}(1,idp)-(Fs*5);
%         t2{c}(1,idp) = idpoints{c}(1,idp)+(Fs*5);
%     end
% end
% 
% for idp = 1:6
%     cl36filt{idp} = clfilt{1}(1,(t1{1}(idp):t2{1}(idp)));
%     cl43filt{idp} = clfilt{2}(1,(t1{2}(idp):t2{2}(idp)));
%     cl46filt{idp} = clfilt{3}(1,(t1{3}(idp):t2{3}(idp)));
% end
% 
% for idp = 1:6
%     for ch = 1:size(m36,1)
%         m36filt{idp}(ch,:) = mfilt{1}(ch,(t1{1}(idp):t2{1}(idp)));
%         m43filt{idp}(ch,:) = mfilt{2}(ch,(t1{2}(idp):t2{2}(idp)));
%         m46filt{idp}(ch,:) = mfilt{3}(ch,(t1{3}(idp):t2{3}(idp)));
%     end
% end
% 
% 
% %plot data
%     for idp = 1:6
%         figure;
%         for ch = 1:size(m36,1)
%             subplot(7,4,ch+4)
%             plot(m36filt{idp}(ch,:))
%             %         title('Multi-taper Spectrum');
%             %         xlabel('Frequency (Hz)')
%             %         ylabel('Power')
%             %         xlim([0 2000])
%             %         ylim([10e-18 10e-7])
%         end
%         
%         subplot(7,4,2)
%         figure;
%         plot(cl36filt{idp})
%         hold on;
%         plot(nanmean(m36filt{idp}))
%         %     title('Multi-taper Spectrum');
%         %     xlabel('Frequency (Hz)')
%         %     ylabel('Power')
%         %     xlim([0 2000])
%         %     ylim([10e-18 10e-7])
%     end

%% Spectrums
% for idp = 1:6
%     [pxx,f] = pmtm(cl36filt{idp},9,NFFT,Fs);
%     pcl36{idp} = pxx;
%     clear pxx
%     [pxx,f] = pmtm(cl42filt{idp},9,NFFT,Fs);
%     pcl43{idp} = pxx;
%     clear pxx
for c = 1:3;
    [pxx,f] = pmtm(clfilt{c},9,NFFT,Fs);
    pcl{c} = pxx;
    clear pxx
    
    for ch = 1:size(m36,1)
        [pxx,f] = pmtm(mfilt{c}(ch,:),9,NFFT,Fs);
        pm{c}(ch,:) = pxx;
        clear pxx
    end
    
    avgmicros{c} = nanmean(mfilt{c});
    [pxx,f] = pmtm(avgmicros{c},9,NFFT,Fs);
    pmavg{c} = pxx;

    for c = 1:3
    summicros{c} = sum(mfilt{c});
    [pxx,f] = pmtm(summicros{c},9,NFFT,Fs);
    pmsum{c} = pxx;
end

% for idp = 1:6
    figure;
    suptitle(sprintf('Macro 36 and Surrounding Micros Segment'));
    for ch = 1:size(m36,1)
        subplot(7,4,ch+4)
        loglog(f,(pm{1}(ch,:)))
%         title('Multi-taper Spectrum');
%         xlabel('Frequency (Hz)')
%         ylabel('Power')
        xlim([0 2000])
        ylim([10e-18 10e-7])
    end
    
    subplot(7,4,2)
    loglog(f,pcl{1},'r')
    hold on;
%     for ch = 1:8
%         spcwt(ch,:) = pm{1}(ch,:);
%     end
%     for ch = 9:24
%         spcwt(ch,:) = pm{1}(ch,:)*(3.5/5.5);
%     end
    loglog(f,pmavg{1},'b')
%     title('Multi-taper Spectrum');
%     xlabel('Frequency (Hz)')
%     ylabel('Power')
    xlim([0 2000])
    ylim([10e-18 10e-7])
    
    clear spcwt
    
    
    figure;
    suptitle(sprintf('Macro 43 and Surrounding Micros Segment'))
    for ch = 1:size(m36,1)
        subplot(7,4,ch+4)
        loglog(f,(pm{2}(ch,:)))
        %         title('Multi-taper Spectrum');
        %         xlabel('Frequency (Hz)')
        %         ylabel('Power')
        xlim([0 2000])
        ylim([10e-18 10e-7])
    end
    
    subplot(7,4,2)
    loglog(f,pcl{2},'r')
    hold on;
%     for ch = 1:8
%         spcwt(ch,:) = pm{2}(ch,:);
%     end
%     for ch = 9:24
%         spcwt(ch,:) = pm{2}(ch,:)*(3.5/5.5);
%     end
    loglog(f,pmavg{2},'b')
%     title('Multi-taper Spectrum');
%     xlabel('Frequency (Hz)')
%     ylabel('Power')
    xlim([0 2000])
    ylim([10e-18 10e-7])

    clear spcwt    


    figure;
    suptitle(sprintf('Macro 46 and Surrounding Micros Segment'))
    for ch = 1:size(m36,1)
        subplot(7,4,ch+4)
        loglog(f,(pm{3}(ch,:)))
        %         title('Multi-taper Spectrum');
        %         xlabel('Frequency (Hz)')
        %         ylabel('Power')
        xlim([0 2000])
        ylim([10e-18 10e-7])
    end
    
    subplot(7,4,2)
    loglog(f,pcl{3},'r')
    hold on;
%     for ch = 1:8
%         spcwt(ch,:) = pm{3}(ch,:);
%     end
%     for ch = 9:24
%         spcwt(ch,:) = pm{3}(ch,:)*(3.5/5.5);
%     end
    loglog(f,pmavg{3},'b')
    %     title('Multi-taper Spectrum');
    %     xlabel('Frequency (Hz)')
    %     ylabel('Power')
    xlim([0 2000])
    ylim([10e-18 10e-7])
    
    clear spcwt

%% create same 10 min sample of depth electrodes recorded on xltek.

%data is being divided by 1,000,000 because xltek data is recorded in
%microvolts while tdt data is in volts.
xltek_pt = 1.437e7/Fs * 500;

k = 1;
for ch = 97:102
    depth{1}(k,:) = data(ch,xltek_pt-(500*600):xltek_pt)/1000000;
    k = k+1;
end

clear ch k

k = 1;
for ch = 103:108
    depth{2}(k,:) = data(ch,xltek_pt-(500*600):xltek_pt)/1000000;
    k = k+1;
end

clear ch k

k = 1;
for ch = 109:114
    depth{3}(k,:) = data(ch,xltek_pt-(500*600):xltek_pt)/1000000;
    k = k+1;
end

clear ch k

k = 1;
for ch = 115:120
    depth{4}(k,:) = data(ch,xltek_pt-(500*600):xltek_pt)/1000000;
    k = k+1;
end

clear ch k

k = 1;
for ch = 121:126
    depth{5}(k,:) = data(ch,xltek_pt-(500*600):xltek_pt)/1000000;
     k = k+1;
end

%% High pass filter depths
order = 3;
Fc = 2; % cutoff frequency
[z,p,k] = butter(order,Fc/(500/2),'high');
[SOS,G] = zp2sos(z,p,k);% convert to SOS structure to use filter analysis toolgm

for c = 1:size(depth,2)
    for ch = 1:size(depth{1},1)
        depthfilt{c}(ch,:) = filtfilt(SOS,G,depth{c}(ch,:));
    end
end

%% spectrums of depth electrodes

for c = 1:size(depth,2);
    for ch = 1:size(depth{1},1)
        [pxx,ff] = pmtm(depthfilt{c}(ch,:),9,512,600);
        pdepth{c}(ch,:) = pxx;
        clear pxx
    end
end

%% Plot depth spectrums

figure;
for c = 1:size(depth,2)
    avgdepth{c} = nanmean(pdepth{c});
    suptitle('Average Depth Electrode Activity');
    subplot(3,2,c+1)
    loglog(ff,(avgdepth{c}))
    title(sprintf('Depth %d',c))
    %         xlabel('Frequency (Hz)')
    %         ylabel('Power')
    xlim([0 300])
    %         ylim([10e-18 10e-7])
end


for c = 1:size(depth,2)
    figure;
    suptitle(sprintf('Depth %d',c));
    for ch = 1:size(depth{1},1)
        subplot(3,2,ch)
        loglog(f,(pdepth{c}(ch,:)))
        %         title('Multi-taper Spectrum');
        %         xlabel('Frequency (Hz)')
        %         ylabel('Power')
        xlim([0 300])
%         ylim([10e-18 10e-7])
    end
end
%% Spectrograms

%macroelectrodes
params.tapers = [4,9];
params.pad = 2;
params.Fs = Fs;

figure
for c = 1:3
    [S,t,f]=mtspecgramc(clfilt{c},[2 1.75],params);
    subplot(3,1,c)
    colormap (jet); imagesc(t,f,(10*log10(S)'))
    axis xy; colorbar;
    caxis([-160 -80]);
    ylim([0 250]);
end


%micros
for c = 1:3
     figure;
    for ch = 1:size(mfilt{1},1)
        [S,t,f]=mtspecgramc(mfilt{c}(ch,:),[2 1.75],params);
%         suptitle(sprintf('Micros Around Macro %d',macros(c)));
        subplot(6,4,ch)
        colormap (jet); imagesc(t,f,(10*log10(S)'))
        axis xy; colorbar;
        caxis([-160 -80]);
        ylim([0 2000]);

        clear S t f
    end
end

%average depth electrode specs
for c = 1:5
    avgdepthsig{c} =  nanmean(depthfilt{c});
end

depthparams.tapers = [4,9];
depthparams.pad = 2;
depthparams.Fs = 500;
figure
for c = 1:5
    [S,t,f]=mtspecgramc(avgdepthsig{c},[2 1.5],depthparams);
    subplot(5,1,c)
    colormap (jet); imagesc(t,f,(10*log10(S)'))
    axis xy; colorbar;
    caxis([-160 -80]);
%     ylim([0 2000]);
end

%individual depth electrode specs
for c = 1:size(depth,2)
    figure;
    suptitle(sprintf('Depth %d',c));
    for ch = 1:size(depth{1},1)
        [S,t,f]=mtspecgramc(depthfilt{c}(ch,:),[2 1.5],depthparams);
        subplot(3,2,ch)
    colormap (jet); imagesc(t,f,(10*log10(S)'))
    axis xy; colorbar;
    caxis([-160 -80]);
    end
end


%% look at all macros
for ch = 1:80
macrosamp(ch,:) = data(ch,xltek_pt-(500*600):xltek_pt)/1000000;
end

%% High pass filtermacros
order = 3;
Fc = 2; % cutoff frequency
[z,p,k] = butter(order,Fc/(500/2),'high');
[SOS,G] = zp2sos(z,p,k);% convert to SOS structure to use filter analysis toolgm

    for ch = 1:80
        macrofilt(ch,:) = filtfilt(SOS,G,macrosamp(ch,:));
    end


%% spectrums of macro electrodes


    for ch = 1:80
        [pxx,f] = pmtm(macrofilt(ch,:),9,512,500);
        pmacro(ch,:) = pxx;
        clear pxx
    end

    k=1;
    figure;
    for ch = 52:56
%         figure;
subplot(2,3,k)
        loglog(f,(pmacro(ch,:)))
        title(sprintf('Macro %d',ch))
        %         xlabel('Frequency (Hz)')
        %         ylabel('Power')
        xlim([0 300])
        k=k+1;
    end
%% Linear average

inner = mm((2:9),:);
outer = mm(1,:);
outer = [outer;mm((10:24),:)];

outavg = nanmean(outer);
inavg = 2*nanmean(inner);
recon2 = (outavg+inavg)/2; %sum of outavg and inavg looks similar to cl.

%% re-filter cl46

L = size(cl46,2); % length of signal
tt = 0:1/Fs:(L-1)/Fs; % time base
NFFT = 2^14;
f = Fs/2*linspace(0,1,NFFT/2+1); % single sided spectrum

order = 5;
Fc = 10; % cutoff frequency
[z,p,k] = butter(order,Fc/(Fs/2),'high');
[SOS,G] = zp2sos(z,p,k);% convert to SOS structure to use filter analysis toolgm

clfilt = filtfilt(SOS,G,double(cl46(1,:)));

highcl = clfilt(1,(t1:t2));

% figure; plot(recon*3); hold on; plot(cl2,'r')

%% Maxwells
r = [5.5 3.5 3.5 3.5 3.5 3.5 3.5 3.5 3.5 5.5 5.5 5.5 5.5 5.5 5.5 5.5 5.5 5.5 5.5 5.5 5.5 5.5 5.5 5.5];
%r = r/10;

for ch = 1:size(mm,1)
    Mm(ch,:) = mm(ch,:)/(4*pi*r(:,ch));
end

recon = sum(Mm);

%% coherence between macro and each micro

for ch = 1:24
    [Cxy,ff]= mscohere(cl, mm(ch,:),[],[],[],Fs);
    cohere(ch,:) = Cxy;
    freq(ch,:) = ff;
end

for ch = 1:24
    figure; plot(freq(ch,:),cohere(ch,:))
    title(sprintf('Micro %d', ch));
    xlim([1 2000])
end

%% Frequency analysis

nfft = 2^nextpow2(size(m,2));

for ch = 1:size(mm,1)
ftmicro(ch,:) = fft(mm(ch,:),size(cl,2));
end

ftclin = fft(cl,size(cl,2));
f = Fs/2*linspace(0,1,size(cl,2)/2+1); % single sided spectrum

P2 = abs(ftclin/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

figure; plot(f,P1); %ylim([0 100]);
% xlim([0 1000]);
title('Macro 46');



for ch = 1:size(mm,1)
    P2 = abs(ftmicro(ch,:)/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    
    figure; plot(f,P1); %ylim([0 100]);
%     xlim([0 1000]);
    title(sprintf('Micro %d', ch));
    clear P1 P2
end

attenP = ftmicro;
for ch = 1:24
    for idf = 2686:size(ftmicro,2) %2000Hz and up
        attenP(ch,idf) = ftmicro(ch,idf)*0.1;
    end
    for idf = 673:2685 %500Hz to 2000Hz
            attenP(ch,idf) = ftmicro(ch,idf)*0.5;
    end
    for idf = 337:672 %250Hz to 500Hz 
            attenP(ch,idf) =ftmicro(ch,idf)*0.75;
    end
    for idf = 102:336 %250Hz to 75Hz
        attenP(ch,idf) = ftmicro(ch,idf)*0.60;
    end
    for idf = 1:101 %75Hz and down
        attenP(ch,idf) = ftmicro(ch,idf)*0.50;
    end
end


%ifft
for ch = 1:size(attenP,1)
invm(ch,:) = ifft(attenP(ch,:),size(cl,2),'symmetric');
end


%plot data
figure;
subplot(5,6,3)
plot(cl)
xlim([1 (t2-t1)])

for ch = 1:size(mm,1)
    subplot(5,6,ch+6)
    plot(invm(ch,:))
    xlim([1 (t2-t1)])
end

%Maxwells
r = [5.5 3.5 3.5 3.5 3.5 3.5 3.5 3.5 3.5 5.5 5.5 5.5 5.5 5.5 5.5 5.5 5.5 5.5 5.5 5.5 5.5 5.5 5.5 5.5];
% r = r/10;

for ch = 1:size(mm,1)
    Mm(ch,:) = invm(ch,:)/(4*pi*r(:,ch));
end

recon = sum(Mm);
t = linspace(1,size(cl,2),size(recon,2));

inner = invm((2:9),:);
outer = invm(1,:);
outer = [outer;invm((10:24),:)];

outavg = nanmean(outer);
inavg = 2*nanmean(inner);
recon2 = (outavg+inavg)/2; %sum of outavg and inavg looks similar to cl.


%% bandpass

%delta/theta
Fst1 = 0.5;
Fp1 = 2;
Fp2 = 8;
Fst2 = 10;
Ast1 = 65;
Ast2 = 65;
Ap = 1;
Fs = Header.Fs;

d = fdesign.bandpass('Fst1','Fp1','Fp2','Fst2','Ast1','Ap','Ast2','Fs',Fst1,Fp1,Fp2,Fst2,Ast,Ap,Ast2,Fs);
Hd = design(d,'equiripple');

y = filtfilt(Hd,x);