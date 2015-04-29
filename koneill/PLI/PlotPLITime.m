timeMax = size(p,1);
sizeMax = Header.Fs*timeMax;
figure(1)

data = DNdata;

desiredChanRef = 1;

% for ii = 1:size(chanPairNums,1)
close all
%     chan1 = chanPairNums(ii,1);
%     chan2 = chanPairNums(ii,2);\

%     if ii < desiredChanRef
%         chan1 = ii;
%         chan2 = desiredChanRef;
%     else
%         chan1 = desiredChanRef;
%         chan2 = ii;
%     end

chan1 = 9;
chan2 = 64;

if ~(ii == desiredChanRef)
    a1=subplot(3,1,1);
    plot(linspace(1,timeMax/60,sizeMax), data(chan1, 1:sizeMax));
    title(sprintf('Raw waveform, channel: %d', chan1))
    
    a2 = subplot(3,1,2);
    plot(linspace(1,timeMax/60,sizeMax), data(chan2, 1:sizeMax));
    title(sprintf('Raw waveform, channel: %d', chan2))
    
    a3 = subplot(3,1,3);
    idx2 = find((chanPairNums(:,1) == chan1 & chanPairNums(:,2) == chan2)==1);
    h=plot(linspace(1,timeMax/60,size(p,1)), p(:, idx));
    title(sprintf('Raw PLI, channels: %d - %d', chan1, chan2))
    
    linkaxes([a1,a2,a3], 'x')
    movegui(h,'west')
    
    figure(2)
    b1=subplot(3,1,1);
    idx = find((chanPairNums(:,1) == chan1 & chanPairNums(:,2) == chan2)==1);
    plot(linspace(1,timeMax/60,size(p,1)), smooth(p(:, idx)))
    title(sprintf('Window Average (5 samp) PLI, channels: %d - %d', chan1, chan2))
    
    b2=subplot(3,1,2);
    idx = find((chanPairNums(:,1) == chan1 & chanPairNums(:,2) == chan2)==1);
    plotData = p(:,idx) - smooth(p(:,idx));
    plot(linspace(1,timeMax/60,size(p,1)), plotData)
    title(sprintf('Average Removed (5 samp) PLI, channels: %d - %d', chan1, chan2))
    
    b3=subplot(3,1,3);
    idx = find((chanPairNums(:,1) == chan1 & chanPairNums(:,2) == chan2)==1);
    plotData = p(:,idx) - smooth(p(:,idx));
    varData = SmoothVar(plotData);
    h=plot(linspace(1,timeMax/60,size(p,1)), varData);
    title(sprintf('Varience of Avg Removed (5 samp) PLI, channels: %d - %d', chan1, chan2))
    
    linkaxes([b1,b2,b3], 'x')
    movegui(h,'center')
    fprintf('Chan1: %d\tChan2: %d\n', chan1, chan2);
    %         pause
end

% end % END FOR

%% Render GIF

desiredChanPairs = nchoosek(sort(unique(1:64),'ascend'),2);

idx = zeros(size(chanPairNums,1),1);

% Find idicies
for jj = 1:size(desiredChanPairs,1)
    idx = idx | ((chanPairNums(:,1) == desiredChanPairs(jj,1)) & (chanPairNums(:,2) == desiredChanPairs(jj,2)));
end

