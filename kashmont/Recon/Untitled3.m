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

%% Save 10 min clip
save('E:\data\human CNS\Recon\tenminrawclip_cl36','tenmincl36rawsamp');
save('E:\data\human CNS\Recon\tenminrawclip_cl43','tenmincl43rawsamp');
save('E:\data\human CNS\Recon\tenminrawclip_cl46','tenmincl46rawsamp');
save('E:\data\human CNS\Recon\tenminrawclip_m36','tenminmicro36rawsamp','-v7.3');
save('E:\data\human CNS\Recon\tenminrawclip_m43','tenminmicro43rawsamp','-v7.3');
save('E:\data\human CNS\Recon\tenminrawclip_m46','tenminmicro46rawsamp','-v7.3');

%% Load saved data

load('E:\data\human CNS\Recon\tenminrawclip_cl36.mat')
load('E:\data\human CNS\Recon\tenminrawclip_cl43.mat')
load('E:\data\human CNS\Recon\tenminrawclip_cl46.mat')
load('E:\data\human CNS\Recon\tenminrawclip_m36.mat')
load('E:\data\human CNS\Recon\tenminrawclip_m43.mat')
load('E:\data\human CNS\Recon\tenminrawclip_m46.mat')

load('E:\data\human CNS\Recon\Header.mat')

%% Define variables

Fs = Header.Fs; % sampling frequency
L = size(tenmincl36rawsamp,2); % length of signal
t = 0:1/Fs:(L-1)/Fs; % time base
NFFT = 2^14;%2^nextpow2(size(tenmincl36rawsamp,2));
ff = Fs/2*linspace(0,1,NFFT/2+1); % single sided spectrum

macros = [36 43 46];

%% general band pass filter
order = 3;
Fp1 = 2/(Fs/2); % normalized highpass frequency
Fp2 = 2000/(Fs/2); %normalized lowpass frequency
[z,p,k] = butter(order,[Fp1 Fp2],'bandpass');
[SOS,G] = zp2sos(z,p,k);% convert to SOS structure to use filter analysis toolgm

for c = 1:size(macros,2)
    x = eval(['tenminmicro' num2str(macros(c)) 'rawsamp']);
    for ch = 1:size(x,1)
        mband{c}(ch,:) = filtfilt(SOS,G,x(ch,:));
    end
    clear x
end

for c = 1:size(macros,2)
    x = eval(['tenmincl' num2str(macros(c)) 'rawsamp']);
    clband{c} = filtfilt(SOS,G,x);
    clear x
end

% for ch = 1:16
%     macrosband(ch,:) = filtfilt(SOS,G,macroelecs(ch,:));
% end

%% Low pass filter
% order = 3;
% Fc = 2/(Fs/2); %normalized lowpass frequency
% [z,p,k] = butter(order,Fc,'high');
% [SOS,G] = zp2sos(z,p,k);% convert to SOS structure to use filter analysis toolgm
% 
% for c = 1:size(macros,2)
%     x = eval(['tenminmicro' num2str(macros(c)) 'rawsamp']);
%     for ch = 1:size(x,1)
%         mtestfilt{c}(ch,:) = filtfilt(SOS,G,x(ch,:));
%     end
%     clear x
% end
% 
% for c = 1:size(macros,2)
%      x = eval(['tenmincl' num2str(macros(c)) 'rawsamp']);
%     cltestfilt{c} = filtfilt(SOS,G,x);
%     clear x
% end

%%
% save filtered data
save('E:\data\human CNS\Recon\spec_cl_highnfft','pcl','-v7.3');
save('E:\data\human CNS\Recon\specconf_cl_highnfft','pccl','-v7.3');
save('E:\data\human CNS\Recon\spec_m_highnfft','pmswavg','-v7.3');
save('E:\data\human CNS\Recon\specconf_cl_highnfft','pxxcswavg','-v7.3');


save('E:\data\human CNS\Recon\tenmin_HL_filt_m', 'mfilt','-v7.3');

%% Perform spatially weighted calculations

for c=1:3
    inner_band{c}=[];
    outer_band{c}=[];
    for ch = 1:8
        inner_band{c} = [inner_band{c}; mband{c}(ch,:)];
    end
    for ch = 9:24
        outer_band{c} = [outer_band{c}; mband{c}(ch,:)];
    end
end

for c=1:3
    inner_avg{c} = nanmean(inner_band{c});
    outer_avg{c} = nanmean(outer_band{c});
    
    spwt{c} = (inner_avg{c}*(5.5/3.5)+outer_avg{c})/2;
