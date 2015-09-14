
%% Figure 1
clear all
close all

%load variables
[~,~] = xlsread('E:\data\human CNS\EMDDatabase.xlsx','NonSz','J3:J100');
NonSznum = xlsread('E:\data\human CNS\EMDDatabase.xlsx','NonSz','E3:E100');

% Patient 1 NonSz 1 Channel 9

%load data
load('E:\data\human CNS\EMD\NonSz\ProcData\CAR\2012PP05NonSz1_CAR')
%load windowed data
load('E:\data\human CNS\EMD\NonSz\WinData\NEW\2012PP05NonSz1_CAR_Win.mat')

f = 1;
ch = 9;

figure;
x = data(ch,:)-nanmean(data(ch,:));

subplot(4,4,1)
plot(x,'k');
% set(gca,'OuterPosition',[0.01 0.5 0.08 0.2])
xlim([0 300000]);
set (gca,'xtick',[0 60000 120000 180000 240000 300000]);
set (gca,'xticklabel',['' '' '' '' '' '']);
ylim([-1000 1000])
set (gca,'ytick',[-1000 0 1000]);
set (gca,'yticklabel',[-1 0 1]);
set (gca,'TickLength',[0.02 0.02]);
title('P1','FontSize',12,'FontName','Times New Roman','FontWeight','bold')
ylabel({'Voltage','(mV)'},'FontSize',12,'FontName','Times New Roman','FontWeight','normal');
% xlabel('Time (min)','FontSize',12,'FontName','Arial');
hold off;

subplot(4,4,5)
plot(IMFperWin(ch,:),'k.');
% set(gca,'OuterPosition',[0.01 0.05 0.24 0.45])
xlim([0 200]);
set (gca,'xtick',[0 100 200]);
set (gca,'xticklabel',[0 5 10]);
set (gca,'TickLength',[0.02 0.02]);
ylim([0 10])
set (gca,'yticklabel',[0 5 10]);
ylabel({'IMFs Per', 'Window'},'FontSize',12,'FontName','Times New Roman','FontWeight','normal');
% xlabel('Time (min)','FontSize',12,'FontName','Arial');
hold off;

%Patient 2 NonSz 2 Channel 97
%load data
load('E:\data\human CNS\EMD\NonSz\ProcData\CAR\2013PP01NonSz2_CAR')
%load windowed data
load('E:\data\human CNS\EMD\NonSz\WinData\NEW\2013PP01NonSz2_CAR_Win.mat')

f = 7;
ch =97;

x = data(ch,:)-nanmean(data(ch,:));

subplot(4,4,2)
plot(x,'k');
% set(gca,'OuterPosition',[0.74 0.5 0.22 0.45])
xlim([0 300000]);
set (gca,'xtick',[0 60000 120000 180000 240000 300000]);
set (gca,'xticklabel',['' '' '' '' '' '']);
ylim([-1000 1000])
set (gca,'ytick',[-1000 0 1000]);
set (gca,'yticklabel',{['' '' '']});
set (gca,'TickLength',[0.02 0.02]);
title('P2','FontSize',12,'FontName','Times New Roman','FontWeight','bold')
% ylabel('Voltage (mV)','FontSize',12,'FontName','Arial');
% xlabel('Time (min)','FontSize',12,'FontName','Arial');
hold off;