%%
% fileName = '2014PP07Sz4_DN_GIF.gif';
% g.layout = reshape([1:64]', 8, 8);
% g.subject = '2014PP02Sz2_DN';
% g.badchan = [];
%
% pathName = 'E:\data\PLI\EMDData\Figures';
%
% p2 = p(:,idx);
% chanPairs = chanPairNums(idx,:);
%
seconds = 1;
minutes = 0;
% mapCol = jet(128);
time = '00:00';
for ii = 1:600%size(p,1)
    disp(ii)
    %     PlotPLIEvo(pathName, g, p2(ii,:), chanPairs, 'space-invader', mapCol);
    
    if ~mod(ii,60)
        minutes = minutes+1;
        if minutes >= 10
            time(1:2) = num2str(minutes);
        else
            time(2) = num2str(minutes);
        end
    end
    
    seconds = ii - minutes*60;
    if seconds >= 10
        time(4:5) = num2str(seconds);
    else
        time(4:5) = ['0',num2str(seconds)];
    end
    
    timeStr{ii} = time;
    
    %     disp(time)
    %     title(sprintf('%s: %s', g.subject, time))
    %     drawnow
    
    %     frame = getframe(1);
    %     im = frame2im(frame);
    %     [imind,cm] = rgb2ind(im,256);
    %     if ii == 1;
    %         imwrite(imind,cm,fullfile(pathName,fileName),'gif','Loopcount',inf);
    %     else
    %         imwrite(imind,cm,fullfile(pathName,fileName),'gif','WriteMode','append');
    %     end
    
    
end % END FOR size p

%%
% for ii = 1:1%600      % N is the number of frames
%     image = imread('E:\data\PLI\EMDData\Figures\2014PP07Sz4_DN_GIF.GIF', 1:3);
%
%     image = allframedata(:,:,:,ii);
%     filename = fullfile('E:\data\PLI\EMDData\Figures\2014PP07Sz4_DN_GIFImages', ['2014PP07Sz4_DN_GIF_',num2str(ii), '.png']);
%     imwrite(image, filename);
% end

%% 8x8 Grid on Self Mean

PLIList{1} = {'E:\data\PLI\EMDData\2012PP05NonSz5_DN.mat_PLI_winSize1.mat'};
PLIList{2} = {'E:\data\PLI\EMDData\2012PP05Sz7_DN.mat_PLI_winSize1.mat'};
PLIList{3} = {'E:\data\PLI\EMDData\2014PP01NonSz1_DN.mat_PLI_winSize1.mat'};
PLIList{4} = {'E:\data\PLI\EMDData\2014PP01Sz1_DN.mat_PLI_winSize1.mat'};
PLIList{5} = {'E:\data\PLI\EMDData\2014PP01NonSz7_DN.mat_PLI_winSize1.mat'};
PLIList{6} = {'E:\data\PLI\EMDData\2014PP01Sz7_DN.mat_PLI_winSize1.mat'};
PLIList{7} = {'E:\data\PLI\EMDData\2014PP02NonSz4_DN.mat_PLI_winSize1.mat'};
PLIList{8} = {'E:\data\PLI\EMDData\2014PP02Sz4_DN.mat_PLI_winSize1.mat'};
PLIList{9} = {'E:\data\PLI\EMDData\2014PP02NonSz4_DN.mat_PLI_winSize1.mat'};
PLIList{10}= {'E:\data\PLI\EMDData\2014PP07Sz4_DN.mat_PLI_winSize1.mat'};

EMDList{1} = {'E:\data\human CNS\EMD\NonSz\ProcData\DN\2012PP05NonSz5_DN.mat'};
EMDList{2} = {'E:\data\human CNS\EMD\Sz\ProcData\DN\2012PP05Sz7_DN.mat'};
EMDList{3} = {'E:\data\human CNS\EMD\NonSz\ProcData\DN\2014PP01NonSz1_DN.mat'};
EMDList{4} = {'E:\data\human CNS\EMD\Sz\ProcData\DN\2014PP01Sz1_DN.mat'};
EMDList{5} = {'E:\data\human CNS\EMD\NonSz\ProcData\DN\2014PP01NonSz7_DN.mat'};
EMDList{6} = {'E:\data\human CNS\EMD\Sz\ProcData\DN\2014PP01Sz7_DN.mat'};
EMDList{7} = {'E:\data\human CNS\EMD\NonSz\ProcData\DN\2014PP02NonSz4_DN.mat'};
EMDList{8} = {'E:\data\human CNS\EMD\Sz\ProcData\DN\2014PP02Sz4_DN.mat'};
EMDList{9} = {'E:\data\human CNS\EMD\NonSz\ProcData\DN\2014PP07NonSz4_DN.mat'};
EMDList{10}= {'E:\data\human CNS\EMD\Sz\ProcData\DN\2014PP07Sz4_DN.mat'};

names = {'2012PP05Sz7_NonSz5', '2014PP01Sz1_NonSz1', '2014PP01Sz7_NonSz7', '2014PP02NonSz4_NonSz4','2014PP07NonSz4_NonSz4'};
ref = [9, 9, 82, 82, 82, 82, 5, 5, 43, 43];
for kk = 1:size(PLIList,2)
    
    if ~~mod(kk,2)
        figure;
    end
    
    load(PLIList{kk}{1})
    load(EMDList{kk}{1})
    
    % Find Idx
    desiredChanPairs = nchoosek(sort(unique(1:64),'ascend'),2);
    idx = zeros(size(chanPairNums,1),1);
    % Find idicies
    for jj = 1:size(desiredChanPairs,1)
        idx = idx | ((chanPairNums(:,1) == desiredChanPairs(jj,1)) & (chanPairNums(:,2) == desiredChanPairs(jj,2)));
    end
    
    % Calc Whole grid mean and std err
    smoothP = zeros(size(p,1), sum(idx));
    
    for ii = 1:sum(idx)
        smoothP(:,ii) = smooth(p(:,ii));
    end % END FOR
    
    gridErr = std(smoothP, 0, 2);
    gridErr = gridErr/sqrt(sum(idx)); % Standard error
    gridErr = 2*gridErr; % 2*standard error.
    
    
    gridMean2 = mean(smoothP,2);
    
    timeMax = size(p,1);
    sizeMax = Header.Fs*timeMax;
    
    
    x = linspace(0,timeMax/60,size(p,1));
    xx = [x, fliplr(x)];
    
    patchdata =  [[gridMean2 + gridErr]', fliplr([gridMean2 - gridErr]')];
    
    if ~~mod(kk,2)
        meanBG = mean(gridMean2);
        stdBG =  std(gridMean2);
    end
    
    subplot(2,2,~mod(kk,2)+1)
    hold on
    plot([0,0], [0,0], 'r') % Legend Stuff
    plot([0,0], [0,0], 'k') % Legned stuff
    pData = patch(xx, patchdata, 1);
    lData = plot(x, gridMean2, 'b', 'linewidth', 1);
    plot(x, repmat(meanBG + stdBG, 1,size(p,1)), 'k')
    plot(x, repmat(meanBG, 1,size(p,1)), 'r')
    plot(x, repmat(meanBG - stdBG, 1,size(p,1)), 'k')
    hold off
    ylim([0,1])
    xlim([0,10])
    xlabel('Time, minutes')
    ylabel('PLI')
    legend({'Mean, NonSz', '1 std of mean, NonSz'})
    
    if ~~mod(kk,2)
        title(strrep(sprintf('%s: Non-Seizure', names{sum(~~mod(1:kk,2))}), '_', '\_'))
    else
        title(strrep(sprintf('%s: Seizure', names{sum(~~mod(1:kk,2))}), '_', '\_'))
    end
    set(pData, 'FaceColor', 'k')
    set(pData, 'EdgeColor', 'none')
    set(pData, 'FaceAlpha', 0.25)
    set(gca, 'XTick', [0:10])
    
    %     if ~~mod(kk,2)
    %         data = DNdata;
    %     end
    desiredRef = ref(kk);
    subplot(2,2,~mod(kk,2)+3)
    plot(linspace(0,timeMax/60,sizeMax), data(desiredRef, 1:sizeMax));
    title(sprintf('Raw waveform, channel: %d', desiredRef))
    xlabel('Time, minutes')
    ylabel('Voltage, uV')
    set(gca, 'XTick', [0:10])
    
