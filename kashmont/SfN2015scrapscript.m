
% Use OUTPUT = openNSx(fname, 'read', 'report', 'e:xx:xx', 'c:xx:xx', 't:xx:xx', 'mode', 'precision', 'skipfactor').
%1,2,4,11,16,17,28,29,30,31,32,36,37,38,41,42,43,46,60,62,65,76,83,85,96,120

%% Extract clips from Utah patient 201101 clinical EDF file

[header,rcd] = edfread('E:\data\human CNS\201101\20110323-185852\Fxxx~ Rxxx_701a652d-b380-4538-95a3-05e5a9058e8c.edf');

%Mclip1
data = rcd(:,(27000000:28000000));
hdr.patient = 'Utah Patient 2011'
hdr.parentfile = 'Fxxx~ Rxxx_701a652d-b380-4538-95a3-05e5a9058e8c.edf'
hdr.parentfilestarttime = '14.23.03'
hdr.parentfiledate = '23.03.11'
hdr.Fs = '1000'
hdr.clipsamplerange = '27000000 to 28000000'
hdr.clipstarttime = '21.53.03'

save('E:\data\human CNS\201101\Mclip1.mat','data','hdr');

%Mclip2
data = rcd(:,(34000000:36000000));
hdr.patient = 'Utah Patient 201101'
hdr.parentfile = 'Fxxx~ Rxxx_701a652d-b380-4538-95a3-05e5a9058e8c.edf'
hdr.parentfilestarttime = '14.23.03'
hdr.parentfiledate = '23.03.11'
hdr.Fs = '1000'
hdr.clipsamplerange = '34000000 to 36000000'
hdr.clipstarttime = '23.49.43'

save('E:\data\human CNS\201101\Mclip2.mat','data','hdr');


%% Load data
mclip1 = openNSx('E:\data\human CNS\201101\20110323-185852\20110323-185852-001.ns4','read','t:70000:6070000','sample');
mclip2 = openNSx('E:\data\human CNS\201101\20110323-185852\20110323-185852-002.ns4','read','t:50000:6050000','sample');

Micro1 = double(mclip1.Data);
Micro2 = double(mclip2.Data);

Mclip1 = load ('E:\data\human CNS\201101\Mclip1.mat');
Mclip2 = load ('E:\data\human CNS\201101\Mclip2.mat');

Macro1 = Mclip1.data((1:14),(357000:957000));
Macro2 = Mclip2.data((1:14),(557000:1157000));

%% Detrend macroelectrode data

for ch = 1:size(Macro1,1)
    Macro1(ch,:) = Macro1(ch,:) - nanmean(Macro1(ch,:));
    Macro2(ch,:) = Macro2(ch,:) - nanmean(Macro2(ch,:));
end

%% Simple summing (no distance, etc. factored in)

%channels surrounding macro electrode 10
ch = [47 48 49 50 51 59 60 61 62 63 69 70 71 72 73 80 81 82 83 84 91 92 93 94 95 102 103 104 105 106];

for c = 1:size(ch,2)
    FullSurround(c,:) = micro(ch(c),:);
end

SimpleSum = sum(FullSurround,1);

%% downsample
for i = 1:size(clip,2)
    d = clip{i};
    for j = 1:size(ch,2)
        ds_d(i,j,:) = downsample(d(ch(j),:),(10000/1000));
    end
end

t1 = linspace(1,size(d,2),size(ds_d,2));
t2 = linspace(1,size(d,2),size(d,2));
figure; plot(t2,d); hold on; plot(t1,ds_d,'r')

%% Creating downsample object
nfftm = 2^nextpow2(size(micromin,2));
nfftM = 2^nextpow2(size(Macro2,2));
nfftm = 2^nextpow2(size(micro,2));
nfftM = 2^nextpow2(size(Macro2,2));
nfftdsm = 2^nextpow2(size(dsmicro,2));

