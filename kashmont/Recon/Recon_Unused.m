%% look at all macros
for ch = 1:80
macrosamp(ch,:) = data(ch,xltek_pt-(500*600):xltek_pt)/1000000;
end

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

%% create same 10 min sample of depth electrodes recorded on xltek.

% look at depth electrode data from xlteck

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
    
%% Bandpass Filters (filter bank)

order = 3;
Fst1 = 4/(Fs/2); % cutoff frequency
Fst2 = 7/(Fs/2);
[z,p,k] = butter(order,[Fst1 Fst2],'bandpass');
[SOS,G] = zp2sos(z,p,k);% convert to SOS structure to use filter analysis toolgm

for c = 1:size(macros,2)
    mm=macros(c);
    x = eval(['tenminmicro' num2str(macros(c)) 'rawsamp']);
    for ch = 1:size(x,1)
        mtheta{c}(ch,:) = filtfilt(SOS,G,x(ch,:));
    end
    clear x
end
for c = 1:size(macros,2)
    x = eval(['tenmincl' num2str(macros(c)) 'rawsamp']);
    cltheta{c} = filtfilt(SOS,G,x);
    clear x
end

clear Fst1 Fst2 z p k SOS G

Fst1 = 8/(Fs/2); % cutoff frequency
Fst2 = 13/(Fs/2);
[z,p,k] = butter(order,[Fst1 Fst2],'bandpass');
[SOS,G] = zp2sos(z,p,k);% convert to SOS structure to use filter analysis toolgm

for c = 1:size(macros,2)
    mm=macros(c);
    x = eval(['tenminmicro' num2str(macros(c)) 'rawsamp']);
    for ch = 1:size(x,1)
        malpha{c}(ch,:) = filtfilt(SOS,G,x(ch,:));
    end
    clear x
end

for c = 1:size(macros,2)
    x = eval(['tenmincl' num2str(macros(c)) 'rawsamp']);
    clalpha{c} = filtfilt(SOS,G,x);
    clear x
end

clear Fst1 Fst2 z p k SOS G


Fst1 = 14/(Fs/2); % cutoff frequency
Fst2 = 30/(Fs/2);
[z,p,k] = butter(order,[Fst1 Fst2],'bandpass');
[SOS,G] = zp2sos(z,p,k);% convert to SOS structure to use filter analysis toolgm

for c = 1:size(macros,2)
    mm=macros(c);
    x = eval(['tenminmicro' num2str(macros(c)) 'rawsamp']);
    for ch = 1:size(x,1)
        mbeta{c}(ch,:) = filtfilt(SOS,G,x(ch,:));
    end
    clear x
end

for c = 1:size(macros,2)
    x = eval(['tenmincl' num2str(macros(c)) 'rawsamp']);
    clbeta{c} = filtfilt(SOS,G,x);
    clear x
end

clear Fst1 Fst2 z p k SOS G


Fst1 = 31/(Fs/2); % cutoff frequency
Fst2 = 80/(Fs/2);
[z,p,k] = butter(order,[Fst1 Fst2],'bandpass');
[SOS,G] = zp2sos(z,p,k);% convert to SOS structure to use filter analysis toolgm

for c = 1:size(macros,2)
    mm=macros(c);
    x = eval(['tenminmicro' num2str(macros(c)) 'rawsamp']);
    for ch = 1:size(x,1)
        mgamma{c}(ch,:) = filtfilt(SOS,G,x(ch,:));
    end
    clear x
end

for c = 1:size(macros,2)
    x = eval(['tenmincl' num2str(macros(c)) 'rawsamp']);
    clgamma{c} = filtfilt(SOS,G,x);
    clear x
end

clear Fst1 Fst2 z p k SOS G


Fst1 = 81/(Fs/2); % cutoff frequency
Fst2 = 200/(Fs/2);
[z,p,k] = butter(order,[Fst1 Fst2],'bandpass');
[SOS,G] = zp2sos(z,p,k);% convert to SOS structure to use filter analysis toolgm

for c = 1:size(macros,2)
    mm=macros(c);
    x = eval(['tenminmicro' num2str(macros(c)) 'rawsamp']);
    for ch = 1:size(x,1)
        mhighgamma{c}(ch,:) = filtfilt(SOS,G,x(ch,:));
    end
    clear x
end

for c = 1:size(macros,2)
    x = eval(['tenmincl' num2str(macros(c)) 'rawsamp']);
    clhighgamma{c} = filtfilt(SOS,G,x);
    clear x
end

clear Fst1 Fst2 z p k SOS G


Fst1 = 201/(Fs/2); % cutoff frequency
Fst2 = 250/(Fs/2);
[z,p,k] = butter(order,[Fst1 Fst2],'bandpass');
[SOS,G] = zp2sos(z,p,k);% convert to SOS structure to use filter analysis toolgm

for c = 1:size(macros,2)
    mm=macros(c);
    x = eval(['tenminmicro' num2str(macros(c)) 'rawsamp']);
    for ch = 1:size(x,1)
        msupgamma{c}(ch,:) = filtfilt(SOS,G,x(ch,:));
    end
    clear x
end

for c = 1:size(macros,2)
    x = eval(['tenmincl' num2str(macros(c)) 'rawsamp']);
    clsupgamma{c} = filtfilt(SOS,G,x);
    clear x
end

clear Fst1 Fst2 z p k SOS G


Fst1 = 251/(Fs/2); % cutoff frequency
Fst2 = 2000/(Fs/2);
[z,p,k] =butter(order,[Fst1 Fst2],'bandpass');
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
    

%% spatially weighted sum of frequency bands