end % END FOR
%% Depth on Depth (2014PP02, AIN)

chanAIN = 65:70;
% Find Idx
desiredChanPairs = nchoosek(sort(unique(chanAIN),'ascend'),2);
idx = zeros(size(chanPairNums,1),1);
% Find idicies
for jj = 1:size(desiredChanPairs,1)
    idx = idx | ((chanPairNums(:,1) == desiredChanPairs(jj,1)) & (chanPairNums(:,2) == desiredChanPairs(jj,2)));
end

% Calc Whole grid mean and std err
gridMean = mean(p(:,idx),2);
smoothP = zeros(size(p,1), sum(idx));

for ii = 1:sum(idx)
    smoothP(:,ii) = smooth(p(:,ii));
end % END FOR

gridErr = std(smoothP, 0, 2);
gridErr = gridErr/sqrt(sum(idx)); % Standard error
gridErr = 2*gridErr; % 2*standard error.

gridMean2 = mean(smoothP,2);

timeMax = size(p,1);
sizeMax = Header.Fs*timeMax;

x = linspace(1,timeMax/60,size(p,1));
xx = [x, fliplr(x)];

patchdata =  [[gridMean2 + gridErr]', fliplr([gridMean2 - gridErr]')];

figure(1)
hold on
% lData = plot(x, gridMean, 'b');
pData = patch(xx, patchdata, 1);
lData = plot(x, gridMean2, 'b', 'linewidth', 1);
plot(x, repmat(mean(gridMean2) + std(gridMean2), 1,size(p,1)), 'k')
plot(x, repmat(mean(gridMean2) - std(gridMean2), 1,size(p,1)), 'k')
plot(x, repmat(mean(gridMean2), 1,size(p,1)), 'r')
% plot(smooth(gridMean2), 'g')
hold off