subplot(4,4,6)
plot([EMDonset(ch,1) EMDonset(ch,1)], [0 10], 'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
plot(IMFperWin(ch,:),'k.');
% set(gca,'OuterPosition',[0.74 0.05 0.22 0.45])
xlim([0 200]);
set (gca,'xtick',[0 100 200]);
set (gca,'xticklabel',[0 5 10]);
set (gca,'TickLength',[0.02 0.02]);
ylim([0 10])
set (gca,'yticklabel',['' '' '' '' '' '']);
% ylabel('IMFs Per Window','FontSize',12,'FontName','Arial');
% xlabel('Time (min)','FontSize',12,'FontName','Arial');
hold off;


%Patient 3 NonSz 9  Channel 82
%load data
load('E:\data\human CNS\EMD\NonSz\ProcData\CAR\2014PP01NonSz6_CAR')
%load windowed data
load('E:\data\human CNS\EMD\NonSz\WinData\NEW\2014PP01NonSz6_CAR_Win.mat')

f = 14;
ch =49;

x = data(ch,:)-nanmean(data(ch,:));

subplot(4,4,3)
plot(x,'k');
% set(gca,'OuterPosition',[0.74 0.5 0.22 0.45])
xlim([0 300000]);
set (gca,'xtick',[0 60000 120000 180000 240000 300000]);
set (gca,'xticklabel',['' '' '' '' '' '']);
ylim([-1000 1000])
set (gca,'ytick',[-1000 0 1000]);
set (gca,'yticklabel',{['' '' '']});
set (gca,'TickLength',[0.02 0.02]);
title('P3','FontSize',12,'FontName','Times New Roman','FontWeight','bold')
% ylabel('Voltage (mV)','FontSize',12,'FontName','Arial');
% xlabel('Time (min)','FontSize',12,'FontName','Arial');
hold off;

subplot(4,4,7)
plot(IMFperWin(ch,:),'k.');
% set(gca,'OuterPosition',[0.74 0.05 0.22 0.45])
xlim([0 200]);
set (gca,'xtick',[0 100 200]);
set (gca,'xticklabel',[0 5 10]);
set (gca,'TickLength',[0.02 0.02]);
ylim([0 10])
set (gca,'yticklabel',['' '' '' '' '' '']);
% ylabel('IMFs Per Window','FontSize',12,'FontName','Arial');
% xlabel('Time (min)','FontSize',12,'FontName','Arial');
hold off;



%Patient 4 NonSz 3 channel 73
%load data
load('E:\data\human CNS\EMD\NonSz\ProcData\CAR\2014PP02NonSz3_CAR')
%load windowed data
load('E:\data\human CNS\EMD\NonSz\WinData\NEW\2014PP02NonSz3_CAR_Win.mat')

f = 17;
ch =73;

x = data(ch,:)-nanmean(data(ch,:));

subplot(4,4,4)
plot(x,'k');
% set(gca,'OuterPosition',[0.74 0.5 0.22 0.45])
xlim([0 300000]);
set (gca,'xtick',[0 60000 120000 180000 240000 300000]);
set (gca,'xticklabel',['' '' '' '' '' '']);
ylim([-500 500])
set (gca,'ytick',[-500 0 500]);
set (gca,'yticklabel',{['' '' '']});
set (gca,'TickLength',[0.02 0.02]);
title('P4','FontSize',12,'FontName','Times New Roman','FontWeight','bold')
% ylabel('Voltage (mV)','FontSize',12,'FontName','Arial');
% xlabel('Time (min)','FontSize',12,'FontName','Arial');
hold off;

subplot(4,4,8)
plot(IMFperWin(ch,:),'k.');
% set(gca,'OuterPosition',[0.74 0.05 0.22 0.45])
xlim([0 200]);
set (gca,'xtick',[0 100 200]);
set (gca,'xticklabel',[0 5 10]);
set (gca,'TickLength',[0.02 0.02]);
ylim([0 10])
set (gca,'yticklabel',['' '' '' '' '' '']);
% ylabel('IMFs Per Window','FontSize',12,'FontName','Arial');
xlabel('Time (min)','FontSize',12,'FontName','Times New Roman','FontWeight','normal');
hold off;



% Patient 5 NonSz 4 Channel 70
%load data
load('E:\data\human CNS\EMD\NonSz\ProcData\CAR\2014PP04NonSz4_CAR')
%load windowed data
load('E:\data\human CNS\EMD\NonSz\WinData\NEW\2014PP04NonSz4_CAR_Win.mat')

f = 25;
ch =70;

x = data(ch,:)-nanmean(data(ch,:));

subplot(4,4,9)
plot(x,'k');
% % set(gca,'OuterPosition',[0.273 0.5 0.21 0.45])
xlim([0 300000]);
set (gca,'xtick',[0 60000 120000 180000 240000 300000]);
set (gca,'xticklabel',['' '' '' '' '' '']);
ylim([-1000 1000])
set (gca,'ytick',[-1000 0 1000]);
set (gca,'yticklabel',[-1 0 1]);
set (gca,'TickLength',[0.02 0.02]);
title('P5','FontSize',12,'FontName','Times New Roman','FontWeight','bold')
ylabel({'Voltage','(mV)'},'FontSize',12,'FontName','Times New Roman','FontWeight','normal');
% xlabel('Time (min)','FontSize',12,'FontName','Arial');
hold off;

subplot(4,4,13)
plot(IMFperWin(ch,:),'k.');
% set(gca,'OuterPosition',[0.273 0.05 0.21 0.45])
xlim([0 200]);
set (gca,'xtick',[0 100 200]);
set (gca,'xticklabel',[0 5 10]);
set (gca,'TickLength',[0.02 0.02]);
ylim([0 10])
set (gca,'yticklabel',[0 5 10]);
ylabel({'IMFs Per','Window'},'FontSize',12,'FontName','Times New Roman','FontWeight','normal');
% xlabel('Time (min)','FontSize',12,'FontName','Arial');
hold off;



% Patient 6 NonSz 1 Channel 8
%load data
load('E:\data\human CNS\EMD\NonSz\ProcData\CAR\2014PP05NonSz1_CAR')
%load windowed data
load('E:\data\human CNS\EMD\NonSz\WinData\NEW\2014PP05NonSz1_CAR_Win.mat')

f = 38;
ch =8;

x = data(ch,:)-nanmean(data(ch,:));

subplot(4,4,10)
plot(x,'k');
% set(gca,'OuterPosition',[0.74 0.5 0.22 0.45])
xlim([0 600000]);
set (gca,'xtick',[0 120000 240000 360000 480000 600000]);
set (gca,'xticklabel',['' '' '' '' '' '']);
ylim([-1500 1500])
set (gca,'ytick',[-1500 0 1500]);
set (gca,'yticklabel',{['' '' '']});
set (gca,'TickLength',[0.02 0.02]);
title('P6','FontSize',12,'FontName','Times New Roman','FontWeight','bold')
% ylabel('Voltage (mV)','FontSize',12,'FontName','Arial');
% xlabel('Time (min)','FontSize',12,'FontName','Arial');
hold off;

subplot(4,4,14)
plot(IMFperWin(ch,:),'k.');
% set(gca,'OuterPosition',[0.74 0.05 0.22 0.45])
xlim([0 200]);
set (gca,'xtick',[0 100 200]);
set (gca,'xticklabel',[0 5 10]);
set (gca,'TickLength',[0.02 0.02]);
ylim([0 10])
set (gca,'yticklabel',['' '' '' '' '' '']);
% ylabel('IMFs Per Window','FontSize',12,'FontName','Arial');
% xlabel('Time (min)','FontSize',12,'FontName','Arial');
hold off;


% Patient 7 NonSz 7 Channel 79
%load data
load('E:\data\human CNS\EMD\NonSz\ProcData\CAR\2014PP06NonSz7_CAR')
%load windowed data
load('E:\data\human CNS\EMD\NonSz\WinData\NEW\2014PP06NonSz7_CAR_Win.mat')

f = 54;
ch =79;

x = data(ch,:)-nanmean(data(ch,:));

subplot(4,4,11)
plot(x,'k');
% set(gca,'OuterPosition',[0.507 0.5 0.21 0.45])
xlim([0 300000]);
set (gca,'xtick',[0 60000 120000 180000 240000 300000]);
set (gca,'xticklabel',['' '' '' '' '' '']);
ylim([-1500 1500])
set (gca,'ytick',[-1500 0 1500]);
set (gca,'yticklabel',{['' '' '']});
set (gca,'TickLength',[0.02 0.02]);
title('P7','FontSize',12,'FontName','Times New Roman','FontWeight','bold')
% ylabel('Voltage (mV)','FontSize',12,'FontName','Arial');
% xlabel('Time (min)','FontSize',12,'FontName','Arial');
hold off;

subplot(4,4,15)
plot(IMFperWin(ch,:),'k.');
% set(gca,'OuterPosition',[0.507 0.05 0.21 0.45])
xlim([0 200]);
set (gca,'xtick',[0 100 200]);
set (gca,'xticklabel',[0 5 10]);
set (gca,'TickLength',[0.02 0.02]);
ylim([0 10])
set (gca,'yticklabel',['' '' '' '' '' '']);
% ylabel('IMFs Per Window','FontSize',12,'FontName','Arial');
% xlabel('Time (min)','FontSize',12,'FontName','Arial');
hold off;

% Patient 8 NonSz 5 Channel 43
%load data
load('E:\data\human CNS\EMD\NonSz\ProcData\CAR\2014PP07NonSz5_CAR')
%load windowed data
load('E:\data\human CNS\EMD\NonSz\WinData\NEW\2014PP07NonSz5_CAR_Win.mat')

f = 67;
ch =43;


x = data(ch,:)-nanmean(data(ch,:));

subplot(4,4,12)
plot(x,'k');
% set(gca,'OuterPosition',[0.74 0.5 0.22 0.45])
xlim([0 300000]);
set (gca,'xtick',[0 60000 120000 180000 240000 300000]);
set (gca,'xticklabel',['' '' '' '' '' '']);
ylim([-1000 1000])
set (gca,'ytick',[-1000 0 1000]);
set (gca,'yticklabel',{['' '' '']});
set (gca,'TickLength',[0.02 0.02]);
title('P8','FontSize',12,'FontName','Times New Roman','FontWeight','bold')
% ylabel('Voltage (mV)','FontSize',12,'FontName','Arial');
% xlabel('Time (min)','FontSize',12,'FontName','Arial');
hold off;

subplot(4,4,16)
plot(IMFperWin(ch,:),'k.');
% set(gca,'OuterPosition',[0.74 0.05 0.22 0.45])
xlim([0 200]);
set (gca,'xtick',[0 100 200]);
set (gca,'xticklabel',[0 5 10]);
set (gca,'TickLength',[0.02 0.02]);
ylim([0 10])
set (gca,'yticklabel',['' '' '' '' '' '']);
% ylabel('IMFs Per Window','FontSize',12,'FontName','Arial');
% xlabel('Time (min)','FontSize',12,'FontName','Arial');
hold off;

%% Figure 2

% Patient 1 NonSz 1
%load data
load('E:\data\human CNS\EMD\NonSz\ProcData\CAR\2012PP05NonSz1_CAR')
%load windowed data
load('E:\data\human CNS\EMD\NonSz\WinData\NEW\2012PP05NonSz1_CAR_Win.mat')
f = 1;

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


figure;
subplot(4,4,5)
plot([idx idx], [0 10],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
hold on;
plot(ss,'k')
ylabel('Number of Onsets','FontName','Times New Roman','FontSize',12)
ylim([0 10])
set (gca,'ytick',[0 5 10]);
set (gca,'yticklabel',[0 5 10]);
set (gca,'TickLength',[0.02 0.02]);
xlim([0 200])
set (gca,'xtick',[0 40 80 120 160 200]);
hold off;

subplot(4,4,1)
plot([idx idx], [0 121],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
hold on;
plot(EMDonset(rs,:),rs,'k.')
title('P1','FontName','Times New Roman','FontSize',12,'FontWeight','bold')
ylabel('Electrode Number','FontName','Times New Roman','FontSize',12)
xlim([0 200])
set (gca,'xtick',[0 40 80 120 160 200]);
set (gca,'xticklabel',{'' '' '' '' '' ''});
ylim([0 121])
set(gca,'ytick',[0 25 50 75 100 120]);
set (gca,'yticklabel',{'0' '' '50' '' '100' ''});
set (gca,'TickLength',[0.02 0.02]);
hold off;

clear chavg avg clear emdon kk ss jj j h offsetsamps onsetwin clonsetsamps clpstrtsamps t tt idx

% Patient 2 Seizure 2
%load data
load('E:\data\human CNS\EMD\NonSz\ProcData\CAR\2013PP01NonSz2_CAR')
%load windowed data
load('E:\data\human CNS\EMD\NonSz\WinData\NEW\2013PP01NonSz2_CAR_Win.mat')
f = 7;

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


subplot(4,4,6)
plot([idx idx], [0 10],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
hold on;
plot(ss,'k')
ylabel('Number of Onsets','FontName','Times New Roman','FontSize',12)
ylim([0 10])
set (gca,'ytick',[0 5 10]);
set (gca,'yticklabel',[0 5 10]);
set (gca,'TickLength',[0.02 0.02]);
xlim([0 200])
set (gca,'xtick',[0 40 80 120 160 200]);
hold off;

subplot(4,4,2)
plot([idx idx], [0 121],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
hold on;
plot(EMDonset(rs,:),rs,'k.')
title('P2','FontName','Times New Roman','FontSize',12,'FontWeight','bold')
ylabel('Electrode Number','FontName','Times New Roman','FontSize',12)
xlim([0 200])
set (gca,'xtick',[0 40 80 120 160 200]);
set (gca,'xticklabel',{'' '' '' '' '' ''});
ylim([0 121])
set(gca,'ytick',[0 25 50 75 100 120]);
set (gca,'yticklabel',{'0' '' '50' '' '100' ''});
set (gca,'TickLength',[0.02 0.02]);
hold off;

clear chavg avg clear emdon kk ss jj j h offsetsamps onsetwin clonsetsamps clpstrtsamps t tt idx


% Patient 3 Seizure 9
%load data
load('E:\data\human CNS\EMD\NonSz\ProcData\CAR\2014PP01NonSz6_CAR')
%load windowed data
load('E:\data\human CNS\EMD\NonSz\WinData\NEW\2014PP01NonSz6_CAR_Win.mat')
f = 14;


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


subplot(4,4,7)
plot([idx idx], [0 10],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
hold on;
plot(ss,'k')
ylabel('Number of Onsets','FontName','Times New Roman','FontSize',12)
ylim([0 10])
set (gca,'ytick',[0 5 10]);
set (gca,'yticklabel',[0 5 10]);
set (gca,'TickLength',[0.02 0.02]);
xlim([0 200])
set (gca,'xtick',[0 40 80 120 160 200]);
hold off;

subplot(4,4,3)
plot([idx idx], [0 121],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
hold on;
plot(EMDonset(rs,:),rs,'k.')
title('P3','FontName','Times New Roman','FontSize',12,'FontWeight','bold')
ylabel('Electrode Number','FontName','Times New Roman','FontSize',12)
xlim([0 199])
set (gca,'xtick',[0 40 80 120 160 200]);
set (gca,'xticklabel',{'' '' '' '' '' ''});
ylim([0 121])
set(gca,'ytick',[0 25 50 75 100 120]);
set (gca,'yticklabel',{'0' '' '50' '' '100' ''});
set (gca,'TickLength',[0.02 0.02]);
hold off;

clear chavg avg clear emdon kk ss jj j h offsetsamps onsetwin clonsetsamps clpstrtsamps t tt idx


% Patient 4 Seizure 3
%load data
load('E:\data\human CNS\EMD\NonSz\ProcData\CAR\2014PP02NonSz3_CAR')
%load windowed data
load('E:\data\human CNS\EMD\NonSz\WinData\NEW\2014PP02NonSz3_CAR_Win.mat')
f = 17;

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


subplot(4,4,8)
plot([idx idx], [0 10],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
hold on;
plot(ss,'k')
ylabel('Number of Onsets','FontName','Times New Roman','FontSize',12)
ylim([0 10])
set (gca,'ytick',[0 5 10]);
set (gca,'yticklabel',[0 5 10]);
set (gca,'TickLength',[0.02 0.02]);
xlim([0 200])
set (gca,'xtick',[0 40 80 120 160 200]);
hold off;

subplot(4,4,4)
plot([idx idx], [0 121],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
hold on;
plot(EMDonset(rs,:),rs,'k.')
title('P4','FontName','Times New Roman','FontSize',12,'FontWeight','bold')
ylabel('Electrode Number','FontName','Times New Roman','FontSize',12)
xlim([0 200])
set (gca,'xtick',[0 40 80 120 160 200]);
set (gca,'xticklabel',{'' '' '' '' '' ''});
ylim([0 121])
set(gca,'ytick',[0 25 50 75 100 120]);
set (gca,'yticklabel',{'0' '' '50' '' '100' ''});
set (gca,'TickLength',[0.02 0.02]);
hold off;

clear chavg avg clear emdon kk ss jj j h offsetsamps onsetwin clonsetsamps clpstrtsamps t tt idx


% Patient 5 Seizure 4
%load data
load('E:\data\human CNS\EMD\NonSz\ProcData\CAR\2014PP04NonSz4_CAR')
%load windowed data
load('E:\data\human CNS\EMD\NonSz\WinData\NEW\2014PP04NonSz4_CAR_Win.mat')
f = 25;
%4/25

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

subplot(4,4,13)
plot([idx idx], [0 10],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
hold on;
plot(ss,'k')
ylabel('Number of Onsets','FontName','Times New Roman','FontSize',12)
ylim([0 10])
set (gca,'ytick',[0 5 10]);
set (gca,'yticklabel',[0 5 10]);
set (gca,'TickLength',[0.02 0.02]);
xlim([0 200])
set (gca,'xtick',[0 40 80 120 160 200]);
hold off;

subplot(4,4,9)
plot([idx idx], [0 121],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
hold on;
plot(EMDonset(rs,:),rs,'k.')
title('P5','FontName','Times New Roman','FontSize',12,'FontWeight','bold')
ylabel('Electrode Number','FontName','Times New Roman','FontSize',12)
xlim([0 200])
set (gca,'xtick',[0 40 80 120 160 200]);
set (gca,'xticklabel',{'' '' '' '' '' ''});
ylim([0 121])
set(gca,'ytick',[0 25 50 75 100 120]);
set (gca,'yticklabel',{'0' '' '50' '' '100' ''});
set (gca,'TickLength',[0.02 0.02]);
hold off;

clear chavg avg clear emdon kk ss jj j h offsetsamps onsetwin clonsetsamps clpstrtsamps t tt idx


% Patient 6 Seizure 1
%load data
load('E:\data\human CNS\EMD\NonSz\ProcData\CAR\2014PP05NonSz1_CAR')
%load windowed data
load('E:\data\human CNS\EMD\NonSz\WinData\NEW\2014PP05NonSz1_CAR_Win.mat')
f = 38;

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



subplot(4,4,14)
plot([idx idx], [0 10],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
hold on;
plot(ss,'k')
ylabel('Number of Onsets','FontName','Times New Roman','FontSize',12)
ylim([0 10])
set (gca,'ytick',[0 5 10]);
set (gca,'yticklabel',[0 5 10]);
set (gca,'TickLength',[0.02 0.02]);
xlim([0 200])
set (gca,'xtick',[0 40 80 120 160 200]);
hold off;

subplot(4,4,10)
plot([idx idx], [0 121],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
hold on;
plot(EMDonset(rs,:),rs,'k.')
title('P6','FontName','Times New Roman','FontSize',12,'FontWeight','bold')
ylabel('Electrode Number','FontName','Times New Roman','FontSize',12)
xlim([0 200])
set (gca,'xtick',[0 40 80 120 160 200]);
set (gca,'xticklabel',{'' '' '' '' '' ''});
ylim([0 121])
set(gca,'ytick',[0 25 50 75 100 120]);
set (gca,'yticklabel',{'0' '' '50' '' '100' ''});
set (gca,'TickLength',[0.02 0.02]);
hold off;

clear chavg avg clear emdon kk ss jj j h offsetsamps onsetwin clonsetsamps clpstrtsamps t tt idx



% Patient 7 Seizure 7
%load data
load('E:\data\human CNS\EMD\NonSz\ProcData\CAR\2014PP06NonSz7_CAR')
%load windowed data
load('E:\data\human CNS\EMD\NonSz\WinData\NEW\2014PP06NonSz7_CAR_Win.mat')
f = 54;

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


subplot(4,4,15)
plot([idx idx], [0 10],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
hold on;
plot(ss,'k')
ylabel('Number of Onsets','FontName','Times New Roman','FontSize',12)
ylim([0 10])
set (gca,'ytick',[0 5 10]);
set (gca,'yticklabel',[0 5 10]);
set (gca,'TickLength',[0.02 0.02]);
xlim([0 200])
set (gca,'xtick',[0 40 80 120 160 200]);
hold off;

subplot(4,4,11)
plot([idx idx], [0 121],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
hold on;
plot(EMDonset(rs,:),rs,'k.')
title('P7','FontName','Times New Roman','FontSize',12,'FontWeight','bold')
ylabel('Electrode Number','FontName','Times New Roman','FontSize',12)
xlim([0 200])
set (gca,'xtick',[0 40 80 120 160 200]);
set (gca,'xticklabel',{'' '' '' '' '' ''});
ylim([0 121])
set(gca,'ytick',[0 25 50 75 100 120]);
set (gca,'yticklabel',{'0' '' '50' '' '100' ''});
set (gca,'TickLength',[0.02 0.02]);
hold off;

clear chavg avg clear emdon kk ss jj j h offsetsamps onsetwin clonsetsamps clpstrtsamps t tt idx

% Patient 8 Seizure 5
%load data
load('E:\data\human CNS\EMD\NonSz\ProcData\CAR\2014PP07NonSz5_CAR')
%load windowed data
load('E:\data\human CNS\EMD\NonSz\WinData\NEW\2014PP07NonSz5_CAR_Win.mat')
f = 67;

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

subplot(4,4,16)
plot([idx idx], [0 10],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
hold on;
plot(ss,'k')
ylabel('Number of Onsets','FontName','Times New Roman','FontSize',12)
ylim([0 10])
set (gca,'ytick',[0 5 10]);
set (gca,'yticklabel',[0 5 10]);
set (gca,'TickLength',[0.02 0.02]);
xlim([0 200])
set (gca,'xtick',[0 40 80 120 160 200]);
hold off;

subplot(4,4,12)
plot([idx idx], [0 121],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
hold on;
plot(EMDonset(rs,:),rs,'k.')
title('P8','FontName','Times New Roman','FontSize',12,'FontWeight','bold')
ylabel('Electrode Number','FontName','Times New Roman','FontSize',12)
xlim([0 200])
set (gca,'xtick',[0 40 80 120 160 200]);
set (gca,'xticklabel',{'' '' '' '' '' ''});
ylim([0 121])
set(gca,'ytick',[0 25 50 75 100 120]);
set (gca,'yticklabel',{'0' '' '50' '' '100' ''});
set (gca,'TickLength',[0.02 0.02]);
hold off;

clear chavg avg clear emdon kk ss jj j h offsetsamps onsetwin clonsetsamps clpstrtsamps t tt idx



%%  Figure 3

clear all

[~,clpstrt] = xlsread('E:\data\human CNS\EMDDatabase.xlsx','NonSz','J3:J100');
NonSznum = xlsread('E:\data\human CNS\EMDDatabase.xlsx','NonSz','E3:E100');
[~,clonset] = xlsread('E:\data\human CNS\EMDDatabase.xlsx','NonSz','L3:L100');
Fs = xlsread('E:\data\human CNS\EMDDatabase.xlsx','NonSz','H3:H100');


%Seizure
files = dir(['E:\data\human CNS\EMD\NonSz\WinData\NEW\', '*.mat']);

for f = 1:size(files,1)
    patnum{f} = files(f).name(1:13);
end
ptnum = unique(patnum);

for f = 1:size(files,1)
    iddash = strfind(files(f).name,'_');
    patnum{f} = files(f).name(1:(iddash-1));
end

pltinfo = {'.b' '.r' '.g' '.c' '.m' '.k' '+b' '+r' '+g' '+c' '+m' '+k' 'ob' 'or' 'og' 'oc' 'om' 'ok'};
threshold = {'mode' 'avg' 'var'};

figure;
for p = 1:4
    filecomp{p} = strncmp(ptnum(p),patnum,11);
    [~,c]= find(filecomp{p}==1);
    disp (ptnum{p})
    
    allNonSz.var = [];

    for f = c(1):c(end)%convert seizure onset and clip start times to number of samples
        
        name = strcat(ptnum(p),num2str(NonSznum(f)));
        load(['E:\data\human CNS\EMD\NonSz\WinData\NEW\',name{1},'_CAR_Win.mat']); %seizure
                
        center = EMDonset;
        allNonSz.var = [allNonSz.var,center];
                
        s = isnan(center);
        [rs,~] = find(s==0);
        
        subplot(6,4,p);
        plot(center(rs,:),rs,pltinfo{NonSznum(f)})
        xlim([0 199])
        set (gca,'xtick',[0 20 40 60 80 100 120 140 160 180 200]);
    set (gca,'xticklabel',['' '' '' '' '' '' '' '' '' '' '']);
        ylim([0 120])
        set(gca,'ytick',[0 25 50 75 100]);
        set(gca,'yticklabel',{'0' '' '50' '' '100'});
        set (gca,'TickLength',[0.01 0.01]);
        hold on
        clear rm ra rs
        
        ww = 1;
        for w = 0:199
            [rs,~] = find(center == w);
            id{ww} = rs;
            ws(ww,:) =size(rs,1);
            ww = ww+1;
        end
        
        total{p}(f,:)= ws;
        clear rm ra rs
        
        y = [0:1:199];
        plt = {'b' 'r' 'g' 'c' 'm' 'k' '--b' '--r' '--g' '--c' '--m' '--k' '-.b' '-.r' '-.g' '-.c' '-.m' '-.k'};
        
       subplot(6,4,(p+4));
        plot(y,ws,plt{NonSznum(f)});
        hold on;
        xlim([0 200])
        set (gca,'xtick',[0 20 40 60 80 100 120 140 160 180 200]);
        set (gca,'xticklabel',['' '' '' '' '' '' '' '' '' '' '']);
        ylim([0 10])
        set(gca,'ytick',[0 5 10])
        set (gca,'yticklabel',{'0' '' '10'});
        set (gca,'TickLength',[0.01 0.01]);
        hold on
        clear EMDonset
        
    end
    
    tt=0:5:200;
    for t = 1:size(tt,2)-1
        [idch,~] = find(allNonSz.var > tt(t)& allNonSz.var < tt(t+1));
        ss(t,:) = size(idch,1);
    end
    
   subplot(6,4,(p+8));
    h = histogram(allNonSz.var,20,'BinLimits',[0 199],'FaceColor',[0 0 0],'FaceAlpha',1);
    xlim([0 200]) 
    set (gca,'xtick',[0 20 40 60 80 100 120 140 160 180 200]);
    set (gca,'xticklabel',{'0' '' '' '' '' '6' '' '' '' '' '10'});
   ylim([0 30])
    set(gca,'ytick',[0 15 30]);
    set(gca,'yticklabel',{'0' '15' '30'});
    set (gca,'TickLength',[0.01 0.01]);
    
    clear allNonSz tt t ss edgess
end

for p = 5:8
    filecomp{p} = strncmp(ptnum(p),patnum,11);
    [~,c]= find(filecomp{p}==1);
    disp (ptnum{p})
    
    allNonSz.var = [];

    for f = c(1):c(end)%convert seizure onset and clip start times to number of samples
        
        name = strcat(ptnum(p),num2str(NonSznum(f)));
        load(['E:\data\human CNS\EMD\NonSz\WinData\NEW\',name{1},'_CAR_Win.mat']); %seizure
                
        center = EMDonset;
        allNonSz.var = [allNonSz.var,center];
                
        s = isnan(center);
        [rs,~] = find(s==0);
        
        subplot(6,4,(p+8));
        plot(center(rs,:),rs,pltinfo{NonSznum(f)})
        xlim([0 199])
        set (gca,'xtick',[0 20 40 60 80 100 120 140 160 180 200]);
    set (gca,'xticklabel',['' '' '' '' '' '' '' '' '' '' '']);
        ylim([0 120])
        set(gca,'ytick',[0 25 50 75 100 120]);
        set(gca,'yticklabel',{'0' '' '50' '' '100' ''});
        set (gca,'TickLength',[0.01 0.01]);
        hold on
        clear rm ra rs
        
        ww = 1;
        for w = 0:199
            [rs,~] = find(center == w);
            id{ww} = rs;
            ws(ww,:) =size(rs,1);
            ww = ww+1;
        end
        
        total{p}(f,:)= ws;
        clear rm ra rs
        
        y = [0:1:199];
        plt = {'b' 'r' 'g' 'c' 'm' 'k' '--b' '--r' '--g' '--c' '--m' '--k' '-.b' '-.r' '-.g' '-.c' '-.m' '-.k'};
        
       subplot(6,4,(p+12));
        plot(y,ws,plt{NonSznum(f)});
        hold on;
        xlim([0 200])
        set (gca,'xtick',[0 20 40 60 80 100 120 140 160 180 200]);
        set (gca,'xticklabel',['' '' '' '' '' '' '' '' '' '' '']);
        ylim([0 10])
        set(gca,'ytick',[0 5 10])
        set (gca,'yticklabel',{'0' '' '10'});
        set (gca,'TickLength',[0.01 0.01]);
        hold on
        clear EMDonset
        
    end
    
    tt=0:5:200;
    for t = 1:size(tt,2)-1
        [idch,~] = find(allNonSz.var > tt(t)& allNonSz.var < tt(t+1));
        ss(t,:) = size(idch,1);
    end
    
   subplot(6,4,(p+16));
    h = histogram(allNonSz.var,20,'BinLimits',[0 199],'FaceColor',[0 0 0],'FaceAlpha',1);
    xlim([0 200]) 
    set (gca,'xtick',[0 20 40 60 80 100 120 140 160 180 200]);
    set (gca,'xticklabel',{'0' '' '' '' '' '5' '' '' '' '' '10'});
    ylim([0 30])
    set(gca,'ytick',[0 15 30]);
    set(gca,'yticklabel',{'0' '15' '30'});
    set (gca,'TickLength',[0.01 0.01]);
    
    clear allNonSz tt t ss edgess
end
%% Find depth electrode onsets

clear all

depthelecs{1} = [83:98];
depthelecs{2} = NaN;
depthelecs{3} = [97:120];
depthelecs{4} = [65:76];
depthelecs{5} = NaN;
depthelecs{6} = [65:82];
depthelecs{7} = [83:90];
depthelecs{8} = [73:90];

Fs = xlsread('E:\data\human CNS\EMDDatabase.xlsx','NonSz','H3:H100');
NonSznum = xlsread('E:\data\human CNS\EMDDatabase.xlsx','NonSz','E3:E100');

files = dir(['E:\data\human CNS\EMD\NonSz\WinData\NEW\', '*.mat']);

for f = 1:size(files,1)
    patnum{f} = files(f).name(1:10);
end
ptnum = unique(patnum);

for f = 1:size(files,1)
    iddash = strfind(files(f).name,'_');
    patnum{f} = files(f).name(1:(iddash-1));
end

for p = 1:size(ptnum,2)
    filecomp{p} = strncmp(ptnum(p),patnum,8);
    [~,c]= find(filecomp{p}==1);
    disp (ptnum{p})
     allNonSz{p} = [];  
     
    for f = c(1):c(end)%convert seizure onset and clip start times to number of samples
        
        name = strcat(ptnum(p),num2str(NonSznum(f)));
        load(['E:\data\human CNS\EMD\NonSz\WinData\NEW\',name{1},'_CAR_Win.mat']); %seizure
        s = ~isnan(EMDonset);
        
        if isnan(depthelecs{p})
            [rs,~] = find(s==1);
            ons{f} = NaN;
        else
            if isempty(s)
                ons{f} = NaN;
                
            else
                [rs,~] = find(s==1);
                ons{f}(:,:) = find (rs>=depthelecs{p}(1) & rs<=depthelecs{p}(end));
            end
        end
        allNonSz{p} = [allNonSz{p},size(rs,1)];
    end
end


%%  Comparing onsets
clear all

[~,clpstrt] = xlsread('E:\data\human CNS\EMDDatabase.xlsx','NonSz','J3:J100');
NonSznum = xlsread('E:\data\human CNS\EMDDatabase.xlsx','NonSz','E3:E100');
[~,clonset] = xlsread('E:\data\human CNS\EMDDatabase.xlsx','NonSz','L3:L100');
Fs = xlsread('E:\data\human CNS\EMDDatabase.xlsx','NonSz','H3:H100');

files = dir(['E:\data\human CNS\EMD\NonSz\WinData\NEW\', '*.mat']);

for f = 1:size(files,1)
    patnum{f} = files(f).name(1:10);
end
ptnum = unique(patnum);

for f = 1:size(files,1)
    iddash = strfind(files(f).name,'_');
    patnum{f} = files(f).name(1:(iddash-1));
end

for p = 1:size(ptnum,2)
    filecomp{p} = strncmp(ptnum(p),patnum,8);
    [~,c]= find(filecomp{p}==1);
    disp (ptnum{p})
    
%     onsetdet{p}=zeros(size(onsetchans{p},1),size(onsetchans{p},2));
    NonSz = 1;
    allNonSz=[];
    for f = c(1):c(end)%convert seizure onset and clip start times to number of samples
        
        name = strcat(ptnum(p),num2str(NonSznum(f)));
        load(['E:\data\human CNS\EMD\NonSz\WinData\NEW\',name{1},'_CAR_Win.mat']); %seizure
        
        clonsetsamps(f,:) = (str2double(clonset{f}(1:2))*3600 + str2double(clonset{f}(4:5))*60 + str2double(clonset{f}(7:8)))*Fs(f);
        clpstrtsamps(f,:) = (str2double(clpstrt{f}(1:2))*3600 + str2double(clpstrt{f}(4:5))*60 + str2double(clpstrt{f}(7:8)))*Fs(f);
        offsetsamps(f) = clonsetsamps(f,:) - clpstrtsamps(f,:);
        onsetwin(f) = floor(offsetsamps(f)/(Fs(f)*3));
        
        center = EMDonset - onsetwin(f);
        allNonSz = [allNonSz,center];
       NonSz = NonSz+1; 
    end
        
        totNonSz{p}= allNonSz(~isnan(allNonSz));
        avg{p}=nanmean(nanmean(allNonSz,2));
        clear allNonSz
        
 
end
    
%         idch = ~isnan(onsetchans{p}(NonSz,:));
%         idch = idch(idch==1);
%         for ch = 1:size(idch,2)
%             id = EMDonset(onsetchans{p}(idch),:);
%             id = id(~isnan(id));
%             if isempty(id==1)
%                 sep = 100;
%             else
%                 for k = 1:size(id,2)
%                     sep = abs(onsetwin(f)-id(k));
%                 end
%             end
%             if sep<=50
%                 onsetdet{p}(f,ch)=1;
%             else
%                 onsetdet{p}(f,ch)=2;
%             end
%             
%             
%             clear k
%         end
%         NonSz = NonSz+1;
%         clear ch idch id
%     end
% end