bands = ['theta    '; 'alpha    '; 'beta     '; 'gamma    '; 'highgamma' ;'supgamma '; 'high     ']
for c=1:3
  for  b = 1:7
    inner_band{c}=[];
    outer_band{c}=[];
    idband = eval(['m' bands(b,:)]);
    for ch = 1:8
        inner_band{c} = [inner_band{c}; idband{c}(ch,:)];
    end
    for ch = 9:24
        outer_band{c} = [outer_band{c}; idband{c}(ch,:)];
    end

    inner_avg{c} = nanmean(inner_band{c});
    outer_avg{c} = nanmean(outer_band{c});
    
   if b == 1
        spcwt_mtheta{c}(ch,:) = (inner_avg{c}*(5.5/3.5)+outer_avg{c})/2;
    end
    if b == 2
        spcwt_malpha{c}(ch,:) = (inner_avg{c}*(5.5/3.5)+outer_avg{c})/2;
    end
    if b == 3
        spcwt_mbeta{c}(ch,:) = (inner_avg{c}*(5.5/3.5)+outer_avg{c})/2;
    end
    if b==4
        spcwt_mgamma{c}(ch,:) = (inner_avg{c}*(5.5/3.5)+outer_avg{c})/2;
    end
    if b == 5
        spcwt_mhighgamma{c}(ch,:) = (inner_avg{c}*(5.5/3.5)+outer_avg{c})/2;
    end
    if b == 6
        spcwt_msupgamma{c}(ch,:) = (inner_avg{c}*(5.5/3.5)+outer_avg{c})/2;
    end
    if b == 7
        spcwt_mhigh{c}(ch,:) = (inner_avg{c}*(5.5/3.5)+outer_avg{c})/2;
    end
  end
end
    
%    corr coefs of freq bands
    
    for c = 1:3
        Rt{c} = corrcoef(cltheta{c},nanmean(spcwt_mtheta{c}));
        Rtheta(c,:) = Rt{c}(1,2);
        Etheta = 2*std(Rtheta);
        
        Ra{c} = corrcoef(clalpha{c},nanmean(spcwt_malpha{c}));
        Ralpha(c,:) = Ra{c}(1,2);
        Ealpha = 2*std(Ralpha);
        
        Rb{c} = corrcoef(clbeta{c},nanmean(spcwt_mbeta{c}));
        Rbeta(c,:) = Rb{c}(1,2);
        Ebeta = 2*std(Rbeta);
        
        Rg{c} = corrcoef(clgamma{c},nanmean(spcwt_mgamma{c}));
        Rgamma(c,:) = Rg{c}(1,2);
        Egamma = 2*std(Rgamma);
        
        Rhg{c} = corrcoef(clhighgamma{c},nanmean(spcwt_mhighgamma{c}));
        Rhighgamma(c,:) = Rhg{c}(1,2);
        Ehighgamma = 2*std(Rhighgamma);
        
        Rsg{c} = corrcoef(clsupgamma{c},nanmean(spcwt_msupgamma{c}));
        Rsupgamma(c,:) = Rsg{c}(1,2);
        Esupgamma = 2*std(Rsupgamma);
        
        Rh{c} = corrcoef(clhigh{c},nanmean(spcwt_mhigh{c}));
        Rhigh(c,:) = Rh{c}(1,2);
        Ehigh = 2*std(Rhigh);
        
    end
    
        %% 

freq = [4;8;14;31;81;201;251];
R = [nanmean(Rtheta);nanmean(Ralpha);nanmean(Rbeta);nanmean(Rgamma);nanmean(Rhighgamma);nanmean(Rsupgamma);nanmean(Rhigh)];
E = [Etheta;Ealpha;Ebeta;Egamma;Ehighgamma;Esupgamma;Ehigh];
figure;
errorbar(freq,R, E);
title('Average Correlation Coefficients Across Frequency Bands')
xlabel('Frequency (Hz)')
ylabel('Correlation')   
%    R36 = [Rtheta(1,:);Ralpha(1,:);Rbeta(1,:);Rgamma(1,:);Rhighgamma(1,:);Rsupgamma(1,:);Rhigh(1,:)];
%    R43 = [Rtheta(2,:);Ralpha(2,:);Rbeta(2,:);Rgamma(2,:);Rhighgamma(2,:);Rsupgamma(2,:);Rhigh(2,:)];
%    R46 = [Rtheta(3,:);Ralpha(3,:);Rbeta(3,:);Rgamma(3,:);Rhighgamma(3,:);Rsupgamma(3,:);Rhigh(3,:)];
% 
%    E36 = [nanmean(Etheta{1});nanmean(Ealpha{1});nanmean(Ebeta{1});nanmean(Egamma{1});nanmean(Ehighgamma{1});nanmean(Esupgamma{1});nanmean(Ehigh{1})];
%    E43 = [nanmean(Etheta{2});nanmean(Ealpha{2});nanmean(Ebeta{2});nanmean(Egamma{2});nanmean(Ehighgamma{2});nanmean(Esupgamma{2});nanmean(Ehigh{2})];    
%    E46 = [nanmean(Etheta{3});nanmean(Ealpha{3});nanmean(Ebeta{3});nanmean(Egamma{3});nanmean(Ehighgamma{3});nanmean(Esupgamma{3});nanmean(Ehigh{3})];
%     
%    figure;
%    h1=errorbar(freq,R36,E36);
%    set(h1,'Color','b');
%    hold on;
%    h2=errorbar(freq,R43,E43);
%    set(h2,'Color','r');
%    hold on;
%    h3=errorbar(freq,R46,E46);
%    set(h1,'Color','g');

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

%% Maxwells

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
