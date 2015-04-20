

%% Load Data

load('PLI.mat')

PLI = PLI2;
R = R2;
zScore = zScoreReport2;

%% Plot Basic Figures

% Plot R values for real real signals and average for surrogate signals

figure(1)
colormap('jet')
imagesc(R(:,:,1), [0,1]);

set(gca, 'XTick', []);
set(gca, 'XTickLabels', []);
set(gca, 'YTick', []);
set(gca, 'YTickLabels', []);
colorbar(gca)

title('R Matrix, phase difference between signals')

figure(2)
colormap('jet')
imagesc(mean(R(:,:,2:end),3), [0,1]);

set(gca, 'XTick', []);
set(gca, 'XTickLabels', []);
set(gca, 'YTick', []);
set(gca, 'YTickLabels', []);
colorbar(gca)

title('R Matrix for Surrogate Data')

%% Plot PLI and average PLI for surrogate data

figure(3)
colormap('jet')
imagesc(PLI(:,:,1), [0,0.25]);

set(gca, 'XTick', []);
set(gca, 'XTickLabels', []);
set(gca, 'YTick', []);
set(gca, 'YTickLabels', []);
colorbar(gca)

title('Phase Lag Index')

figure(4)
colormap('jet')
imagesc(mean(PLI(:,:,2:end),3), [0,0.25]);

set(gca, 'XTick', []);
set(gca, 'XTickLabels', []);
set(gca, 'YTick', []);
set(gca, 'YTickLabels', []);
colorbar(gca)

title('Phase Lag Index, Surrogate Data')

%% zScore for data and surrogate data

figure(5)
colormap('jet')
imagesc(zScore(:,:,1), [-5,5]);

set(gca, 'XTick', []);
set(gca, 'XTickLabels', []);
set(gca, 'YTick', []);
set(gca, 'YTickLabels', []);
colorbar(gca)

title('Z-Score')

figure(6)
colormap('jet')
imagesc(mean(zScore(:,:,2:end),3), [-5,5]);

set(gca, 'XTick', []);
set(gca, 'XTickLabels', []);
set(gca, 'YTick', []);
set(gca, 'YTickLabels', []);
colorbar(gca)

title('Z-Score, Surrogate Data')

%% zScore pass for signifigance

zScorePass = (abs(zScore(:,:,1)) >= 1.96) .* sign(zScore(:,:,1));

figure(7)
colormap('jet')
imagesc(zScorePass, [-1,1]);

set(gca, 'XTick', []);
set(gca, 'XTickLabels', []);
set(gca, 'YTick', []);
set(gca, 'YTickLabels', []);
colorbar(gca)

title(sprintf('Z-Score >= 1.96 (.95 Confidence)\n+1 = Signifigant Coupling. -1 = Signifigant Non-Coupling'))