end


%     for c = 1:3
%     for ch = 1:8
%         spcwttest_band{c}(ch,:) = mtestfilt{c}(ch,:);
%     end
%     for ch = 9:24
%         spcwttest_band{c}(ch,:) = mtestfilt{c}(ch,:)*(3.5/5.5);
%     end
%     end

%% Notch filter
order = 3;
Fp1 = 55/(Fs/2); % normalized highpass frequency
Fp2 = 65/(Fs/2); %normalized lowpass frequency
[z,p,k] = butter(order,[Fp1 Fp2],'stop');
[SOS,G] = zp2sos(z,p,k);% convert to SOS structure to use filter analysis toolgm

for c = 1:size(macros,2)
    spwtnotch{c} = filtfilt(SOS,G,spwt{c});
    clnotch{c} = filtfilt(SOS,G,clband{c});
end

%% plot notched data
tt = 0:1/Fs:(size(clband{1},2)-1)/Fs; % time base
for c = 1:3
    cc = macros(c);
    figure; plot([430 430],[-.002 .002],'--k'); hold on; plot([435 435],[-.002 .002],'--k'); hold on;
    plot(tt,clnotch{c},'b'); hold on; plot(tt,spwtnotch{c},'r')
    title(sprintf('Raw Waveform Electrode %d',cc))
    xlim([0 600])
    ylim([-0.001 0.001])
    xlabel('Time (s)')
    ylabel('Amplitude (V)')
end


t1 = 430*Fs;
t2 = 432*Fs;
ttt = 0:1/Fs:2; % time base
figure; plot(ttt,clnotch{3}(:,t1:t2),'b'); hold on; plot(ttt,spwtnotch{3}(:,t1:t2),'r')
title(sprintf('Raw Waveform Electrode %d',cc))
% xlim([0 2*Fs])
ylim([-0.0005 0.0005])
xlabel('Time (s)')
ylabel('Amplitude (V)')


%% Spectrums

for c = 1:3;
    [pxx,ff,pxxc] = pmtm(clband{c},9,NFFT,Fs,'ConfidenceLevel',0.95);
    pcl{c} = pxx;
    pccl{c} = pxxc;
    clear pxx pxxc
    
    [pmswavg{c},ff,pxxcswavg{c}] = pmtm(spwt{c},9,NFFT,Fs,'ConfidenceLevel',0.95);
    %         for ch = 1:24
    %             [pxx,ff] = pmtm(mband{c}(ch,:),9,NFFT,Fs);
    %             pm{c}(ch,:) = pxx;
    %             clear pxx
    %         end
    % [pmavg{c},ff] = pmtm(nanmean(mband{c}),9,NFFT,Fs);
end

%     figure;
%     for ch = 1:16
%         [pmacros(ch,:),ff] = pmtm(macrosband(ch,:),9,NFFT,Fs);
%         figure;
%         loglog(ff,(pmacros(ch,:))); hold on;
%     end

% for c = 1:3;
%     [pxx,ff] = pmtm(cltestfilt{c},9,NFFT,Fs);
%     pcltest{c} = pxx;
%     clear pxx
% end
% 
% 
% for c = 1:3
%     idavg = nanmean(spcwttest_band{c});
%     [pxx,ff] = pmtm(idavg,9,NFFT,Fs);
%     pmswavgtest{c}=pxx;
%     clear pxx idavg
%     %         [pmavg{c},ff] = pmtm(nanmean(mband{c}),9,NFFT,Fs);
% end
%     %% Plot spectrums
%    
%     figure;
%     suptitle(sprintf('Macro 36 and Surrounding Micros Segment'));
%     subplot(7,4,2)
%     loglog(ff,pcl{1},'r')
%     hold on;
%     loglog(ff,pmswavg{1},'b')
%     for ch = 1:24
%         subplot(7,4,ch+4)
%         loglog(ff,(pm{1}(ch,:)))
%         %         title('Multi-taper Spectrum');
%         %         xlabel('Frequency (Hz)')
%         %         ylabel('Power')
% %         xlim([0 2000])
% %         ylim([10e-18 10e-7])
%     end
%       
%     figure;
%     suptitle(sprintf('Macro 43 and Surrounding Micros Segment'))
%       subplot(7,4,2)
%     loglog(ff,pcl{2},'r')
%     hold on;
%     loglog(ff,pmswavg{2},'b')
%     for ch = 1:24
%         subplot(7,4,ch+4)
%         loglog(ff,(pm{2}(ch,:)))
%         %         title('Multi-taper Spectrum');
%         %         xlabel('Frequency (Hz)')
%         %         ylabel('Power')
%         xlim([0 2000])
%         ylim([10e-18 10e-7])
%     end
%         
%     figure;
%     suptitle(sprintf('Macro 46 and Surrounding Micros Segment'))
%      subplot(7,4,2)
%     loglog(ff,pcl{3},'r')
%     hold on;
%     loglog(ff,pmswavg{3},'b')
%     for ch = 1:24
%         subplot(7,4,ch+4)
%         loglog(ff,(pm{3}(ch,:)))
%         %         title('Multi-taper Spectrum');
%         %         xlabel('Frequency (Hz)')
%         %         ylabel('Power')
%         xlim([0 2000])
%         ylim([10e-18 10e-7])
%     end
    
    
%%