fm = 10000/2*linspace(0,1,nfftm/2+1);
fM = 1000/2*linspace(0,1,nfftM/2+1);
fm = 10000/2*linspace(0,1,nfftm/2+1);
fM = 1000/2*linspace(0,1,nfftM/2+1);
fdsm = 1000/2*linspace(0,1,nfftdsm/2+1);


ftmicromin = fft(micro(71,:),nfftm)/size(micro,2);
ftMacromin = fft(Macro2(10,:),nfftM)/size(Macro2,2);
ftdsmicro = fft(dsmicro,nfftdsm)/size(dsmicro,2);
fty = fft(y,nfftm)/size(y,2);
ftdsy = fft(dsy, nfftdsm)/size(dsy,2);


figure; plot(fm,2*abs(ftmicromin(1:nfftm/2+1))); ylim([0 100]); xlim([0 50]); title('Micro 71');
figure; plot(fM,2*abs(ftMacromin(1:nfftM/2+1))); ylim([0 100]); xlim([0 100]); title('Macro 10');
figure; plot(fdsm,2*abs(ftdsmicro(1:nfftdsm/2+1))); ylim([0 100]); xlim([0 50]); title('downsampled micro 71');
figure; plot(fm,2*abs(fty(1:nfftm/2+1))); ylim([0 100]); xlim([0 100]); title('filtered micro 71');
figure; plot(fdsm,2*abs(ftdsy(1:nfftdsm/2+1))); ylim([0 100]); xlim([0 100]); title('filtered downsampled micro 71');

% Smooth criminal plots
figure; plot(fdsm,2*abs(ftdsy(1:nfftdsm/2+1))); hold on; plot(fdsm,smooth(2*abs(ftdsy(1:nfftdsm/2+1)),100), 'r'); hold off; ylim([0 100]); xlim([0 100]); title('filtered downsampled and smooth micro 71');
figure; plot(fM,2*abs(ftMacromin(1:nfftM/2+1))); hold on; plot(fM,smooth(2*abs(ftMacromin(1:nfftM/2+1)),100),'r'); hold off; ylim([0 100]); xlim([0 100]); title('Smooth Macro 10');


        %dsFs = desired/downsampled frequency
        dsFs = 1000;
        d = double(mclip2.Data);

        dsFs = 10000 / round(10000 / dsFs);
        if 10000 > dsFs
            N = 10;         % order
            Fst = 100;
            Fpass = 1; % Passband frequency
            Apass = 5;      % Passband ripple (dB)
            Astop = 50;     % Stopband attenuation (dB)
            h = fdesign.lowpass(Fpass,Fst,Apass,Astop,10000);
            Hd = design(h,'equiripple');
        else
            fprintf('Cannot downsample to this frequency, %d.\nChoose a different value.\n', dsFs)
            return
        end % END IF

        if dsFlag
            tempChan = filtfilt(Hd.sosMatrix,Hd.ScaleValues,tempChan);
            tempChan = tempChan(1:round(data.MetaTags.SamplingFreq/dsFs):end);
        end


%% Cross Correlation of neighboring macro electrodes

E9 = data(9,:);
E10 = data(10,:);
E6 = data(6,:);

[C9,lag1] = xcorr(E9,E10);
[C6,lag2] = xcorr(E6,E10);

figure
subplot(2,1,1);
plot(lag1,C9/max(C9));
ylabel('C9');
grid on
title('Cross-Correlations')
subplot(2,1,2);
plot(lag2,C6/max(C6));
ylabel('C6');
grid on
xlabel('Samples')

[~,I1] = max(abs(C9));     % Find the index of the highest peak
[~,I2] = max(abs(C6));     % Find the index of the highest peak
t9 = lag1(I1)              % Time difference between the signals s2,s1
t6 = lag2(I2)              % Time difference between the signals s3,s1