set(pData, 'FaceColor', 'k')
set(pData, 'EdgeColor', 'none')
set(pData, 'FaceAlpha', 0.25)

% xlabel('

data = DNdata;
desiredRef = 69;
figure(2)
plot(linspace(1,timeMax/60,sizeMax), data(desiredRef, 1:sizeMax));
title(sprintf('Raw waveform, channel: %d', desiredRef))

%% Depth on Grid

%% PLI Spectrogram

PLIList{1} = {'E:\data\PLI\EMDData\2012PP05NonSz5_DN.mat_PLI_winSize1.mat'};
PLIList{2} = {'E:\data\PLI\EMDData\2012PP05Sz7_DN.mat_PLI_winSize1.mat'};
PLIList{3} = {'E:\data\PLI\EMDData\2014PP01NonSz1_DN.mat_PLI_winSize1.mat'};
PLIList{4} = {'E:\data\PLI\EMDData\2014PP01Sz1_DN.mat_PLI_winSize1.mat'};
PLIList{5} = {'E:\data\PLI\EMDData\2014PP01NonSz7_DN.mat_PLI_winSize1.mat'};
PLIList{6} = {'E:\data\PLI\EMDData\2014PP01Sz7_DN.mat_PLI_winSize1.mat'};
PLIList{7} = {'E:\data\PLI\EMDData\2014PP02NonSz4_DN.mat_PLI_winSize1.mat'};
PLIList{8} = {'E:\data\PLI\EMDData\2014PP02Sz4_DN.mat_PLI_winSize1.mat'};
PLIList{9} = {'E:\data\PLI\EMDData\2014PP02NonSz4_DN.mat_PLI_winSize1.mat'};
PLIList{10}= {'E:\data\PLI\EMDData\2014PP07Sz4_DN.mat_PLI_winSize1.mat'};

EMDList{1} = {'E:\data\human CNS\EMD\NonSz\ProcData\DN\2012PP05NonSz5_DN.mat'};
EMDList{2} = {'E:\data\human CNS\EMD\Sz\ProcData\DN\2012PP05Sz7_DN.mat'};
EMDList{3} = {'E:\data\human CNS\EMD\NonSz\ProcData\DN\2014PP01NonSz1_DN.mat'};
EMDList{4} = {'E:\data\human CNS\EMD\Sz\ProcData\DN\2014PP01Sz1_DN.mat'};
EMDList{5} = {'E:\data\human CNS\EMD\NonSz\ProcData\DN\2014PP01NonSz7_DN.mat'};
EMDList{6} = {'E:\data\human CNS\EMD\Sz\ProcData\DN\2014PP01Sz7_DN.mat'};
EMDList{7} = {'E:\data\human CNS\EMD\NonSz\ProcData\DN\2014PP02NonSz4_DN.mat'};
EMDList{8} = {'E:\data\human CNS\EMD\Sz\ProcData\DN\2014PP02Sz4_DN.mat'};
EMDList{9} = {'E:\data\human CNS\EMD\NonSz\ProcData\DN\2014PP07NonSz4_DN.mat'};
EMDList{10}= {'E:\data\human CNS\EMD\Sz\ProcData\DN\2014PP07Sz4_DN.mat'};

names = {'2012PP05Sz7_NonSz5', '2014PP01Sz1_NonSz1', '2014PP01Sz7_NonSz7', '2014PP02NonSz4_NonSz4','2014PP07NonSz4_NonSz4'};
% ref = [9, 9, 82, 82, 82, 82, 5, 5, 43, 43];


for kk = 1:size(PLIList,2)
    
    if ~~mod(kk,2)
        figure;
    end
    
    load(PLIList{kk}{1})
    load(EMDList{kk}{1})
    
    % Find Idx
    desiredChanPairs = nchoosek(sort(unique(1:64),'ascend'),2);
    idx = zeros(size(chanPairNums,1),1);
    % Find idicies
    for jj = 1:size(desiredChanPairs,1)
        idx = idx | ((chanPairNums(:,1) == desiredChanPairs(jj,1)) & (chanPairNums(:,2) == desiredChanPairs(jj,2)));
    end
    
    % Calc Whole grid mean and std err
    smoothP = zeros(size(p,1), sum(idx));
    
    for ii = 1:sum(idx)
        %         smoothP(:,ii) = p(:,ii);
        smoothP(:,ii) = smooth(p(:,ii));
    end % END FOR
    
    gridErr = std(smoothP, 0, 2);
    gridErr = gridErr/sqrt(sum(idx)); % Standard error
    gridErr = 2*gridErr; % 2*standard error.
    
    
    gridMean2 = mean(smoothP,2);
    
    timeMax = size(p,1);
    sizeMax = Header.Fs*timeMax;
    
    
    x = linspace(0,timeMax/60,size(p,1));
    xx = [x, fliplr(x)];
    
    patchdata =  [[gridMean2 + gridErr]', fliplr([gridMean2 - gridErr]')];
    
    if ~~mod(kk,2)
        meanBG = mean(gridMean2);
        stdBG =  std(gridMean2);
    end
    
    subplot(2,2,~mod(kk,2)+1)
    hold on
    plot([0,0], [0,0], 'r') % Legend Stuff
    plot([0,0], [0,0], 'k') % Legned stuff
    pData = patch(xx, patchdata, 1);
    lData = plot(x, gridMean2, 'b', 'linewidth', 1);
    plot(x, repmat(meanBG + stdBG, 1,size(p,1)), 'k')
    plot(x, repmat(meanBG, 1,size(p,1)), 'r')
    plot(x, repmat(meanBG - stdBG, 1,size(p,1)), 'k')
    hold off
    ylim([0,1])
    xlim([0,10])
    xlabel('Time, minutes')
    ylabel('PLI')
    legend({'Mean, NonSz', '1 std of mean, NonSz'})
    
    if ~~mod(kk,2)
        title(strrep(sprintf('%s: Non-Seizure', names{sum(~~mod(1:kk,2))}), '_', '\_'))
    else
        title(strrep(sprintf('%s: Seizure', names{sum(~~mod(1:kk,2))}), '_', '\_'))
    end
    set(pData, 'FaceColor', 'k')
    set(pData, 'EdgeColor', 'none')
    set(pData, 'FaceAlpha', 0.25)
    set(gca, 'XTick', [0:10])
    
    drawnow
    params.tapers = [2,10];
    params.Fs = 60;
    
    [S,t,f]=mtspecgramc(gridMean2,[1,0.1],params);
    colormap(jet)
    subplot(2,2,~mod(kk,2)+3)
    imagesc(t,f,S')
    
    xlabel('Time, minutes')
    ylabel('PLI Frequency')
    set(gca, 'XTick', [0:10])
    set(gca,'YDir','normal');
    drawnow
    
    %     if ~~mod(kk,2)
    %         data = DNdata;
    %     end
    %     desiredRef = ref(kk);
    
    %     plot(linspace(0,timeMax/60,sizeMax), data(desiredRef, 1:sizeMax));
    %     title(sprintf('Raw waveform, channel: %d', desiredRef))
    %     xlabel('Time, minutes')
    %     ylabel('Voltage, uV')
    %     set(gca, 'XTick', [0:10])
    %
end % END FOR

%% FFT
L = size(gridMean2,1);
Fs = 100;
y = gridMean2*10;

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1)))
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

