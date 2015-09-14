% load('E:\data\PLI\delta\PLIOutput\Delta_ProcessedTrialData.mat')

%% Raw data
timeRaw = linspace(-1.5,2,size(data,1));
figure;
subplot(2,1,1)
plot(timeRaw, data(:,2,1));
title('Raw data from channels 2 and 17')

subplot(2,1,2)
plot(timeRaw, data(:,17,1));
xlabel('Time, s')


%% Coherence
nfft = 2^nextpow2(17500);
Fs = 5000;

[Pxy,F] = mscohere(data(:,1,850),data(:,2,850),hamming(100),90,nfft,Fs);

figure;
plot(F,Pxy)
title('Magnitude-Squared Coherence')
xlabel('Frequency (Hz)')
grid

ylim([0,1])

%% Phase
nfft = 2^nextpow2(17500);
Fs = 5000;

[Cxy,F] = cpsd(data(:,1,1),data(:,2,1),hamming(100),80,nfft,Fs);

figure;
plot(F,-angle(Cxy)/pi)
title('Cross Spectrum Phase')
xlabel('Frequency (Hz)')
ylabel('Lag (\times\pi rad)')
grid
ylim([-1,1])

%% DeltaPhi

% instantaneous phase
maxData = max(data(:));
minData = min(data(:));

tmpData1 = detrend(data(:,1,1));
tmpData2 = detrend(data(:,16,1));
% 
% tmpData1 = reshape(tmpData1, 700, 25);
% tmpData2 = reshape(tmpData2, 700, 25);

% tmpData1 = (data(:,2,1) - minData)./maxData;
% tmpData2 = (data(:,17,1) - minData)./maxData;
% tmpData2 = (data(:,17,1) - minData);

% tmpData1 = (data(:,2,1)-minData);
% tmpData2 = (data(:,17,1));

% [Amp1,Freq1,Ph1]=getHilbVals(tmpData1,5000,1);
% [Amp2,Freq2,Ph2]=getHilbVals(tmpData2,5000,1);

% phi1 = atan2(imag(hilbert(tmpData1)), tmpData1);
% phi2 = atan2(imag(hilbert(tmpData2)), tmpData2);

phi1 = angle(hilbert(tmpData1));
phi2 = angle(hilbert(tmpData2));

% phi1 = atan(imag(hilbert(tmpData1)) ./ tmpData1);
% phi2 = atan(imag(hilbert(tmpData2)) ./tmpData2);

% instantaneous phase difference
deltaPhi = phi2 - phi1;


% deltaPhi(deltaPhi >= 2*pi) = deltaPhi(deltaPhi >= 2*pi) - 2*pi;
deltaPhi(deltaPhi < 0) = deltaPhi(deltaPhi < 0) + 2*pi;
% testPhi = diff(unwrap(deltaPhi(:)));
% testPhi(testPhi < 0) = testPhi(testPhi < 0) + 2*pi;

timeDeltaPhi = linspace(-1.5,2,size(data,1));
figure;
plot(timeDeltaPhi,deltaPhi(:))
ylabel('Delta Phi')
xlabel('Time, s')
title('DeltaPhi')
% ylim([-pi, pi])

%% Plot original signals based on DeltaPhi

colMap = RainbowColormap();
% deltaPhi = phi2 - phi1;
timeDeltaPhi = linspace(-1.5,2,size(data,1));

adjustedPhi1 = phi1 + pi;
adjustedPhi1 = adjustedPhi1 ./ (2*pi);

adjustedPhi2 = phi2 + 2*pi;
adjustedPhi2 = adjustedPhi2 ./ (4*pi);

adjustedDeltaPhi = deltaPhi + 0;
adjustedDeltaPhi = adjustedDeltaPhi ./ (2*pi);


figure;
ax1 = subplot(2,1,1);

pointColor = floor(adjustedDeltaPhi*size(colMap,1));
colormap(colMap)
scatter([1,1,1:length(tmpData1)],[0;0;data(:,2,1)], 5, [1;600;pointColor], 'filled');
% cBar = colorbar('peer', gca,'Ticks', [-pi, -pi/2, 0, pi/2, pi], ...
%                 'TickLabels', [-pi, -pi/2, 0, pi/2, pi]);
cBar = colorbar('Ticks', [1, 150, 300, 450, 600],...
                'TickLabels', {'0', 'pi/2', 'pi', '3*pi/2', '2*pi'});
cBar.Label.String = 'Delta Phi';
cBar.Limits = [1,600];


ax2 = subplot(2,1,2);
pointColor = floor(adjustedDeltaPhi*size(colMap,1));
colormap(colMap)
scatter([1,1,1:length(tmpData2)],[0;0;data(:,2,1)], 5, [1;600;pointColor], 'filled');
% cBar = colorbar('peer', gca,'Ticks', [-pi, -pi/2, 0, pi/2, pi], ...
%                 'TickLabels', [-pi, -pi/2, 0, pi/2, pi]);
cBar = colorbar('Ticks', [1, 150, 300, 450, 600],...
                'TickLabels', {'0', 'pi/2', 'pi', '3*pi/2', '2*pi'});
cBar.Label.String = 'Delta Phi';
cBar.Limits = [1,600];
linkaxes([ax1,ax2], 'x');

% for kk = 1:size(data,1)
%     
% %     (timeDeltaPhi(kk), data(kk,1,1), 'Marker', '.', 'MarkerSize', 5, 'MarkerFaceColor', pointColor) 
% end % END FOR
% 

% 
% for kk = 1:size(data,1)
%     pointColor = colMap(floor(adjustedDeltaPhi(kk)*size(colMap,1)),:);
%     plot(timeDeltaPhi(kk), data(kk,2,1), 'Marker', '.', 'MarkerSize', 5, 'MarkerFaceColor', pointColor) 
% end % END FOR



%% PLI

% deltaPhi2 = reshape(deltaPhi, 12500/500,500);
deltaPhi2= deltaPhi;
% r = abs(mean(exp(1i*deltaPhi),2));

% phase-lag index - the average sign of the phase difference
% pli = abs(mean(abs(deltaPhi2).*sign(deltaPhi2),2))./mean(abs(deltaPhi2),2);
p = abs(mean(sign(deltaPhi2),2));

timePLI = linspace(-1.5,2,12500/500);

figure;
plot(timePLI,pli)
xlabel('Time, s')
ylabel('PLI')
title('PLI')
ylim([0,1])