figure;
for c = 1:3
    
    xxx = [ff', fliplr(ff')];
    xxx(1,16386) = 10^-100;
    xxx(1,1) = 10^-100;
    
    subplot(3,1,c)
    
    loglog(ff,pmswavg{c},'r')
    hold on
    
    yyy = [pxxcswavg{c}(:,1)',fliplr(pxxcswavg{c}(:,2)')];
    patch(xxx,yyy,[1 .7 .7],'EdgeColor',[1 .7 .7]);
    hold on
    
     loglog(ff,pmswavg{c},'r')
    hold on
    
    yyy = [pccl{c}(:,1)',fliplr(pccl{c}(:,2)')];
    patch(xxx,yyy,[.7 .7 1],'EdgeColor',[.7 .7 1]);
    hold on
    
    loglog(ff,pcl{c},'b')
    
    title(sprintf('Multi-taper Spectrum Electrode %d',cc));
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    xlim([2 2000])
    %     ylim([10e-18 10e-7])
    clear yyy
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


   %% coherence
   for c = 1:3
       [Cxy,f] = mscohere(spwt{c},clband{c},Fs,(Fs*0.75),NFFT,Fs);
       coh{c} = Cxy;
       freqs{c} = f;
   end
   
   for c = 1:3
       cc = macros(c);
       figure
       plot(freqs{c},abs(coh{c}));
       title(sprintf('Coherence Estimate Electrode %d',cc));
       xlabel('Frequency (Hz)');
       ylabel('Magnitude');
       axis([0 2000 0 1])
   end
   
   figure;
   avgcoh = nanmean([coh{1} coh{2} coh{3}],2);
   errcoh = std([coh{1} coh{2} coh{3}],[],2)/sqrt(3);
   xx = [freqs{1}(:,1)', fliplr(freqs{1}(:,1)')];
   yy = [avgcoh'+errcoh', fliplr(avgcoh'-errcoh')];
   patch(xx,yy,[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8]);
   hold on;
   plot(freqs{1},avgcoh,'k','LineWidth',1);
   title('Average Coherence Estimate');
   xlabel('Frequency (Hz)');
   ylabel('Magnitude');
   axis([0 2000 0 0.75])
   
   
   %% windowed corr coef
   
  
   for c = 1:3
       full{c} = corrcoef(clband{c}',spwt{c}');
       fullcorr{c} = full{c}(1,2);
       
       n = 1;
   w=1;
   m = Fs*1;
       while m<size(clband{c},2)
       win{c} = corrcoef(clband{c}(1,n:m)',spwt{c}(1,n:m)');
       wincorr{c}(w,:) = win{c}(1,2);
%        Etheta = 2*std(Rtheta);
       w=w+1;
       n=m+1;
       m=n+Fs*1;
       end
   end
   
   avgcorr = nanmean([wincorr{1} wincorr{2} wincorr{3}],2);
   errcorr = std([wincorr{1} wincorr{2} wincorr{3}],[],2)/sqrt(3);
   tcorr = 0:1:(size(clband{1},2)-1)/Fs; % time base
   x = tcorr(1,(1:599));
   
   pp = polyfit(x,avgcorr',3);
   tline = polyval(pp,x);
   
   figure;
   xx = [x', fliplr(x')];
   yy = [(avgcorr+errcorr), fliplr(avgcorr-errcorr)];
   patch(xx',yy',[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8]);
   hold on;
   plot(x,avgcorr,'k','LineWidth',1);
   hold on;
   plot(tline,'r')
   title('Average Correlation Coefficient');
   xlabel('Frequency (Hz)');
   ylabel('Magnitude');
%    axis([0 2000 0 0.75])
   