%% spectrogram

[s, w, t, p2] = spectrogram(gridMean2, 10,8,16,60);

imagesc(t,w,10*log10(p2))

% imagesc(t,w,s')


%% Find index

desiredChan = 23;
desiredBound = [1,64];

idxXC = zeros(size(p,2),1);

idxXC = idxXC | (chanPairNums(:,1) == desiredChan | chanPairNums(:,2) == desiredChan);

idxXC = idxXC & ((chanPairNums(:,1) >= desiredBound(1) & chanPairNums(:,1) <= desiredBound(2)) &...
    (chanPairNums(:,2) >= desiredBound(1) & chanPairNums(:,2) <= desiredBound(2)));

%% Cross correlation with Delay

xcVals = zeros(size(p,2),1);
xcLags = zeros(size(p,2),1);

for ii = 1:size(p,2)
    
    [corVal, lagVal] = xcorr(gridMean2, smooth(p(:,ii)));
    
    xcVals(ii) = max(corVal);
    xcLags(ii) = lagVal(corVal == max(corVal));
    
    
end % END FOR

%% Chan Pairs at delay
idxXC2 = idxXC & xcLags~=0;
delayChan = chanPairNums(idxXC2,:);
delayVal = xcLags(idxXC2);
colormap(hot)
gridMat = zeros(8,8);
layout = reshape(1:64,8,8);
gridMat(desiredChan) = 10;
for jj = 1:size(delayVal,1)
    if delayChan(jj,1) == desiredChan
        gridMat(delayChan(jj,2)) = delayVal(jj);
    else
        gridMat(delayChan(jj,1)) = delayVal(jj);
    end
    
end % END FOR

imagesc(gridMat)


%% Plot Long Form Data

ref = [5];
biPolarRef = (ref+1)/2;

chansPlot = [1:32];

% Find Idx
desiredChanPairs = nchoosek(sort(unique(chansPlot),'ascend'),2);
idx = zeros(size(chanPairNums,1),1);
% Find idicies
for jj = 1:size(desiredChanPairs,1)
    idx = idx | ((chanPairNums(:,1) == desiredChanPairs(jj,1)) & (chanPairNums(:,2) == desiredChanPairs(jj,2)));
end

% Calc Whole grid mean and std err
smoothP = zeros(size(p,1), sum(idx));

for ii = 1:sum(idx)
    %         smoothP(:,ii) = p(:,ii);
    smoothP(:,ii) = smooth(p(:,ii));
end % END FOR

gridErr = std(smoothP, 0, 2);
gridErr = gridErr/sqrt(sum(idx)); % Standard error
gridErr = 2*gridErr; % 2*standard error.


gridMean2 = mean(smoothP,2);

timeMax = size(p,1);
sizeMax = Header.Fs*timeMax;


x = linspace(0,timeMax/60,size(p,1));
xx = [x, fliplr(x)];

patchdata =  [[gridMean2 + gridErr]', fliplr([gridMean2 - gridErr]')];

