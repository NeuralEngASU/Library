
%% supp fig

clear all
close all

%load variables
[~,~] = xlsread('E:\data\human CNS\EMDDatabase.xlsx','NonSz','J3:J100');
NonSznum = xlsread('E:\data\human CNS\EMDDatabase.xlsx','NonSz','E3:E100');

figure;
%Raw data plots

% Patient 3 NonSz 5
%load data
load('E:\data\human CNS\EMD\NonSz\ProcData\CAR\2014PP01NonSz5_CAR')
%load windowed data
load('E:\data\human CNS\EMD\NonSz\WinData\NEW\2014PP01NonSz5_CAR_Win.mat')
f = 13;
ch =18;

x = data(ch,:)-nanmean(data(ch,:));

subplot(4,2,1)
plot(x,'k');
xlim([0 300000]);
set (gca,'xtick',[0 60000 120000 180000 240000 300000]);
set (gca,'xticklabel',['' '' '' '' '' '']);
ylim([-1000 1000])
set (gca,'ytick',[-1000 0 1000]);
set (gca,'yticklabel',{['' '' '']});
set (gca,'TickLength',[0.02 0.02]);
title('P3','FontSize',12,'FontName','Times New Roman','FontWeight','bold')
hold off;

subplot(4,2,3)
plot(IMFperWin(ch,:),'k.');
xlim([0 200]);
set (gca,'xtick',[0 100 200]);
set (gca,'xticklabel',[0 5 10]);
set (gca,'TickLength',[0.02 0.02]);
ylim([0 10])
set (gca,'yticklabel',['' '' '' '' '' '']);
hold off;

s = isnan(EMDonset);
[rs,~] = find(s==0);

tt=1;
for t = 5:(size(IMFperWin,2))-5
    [idch,~] = find(EMDonset >= t-5 & EMDonset < t+5);
    ss(tt,:) = size(idch,1);
    tt=tt+1;
end

idx = (find (ss>=7,1))+5;
if isempty(idx)
    idx = NaN;
end


subplot(4,2,5)
plot([idx idx], [0 20],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
hold on;
plot(ss,'k')
ylim([0 20])
set (gca,'ytick',[0 10 20]);
set (gca,'yticklabel',[0 10 20]);
set (gca,'TickLength',[0.02 0.02]);
xlim([0 200])
set (gca,'xtick',[0 40 80 120 160 200]);
hold off;

subplot(4,2,7)
plot([idx idx], [0 121],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
hold on;
plot(EMDonset(rs,:),rs,'k.')
xlim([0 199])
set (gca,'xtick',[0 40 80 120 160 200]);
set (gca,'xticklabel',{'' '' '' '' '' ''});
ylim([0 121])
set(gca,'ytick',[0 25 50 75 100 120]);
set (gca,'yticklabel',{'0' '' '50' '' '100' ''});
set (gca,'TickLength',[0.02 0.02]);
hold off;

clear chavg avg clear emdon kk ss jj j h offsetsamps onsetwin clonsetsamps clpstrtsamps t tt idx


% Patient 7 NonSz 7 Channel 79
%load data
load('E:\data\human CNS\EMD\NonSz\ProcData\CAR\2014PP06NonSz6_CAR')
%load windowed data
load('E:\data\human CNS\EMD\NonSz\WinData\NEW\2014PP06NonSz6_CAR_Win.mat')

f = 53;
ch =79;

x = data(ch,:)-nanmean(data(ch,:));

subplot(4,2,2)
plot(x,'k');
xlim([0 300000]);
set (gca,'xtick',[0 60000 120000 180000 240000 300000]);
set (gca,'xticklabel',['' '' '' '' '' '']);
ylim([-1000 2000])
set (gca,'ytick',[-1000 0 1000]);
set (gca,'yticklabel',{['' '' '']});
set (gca,'TickLength',[0.02 0.02]);
title('P7','FontSize',12,'FontName','Times New Roman','FontWeight','bold')
hold off;

subplot(4,2,4)
plot(IMFperWin(ch,:),'k.');
xlim([0 200]);
set (gca,'xtick',[0 100 200]);
set (gca,'xticklabel',[0 5 10]);
set (gca,'TickLength',[0.02 0.02]);
ylim([0 10])
set (gca,'yticklabel',['' '' '' '' '' '']);
hold off;

% Patient 7 Seizure 7
%load data
load('E:\data\human CNS\EMD\NonSz\ProcData\CAR\2014PP06NonSz6_CAR')
%load windowed data
load('E:\data\human CNS\EMD\NonSz\WinData\NEW\2014PP06NonSz6_CAR_Win.mat')
f = 53;

s = isnan(EMDonset);
[rs,~] = find(s==0);

tt=1;
for t = 5:(size(IMFperWin,2))-5
    [idch,~] = find(EMDonset >= t-5 & EMDonset < t+5);
    ss(tt,:) = size(idch,1);
    tt=tt+1;
end

idx = (find (ss>=7,1))+5;
if isempty(idx)
    idx = NaN;
end


subplot(4,2,6)
plot([idx idx], [0 20],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
hold on;
plot(ss,'k')
ylim([0 20])
set (gca,'ytick',[0 10 20]);
set (gca,'yticklabel',[0 10 20]);
set (gca,'TickLength',[0.02 0.02]);
xlim([0 200])
set (gca,'xtick',[0 40 80 120 160 200]);
hold off;

subplot(4,2,8)
plot([idx idx], [0 121],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
hold on;
plot(EMDonset(rs,:),rs,'k.')
xlim([0 200])
set (gca,'xtick',[0 40 80 120 160 200]);
set (gca,'xticklabel',{'' '' '' '' '' ''});
ylim([0 121])
set(gca,'ytick',[0 25 50 75 100 120]);
set (gca,'yticklabel',{'0' '' '50' '' '100' ''});
set (gca,'TickLength',[0.02 0.02]);
hold off;

clear chavg avg clear emdon kk ss jj j h offsetsamps onsetwin clonsetsamps clpstrtsamps t tt idx