pad = zeros(abs(t9),1);
E9b = [pad' E9];
%E9 = E9(t109:end);
%E11 = E11(t1011:end);

figure
ax(1) = subplot(311);
plot(E10);
grid on;
title('E10');
axis tight
ax(2) = subplot(312);
plot(E9b);
grid on;
title('E9b');
axis tight
ax(3) = subplot(313);
plot(E6);
grid on;
title('E6');
axis tight
linkaxes(ax,'xy')


%% Cross Correlation of each individual micro to center macro (E10)

E10 = Macro2(10,:);

for c = 1:size(ch,2)
    d = downsample(micro(ch(c),:),10000/1000);
    [X,lag] = xcorr(d,E10);
    XC(ch(c),:) = X;
    Offset(ch(c),:) = lag;
    
    [~,Id(ch(c),:)] = max(abs(XC(ch(c),:)));     % Find the index of the highest peak
    t(ch(c),:) = Offset(ch(c),Id(ch(c)));
    
end

Id(Id == 0) =NaN;
for c = 1:size(ch,2)
    t(ch(c),:) = Offset(ch(c),Id(ch(c)));
end

%Positive value of t means micro preceeds macro (first variable in cross
%correlation preceeds second variable)
for c = 1:size(ch,2)
    
    if t(ch(c))>0
        shiftsig(ch(c),:) = micro(ch(c),(t(ch(c)):end));
    else pad = zeros(abs(t(ch(c))),1);
        shiftsig(ch(c),:) = [pad' micro(ch(c),:)];
    end
    
    pad = zeros(abs(t9),1);
    E9b = [pad' E9];
    %E9 = E9(t109:end);
    %E11 = E11(t1011:end);
    
    figure
    ax(1) = subplot(311);
    plot(E10);
    grid on;
    title('E10');
    axis tight
    ax(2) = subplot(312);
    plot(E9b);
    grid on;
    title('E9b');
    axis tight
    ax(3) = subplot(313);
    plot(E6);
    grid on;
    title('E6');
    axis tight
    linkaxes(ax,'xy')
    
    %% Correlation Coeff
    
    %Emat = [E9b(1:size(E10,2))' E10' E11'];
    
    Emat = [E6' E9' E10'];
    
    R = corrcoef(Emat)
    
    %% Spectrograms
    
    nfft = 2^nextpow2(500);
    ovlp = 40;
    window_2 = 50;
    [S1,F1,T1,P1] = spectrogram(E10,50,45,nfft,1000);
    
    %Plot the spectrogram
    figure;
    imagesc(T1,F1,(10*log10(P1)));
    caxis([0 60]);
    % imagesc(T1,F1,P1);
    axis xy; colorbar;
    h = colorbar;
    ylabel(h, 'Power Spectral Density (dB)');
    title('P3 Seizure Spectrogram');
    xlabel('Time(s)');
    ylabel('Freq(Hz)');
    xlim([0 600])
    ylim([0 100])
    hold on;line([266 266], [0 250]);
    %line([260 260], [0 250]);
    
    params.tapers = [1,5];
    params.pad = 2;
    params.Fs = 1000;
    params.Fs = 10000;
    
    
    [S,t,f]=mtspecgramc(micro(70,:),[2 1.75],params);
    [S,t,f]=mtspecgramc(SimpleSum,[2 1.75],params);
    [S,t,f]=mtspecgramc(E10,[2 1.75],params);
    
    figure
    colormap (jet); imagesc(t,f,(10*log10(S)'))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    
    %% subplot spectrograms
    
    params.tapers = [1,5];
    params.pad = 2;
    params.Fs = 10000;
    for c = 1:128
        [S(c,:,:),t(c,:),f(c,:)]=mtspecgramc(micro(c,:),[2 1.75],params);
    end
    
    figure;
    [S,t,f]=mtspecgramc(micro(47,:),[2 1.75],params);
    subplot(5,7,1)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    clear S t f
    
    [S,t,f]=mtspecgramc(micro(48,:),[2 1.75],params);
    subplot(5,7,2)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
        clear S t f

    
    [S,t,f]=mtspecgramc(micro(49,:),[2 1.75],params);
    subplot(5,7,3)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
        clear S t f

    
    [S(c,:,:),t(c,:),f(c,:)]=mtspecgramc(micro(50,:),[2 1.75],params);
    subplot(5,7,4)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);    
    clear S t f

    
    [S,t,f]=mtspecgramc(micro(51,:),[2 1.75],params);
    subplot(5,7,5)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    clear S t f
    
    [S,t,f]=mtspecgramc(micro(59,:),[2 1.75],params);
    subplot(5,7,6)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    clear S t f
    
    [S,t,f]=mtspecgramc(micro(60,:),[2 1.75],params);
    subplot(5,7,7)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    clear S t f
    
    [S,t,f]=mtspecgramc(micro(61,:),[2 1.75],params);
    subplot(5,7,8)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    clear S t f
    
    [S,t,f]=mtspecgramc(micro(62,:),[2 1.75],params);
    subplot(5,7,9)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    clear S t f
    
    [S,t,f]=mtspecgramc(micro(63,:),[2 1.75],params);
    subplot(5,7,10)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    clear S t f
    
    [S,t,f]=mtspecgramc(micro(69,:),[2 1.75],params);
    subplot(5,7,11)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    clear S t f
    
    [S,t,f]=mtspecgramc(micro(70,:),[2 1.75],params);
    subplot(5,7,12)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    clear S t f
    
    [S,t,f]=mtspecgramc(micro(71,:),[2 1.75],params);
    subplot(5,7,13)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    clear S t f
    
    [S,t,f]=mtspecgramc(micro(72,:),[2 1.75],params);
    subplot(5,7,14)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    clear S t f
    
    [S,t,f]=mtspecgramc(micro(73,:),[2 1.75],params);
    subplot(5,7,15)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    clear S t f
    
    [S,t,f]=mtspecgramc(E10,[2 1.75],params);
    subplot(5,7,18)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);      
    clear S t f
    
    [S,t,f]=mtspecgramc(micro(80,:),[2 1.75],params);
    subplot(5,7,21)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    clear S t f
    
    [S,t,f]=mtspecgramc(micro(81,:),[2 1.75],params);
    subplot(5,7,22)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    clear S t f
    
    [S,t,f]=mtspecgramc(micro(82,:),[2 1.75],params);
    subplot(5,7,23)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    clear S t f
    
    [S,t,f]=mtspecgramc(micro(83,:),[2 1.75],params);
    subplot(5,7,24)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    clear S t f
    
    [S,t,f]=mtspecgramc(micro(84,:),[2 1.75],params);
    subplot(5,7,25)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    clear S t f
    
    [S,t,f]=mtspecgramc(micro(84,:),[2 1.75],params);
    subplot(5,7,25)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    clear S t f
    
    [S,t,f]=mtspecgramc(micro(91,:),[2 1.75],params);
    subplot(5,7,26)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    clear S t f
    
    [S,t,f]=mtspecgramc(micro(92,:),[2 1.75],params);
    subplot(5,7,27)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    clear S t f
    
    [S,t,f]=mtspecgramc(micro(93,:),[2 1.75],params);
    subplot(5,7,28)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    clear S t f
    
    [S,t,f]=mtspecgramc(micro(94,:),[2 1.75],params);
    subplot(5,7,29)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    clear S t f
    
    [S,t,f]=mtspecgramc(micro(95,:),[2 1.75],params);
    subplot(5,7,30)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    clear S t f
    
    [S,t,f]=mtspecgramc(micro(102,:),[2 1.75],params);
    subplot(5,7,31)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    clear S t f
    
    [S,t,f]=mtspecgramc(micro(103,:),[2 1.75],params);
    subplot(5,7,32)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    clear S t f
    
    [S,t,f]=mtspecgramc(micro(104,:),[2 1.75],params);
    subplot(5,7,33)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    clear S t f
    
    [S,t,f]=mtspecgramc(micro(105,:),[2 1.75],params);
    subplot(5,7,34)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    clear S t f
    
    [S,t,f]=mtspecgramc(micro(106,:),[2 1.75],params);
    subplot(5,7,35)
    colormap (jet);
    imagesc(t,f,(10*log10(S)))
    axis xy; colorbar;
    caxis([0 80]);
    ylim([0 100]);
    clear S t f
    
%% Distances
% d1 = 2;
% d2 = 4.47;
% d3 = 6;
% d4 = 7.21;
% d5 = 8.25;
% d6 = 10;
% d7 = 10.77;
% d8 = 12.81;

%assume closest electrodes contribute whole signal, then partial based on
%distance (2/4.47, etc)
dist = [1 0.4474 0.3333 0.2774 0.2424 0.2 0.1857 0.1561];

%each row is a group of channels dx distance away
cir = {[71 82] [70 72 81 83] [61 93] [60 62 92 94] [69 73 80 84] [49 59 63 91 95 104] [48 50 103 105] [47 51 102 106]};

cirsum1 = micro(71,:) + micro(82,:);
cirsum2 = micro(70,:) + micro(72,:) + micro(81,:) + micro(83,:);
cirsum3 = micro(61,:) + micro(93,:);
cirsum4 = micro(60,:) + micro(62,:) + micro(92,:) + micro(94,:);
cirsum5 = micro(69,:) + micro(73,:) + micro(80,:) + micro(84,:);
cirsum6 = micro(49,:) + micro(59,:) + micro(63,:) + micro(91,:) + micro(95,:) + micro(104,:);
cirsum7 = micro(48,:) + micro(50,:) + micro(103,:) + micro(105,:);
cirsum8 = micro(47,:) + micro(51,:) + micro(102,:) + micro(106,:);

cirsum = [cirsum1; cirsum2; cirsum3; cirsum4; cirsum5; cirsum6; cirsum7; cirsum8];

ciravg = [cirsum1/2; cirsum2/4; cirsum3/2; cirsum4/4; cirsum5/4; cirsum6/6; cirsum7/4; cirsum8/4];

for i = 1:size(cir,2)
    for ii = 1:size(cir{i},2)
    
        
     distweighted((cir{i}(ii)),:) = micro((cir{i}(ii)),:)*dist(i);
    end
end

for c = 1:size(ch,2)
    FullSurround(c,:) = distweighted(ch(c),:);
end

distweightedsum = sum(FullSurround,1);
ds_distweightedsum = downsample(distweightedsum,10000/1000);
figure; plot(ds_distweightedsum)

%% %% Load data

micro = load('E:\data\human CNS\201101\KRA_Sfn2015\micro10minclip2.mat');
macro = load('E:\data\human CNS\201101\KRA_Sfn2015\Macro10minclip2.mat');

%List of micro channels surrounding macro electrode of interest
microelecs = [47 48 49 50 51 59 60 61 62 63 69 70 71 72 73 80 81 82 83 84 91 92 93 94 95 102 103 104 105 106];

%% Grouping channels

%each row is a group of channels dx distance away
grp = {[71 82] [70 72 81 83] [61 93] [60 62 92 94] [69 73 80 84] [49 59 63 91 95 104] [48 50 103 105] [47 51 102 106]};

for c = 1:size(grp,2)
    for ic = 1:size(grp{c},2)
        ide(ic,:)= micro.micro10mindata2((grp{c}(ic)),:);
    end
    grpsum(c,:) = sum(ide);
    grpavg(c,:) = grpsum(c,:)/size(grp{c},2);
    clear ide
end

clear c ic

%% Isolate 1min of data for testing

for c = 1:size(grp,2)
    micromin(c,:) = grpavg(c,(600000:1200000));
end

macro2min = macro.Macro2(10,(60000:180000));

clear c

%% Distance weighting - sum signals based on distance from macro

%List distances from center of macro electrode to center of micro
%electrodes
d = [2 4.47 6 7.21 8.25 10 10.77 12.81];

%assume closest electrodes contribute whole signal, then partial based on
%distance (2/4.47, etc)
for id = 1:size(d,2)
    dist(id,:) = d(1)/d(id);
end

for i = 1:size(grpavg,1)
    distweighted(i,:) = micromin(i,:)*dist(i);
end

distsum = sum(distweighted);

t = linspace(1,size(,2),size(distsum,2));
t2 = linspace(1,size(distsum,2),size(macromin,2));

[rows,~]=size(distsum);%# A is your matrix
colMax=max(abs(distsum),[],1);%# take max absolute value to account for negative numbers
micronorm=distsum./repmat(colMax,rows,1);

clear i id

%% Compare spectrograms of distance weighted micro signal and macro signal

nfft = 2^nextpow2(500);
window = 10;
ovlp = 8;

[sm,fm,tm,pm] = spectrogram(dsdist,window,ovlp,nfft,1000);
figure;
imagesc(tm,fm,(10*log10(pm)));
axis xy
colormap 'jet'; colorbar; caxis([0 60]); ylim([0 1000]);


[SM,FM,TM,PM] = spectrogram(macromin,window,ovlp,nfft,1000);
figure;
imagesc(TM,FM,(10*log10(PM)));
axis xy
colormap 'jet'; colorbar; caxis([0 60]); ylim([0 100]);



%% Remove line noise with comb filter

% Fs = 1000;  % Sampling Frequency
% N     = 1;  % Order
% BW    = 0.02;   % Bandwidth
% Apass = 1;   % Bandwidth Attenuation
% 
% fs = 600; fo = 60;  q = 35; bw = (fo/(fs/2))/q;
% [b,a] = iircomb(fs/fo,bw,'notch'); % Note type flag 'notch'
% 
% 
% dc  = fdesign.comb('notch','L,BW,GBW,Nsh',17,.04,-4,1,1000);
% Hdc = design(dc);
% 
% 
% for i = 1:size(grpavg,1)
%     DNgrpavg(i,:) = filter(Hdc,grpavg(i,:));
% end
% 
% clear dc Hdc i

%% Filter
%velocity factor = 1/sqrt(relative permittivity)
%brain has very large permittivity in low frequency
%low frequencies are affected more by damping/filtering 

f = [0 5 6 10 11 20 21 50 51 100];
b =  [1/10 2/10 3/10 4/10 5/10 6/10 7/10 8/10 9/10 1];

Fst = 120;      % Stopband frequency
Fpass = 100;    % Passband frequency
Apass = 5;      % Passband ripple (dB)
Astop = 50;     % Stopband attenuation (dB)


h = designfilt('lowpassfir','PassbandFrequency',Fpass,'StopbandFrequency',Fst,'PassbnadRibpple',5,'StopBandAttenuation',Astop,'DesignMethod','equiripple');

for i = 1:size(DNgrpavg,1)
    filtgrp(i,:) = filtfilt(Hd,DNgrpavg(i,:));
end

clear i h Hd

%% Downsample

for i = 1:size(filtgrp,1)
    dsgrp(i,:) = downsample(filtgrp(i,:),10000/1000);
end

clear i

%% FFT

%Define fft inputs for micro electrodes
nfft = 2^nextpow2(size(dsdist,2));
f = 1000/2*linspace(0,1,nfft/2+1);

%Apply fft to each grouping of microelectrodes
for i = 1:size(dsgrp,1)
    FFTgrp(i,:) = fft(dsgrp(i,:),nfft)/size(dsgrp,2);
end

FFTmicro = fft(dsdist,nfft)/size(dsdist,2);
%Apply fft to macroelectrode
FFTmacro = fft(macromin,nfft)/size(macromin,2);

clear i

%% Plot spectrums

figure; 
plot(f,2*abs(FFTmacro(1:nfft/2+1))); ylim([0 100]); xlim([0 500]); title('Macro 10');

figure; plot(f,2*abs(FFTmicro(1:nfft/2+1))); ylim([0 100]); xlim([0 500]); title('Micromin Grp 2');
figure; plot(f,2*abs(fftmicro(1:nfft/2+1))); ylim([0 200]); xlim([0 500]); title('Micromin Grp 2');

figure; 
for i = 1:size(FFTgrp,1)
    %figure;
    subplot(2,4,i)
    plot(f,2*abs(FFTgrp(i,(1:nfft/2+1)))); ylim([0 200]); xlim([0 500]); title(sprintf('Micro Group: %d', i));
end

%loglog plots

figure;
subplot(3,1,1); loglog(abs(FFTmicro),'.'); title('LogLog FFTmicro'); 
subplot(3,1,2); loglog(abs(FFTmacro),'r.'); title('LogLog FFTmacro'); 
subplot(3,1,3); loglog(abs(FFTmicro),'.');hold on; loglog(abs(FFTmacro),'r.');legend('FFTmicro','FFTmacro'); title('LogLog FFTmicro vs FFTmacro');


clear i

%% Cross correlation

for i = 1:size(dsgrp,1)
    [X(i,:),lag(i,:)] = xcorr(dsgrp(i,:),macro.Macro2(10,:));
    [~,I(i,:)] = max(abs(X(i,:))); %index of point of max correlation
    offset(i,:) = lag(i,:);  %time difference
          
end

[X,lag] = xcorr(dsdist,macrodt);
[~,I] = max(abs(X)); %index of point of max correlation
offset = lag(I);  
t= offset/1000;%time difference

figure
plot(lag,X/max(X));
ylabel('C9');
grid on
title('Cross-Correlations')

%Positive value of offset means micro preceeds macro (first variable in cross
%correlation preceeds second variable)
tm = linspace(0,size(dsdist,2)+abs(offset),(size(dsdist,2)+abs(offset)));
padmicro = padarray(dsdist,[0 abs(offset)],0,'post');
padmacro = padarray(macrodt,[0 abs(offset)],0,'pre');
figure
subplot(3,1,1)
plot(tm,padmicro);
grid on;
title('Micro');
axis tight
subplot(3,1,2)
plot(tm,padmacro);
grid on;
title('Macro');
axis tight
subplot(3,1,3)
plot(tm,padmicro); hold on; plot(tm,padmacro,'r');
grid on;
title('Micro vs Macro');
legend ('Micro','Macro');
axis tight

%% Cross correlation of normalized data
clear micro_norm macro_norm

micro_norm = (dsdist/(max(dsdist)));
macro_norm = (macrodt/(max(macrodt)));
 
figure;
subplot(3,1,1)
plot(micro_norm);
title('Normalized, Downsampled Micro Min')
subplot(3,1,2)
plot(macro_norm);
title('Normalized, Detrended Macro Min')
subplot(3,1,3);
plot(micro_norm); hold on; plot(macro_norm); hold off;
title('Normalized Micro vs Macro')
legend('Micro','Macro')

clear X lag I offset t
[X,lag] = xcorr(micro_norm,macro_norm);
[~,I] = max(abs(X)); %index of point of max correlation
offset = lag(I);  
t= offset/1000;%time difference

figure
plot(lag,X/max(X));
grid on
title('Cross-Correlations')

%Positive value of offset means micro preceeds macro (first variable in cross
%correlation preceeds second variable)
tm = linspace(0,size(micro_norm,2)+abs(offset),(size(micro_norm,2)+abs(offset)));
padmicro = padarray(micro_norm,[0 abs(offset)],0,'post');
padmacro = padarray(macro_norm,[0 abs(offset)],0,'pre');

figure
subplot(3,1,1)
plot(tm,padmicro);
grid on;
title('Normalized Micro');
axis tight
subplot(3,1,2)
plot(tm,padmacro);
grid on;
title('Normalized Macro');
axis tight
subplot(3,1,3)
plot(tm,padmicro); hold on; plot(tm,padmacro,'r');
grid on;
title('Micro vs Macro');
legend ('Micro','Macro');
axis tight

%% Coherence

%%

% % high-pass filter 
% order = 3;
% Rp = 3; % pass-band ripple in db
% Rs = 50; % stop-band attenuation in db
% Fc = 250; % cutoff frequency
% [z,p,k] = ellip(order,Rp,Rs,Fc/(Fs/2),'high');
% [SOS,G] = zp2sos(z,p,k);% convert to SOS structure to use filter analysis tool
% x_filt = filtfilt(SOS,G,x);


Fs = 10000; % sampling frequency
f = linspace(-Fs/2,Fs/2,size(distsum,2)); % Vector of frequencies to plot signals

% multi-taper power spectrum.
[pxx,f] = pmtm(distsum,9,nfft,Fs);

% multi-taper power spectrum.
macroFs = 1000;
[macrop,macrof] = pmtm(macromin,9,nfft,macroFs);

figure;
subplot(3,1,1)
loglog(f,pxx);
title('Micro');
xlim([10^0 10^4]);
xlabel('Freqency');
ylabel('Power')

subplot(3,1,2)
loglog(macrof,macrop);
title('Macro');
xlim([10^0 10^4]);
xlabel('Freqency');
ylabel('Power')

subplot(3,1,3)
loglog(f,pxx); hold on; loglog(macrof,macrop,'r');
title('Micro vs Macro');
legend ('Micro','Macro');
xlim([10^0 10^4]);
xlabel('Freqency');
ylabel('Power')


% % multi-taper power spectrum with 95% confidence bounds.
% tic;
% [pxx,f,pxxc] = pmtm(x,9,NFFT,Fs,'ConfidenceLevel',0.95);
% toc
% figure;
% loglog(f,pxx)
% hold on
% loglog(f,pxxc,'y-.')
% xlabel('Hz')
% ylabel('dB')
% title('Multitaper PSD Estimate with 95%-Confidence Bounds')



%% loglog with denoised micro bandpassed at 500
nfft = 2^nextpow2(size(macromin,2));
Fs = 10000; % sampling frequency
DNmicrof = linspace(-Fs/2,Fs/2,size(DNmicro,2)); % Vector of frequencies to plot signals


DNmicro = remln(distsum,10000);
% multi-taper power spectrum.
[DNmicrop,DNmicrof] = pmtm(DNmicro,9,nfft,Fs);

% multi-taper power spectrum.
macroFs = 1000;
[macrop,macrof] = pmtm(macromin,9,nfft,macroFs);

DNmacro = remln(macromin,1000);
macroFs = 1000;
[DNmacrop,DNmacrof] = pmtm(DNmacro,9,nfft,macroFs);

idf = find(DNmicrof<=500);

figure;
subplot(3,1,1)
loglog(DNmicrof(idf),DNmicrop(idf));
title('Denoised Micro');
xlim([10^0 10^3]);
ylim([10^-5 10^7]);
xlabel('Freqency');
ylabel('Power')

subplot(3,1,2)
%loglog(macrof,macrop,'r');
loglog(DNmacrof,DNmacrop,'r');
title('Denoised Macro');
xlim([10^0 10^3]);
ylim([10^-5 10^7]);
xlabel('Freqency');
ylabel('Power')

subplot(3,1,3)
%loglog(DNmicrof(idf),DNmicrop(idf)); hold on; loglog(macrof,macrop,'r');
loglog(DNmicrof(idf),DNmicrop(idf)); hold on; loglog(DNmacrof,DNmacrop,'r');
title('Denoised Micro vs Macro');
%title('Micro vs Macro');
legend ('DNMicro','DNMacro');
xlim([10^0 10^3]);
ylim([10^-5 10^7]);
xlabel('Freqency');
ylabel('Power')

%%

m = micro.micro10mindata2((1:128),(600000:1200000));
[r,p] = corrcoef(m');


params.tapers = [1,5];
params.pad = 2;
params.Fs = 1000;
[S,t,f]=mtspecgramc(dsmicrodt,[1 0.75],params);
figure
colormap (jet); imagesc(t,f,(10*log10(S)'))
axis xy; colorbar;
caxis([0 80]);
ylim([0 100]);

params.tapers = [1,5];
params.pad = 2;
params.Fs = 1000;
[S,t,f]=mtspecgramc(macro2min,[1 0.75],params);
figure
colormap (jet); imagesc(t,f,(10*log10(S)'))
axis xy; colorbar;
caxis([0 80]);
ylim([0 100]);