meanBG = mean(gridMean2);
stdBG =  std(gridMean2);

a1 = subplot(4,1,1);
hold on
plot([0,0], [0,0], 'r') % Legend Stuff
plot([0,0], [0,0], 'k') % Legned stuff
pData = patch(xx, patchdata, 1);
lData = plot(x, gridMean2, 'b', 'linewidth', 1);
plot(x, repmat(meanBG + stdBG, 1,size(p,1)), 'k')
plot(x, repmat(meanBG, 1,size(p,1)), 'r')
plot(x, repmat(meanBG - stdBG, 1,size(p,1)), 'k')
hold off
ylim([0,1])
xlim([0,x(end)])
xlabel('Time, minutes')
ylabel('PLI')
legend({'Mean, NonSz', '1 std of mean, NonSz'}, 'location', 'North')

title(strrep(sprintf('Long Form Data: 2014PP02 BiPolar'), '_', '\_'))

set(pData, 'FaceColor', 'k')
set(pData, 'EdgeColor', 'none')
set(pData, 'FaceAlpha', 0.25)
set(gca, 'XTick', unique([0:10:x(end), x(end)]))

% Spectrum
a2 = subplot(4,1,2);

params.tapers = [2,10];
params.Fs = 60;

[S,t,f]=mtspecgramc(gridMean2,[1,0.1],params);
colormap(jet)

imagesc(t,f,S')

xlabel('Time, minutes')
ylabel('PLI Frequency')
set(gca, 'XTick', unique([0:10:x(end), x(end)]))
set(gca,'YDir','normal');
xlim([0,x(end)])

% Power-Time
colormap(jet)
a3 = subplot(4,1,3);

plot(linspace(0,timeMax/60,size(S,1)), S(:,1), 'r')
hold on
plot(linspace(0,timeMax/60,size(S,1)),S(:,2),'g')
plot(linspace(0,timeMax/60,size(S,1)),S(:,3),'c')
plot(linspace(0,timeMax/60,size(S,1)),S(:,4),'b')
plot(linspace(0,timeMax/60,size(S,1)),S(:,5),'m')
hold off

title('Spectrum Power')
xlabel('Time, minutes')
ylabel('Power')
set(gca, 'XTick', unique([0:10:x(end), x(end)]))
xlim([0,x(end)])

legend(num2str(f(1:5)), 'Location', 'North')

% Votlage
a4 = subplot(4,1,4);
% desiredRef = ref;
desiredRef = biPolarRef;

plot(linspace(0,timeMax/60,sizeMax), data(desiredRef, 1:sizeMax));
title(sprintf('Raw waveform, channel: %d-%d', desiredRef*2-1, desiredRef*2))
xlabel('Time, minutes')
ylabel('Voltage, uV')
set(gca, 'XTick', unique([0:10:x(end), x(end)]))
xlim([0,x(end)])

linkaxes([a1,a2,a3, a4], 'x')