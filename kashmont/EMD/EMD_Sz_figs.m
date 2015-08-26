
%% Figure 1
clear all
close all

%load variables
[~,clpstrt] = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','J3:J100');
sznum = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','E3:E100');
[~,clonset] = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','L3:L100');
Fs = 500;

% Patient 1 Sz 1 Channel 9

%load data
load('E:\data\human CNS\EMD\Sz\ProcData\CAR\2012PP05Sz1_CAR')
%load windowed data
load('E:\data\human CNS\EMD\Sz\WinData\NEW\2012PP05Sz1_CAR_Win.mat')

f = 1;
ch = 9;

onsetsamps(f,:) = ((str2num(clonset{f}(1:2))*3600)+(str2num(clonset{f}(4:5))*60)+(str2num(clonset{f}(7:8))))*Fs;
clpstrtsamps(f,:) = ((str2num(clpstrt{f}(1:2))*3600)+(str2num(clpstrt{f}(4:5))*60)+(str2num(clpstrt{f}(7:8))))*Fs;
offsetsamps(f,:) = onsetsamps(f,:) - clpstrtsamps(f,:);
offsetwin(f,:) = floor((offsetsamps(f,:)/Fs)/3);

figure;
% suptitle({'figure 1',' ',' '})%,'FontSize',14,'FontName','Arial','FontWeight','bold');

x = data(ch,:)-nanmean(data(ch,:));

subplot(4,4,1)
plot([offsetsamps(f) offsetsamps(f)], [-3000 5000],'r','LineWidth',1);
hold on;
plot([(EMDonset(ch,1)*1500) (EMDonset(ch,1)*1500)], [-3000 5000],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
plot(x,'k');
% set(gca,'OuterPosition',[0.01 0.5 0.08 0.2])
xlim([0 300000]);
set (gca,'xtick',[0 60000 120000 180000 240000 300000]);
set (gca,'xticklabel',['' '' '' '' '' '']);
ylim([-3000 5000])
set (gca,'ytick',[-3000 0 3000 5000]);
set (gca,'yticklabel',[-3 0 3 5]);
set (gca,'TickLength',[0.02 0.02]);
title('A','FontSize',12,'FontName','Times New Roman','FontWeight','bold')
ylabel({'Voltage','(mV)'},'FontSize',12,'FontName','Times New Roman','FontWeight','normal');
% xlabel('Time (min)','FontSize',12,'FontName','Arial');
hold off;

subplot(4,4,5)
plot([offsetwin(f) offsetwin(f)], [0 10],'r','LineWidth',1);
hold on;
plot([EMDonset(ch,1) EMDonset(ch,1)], [0 10],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
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

%Patient 2 Sz 2 Channel 97
%load data
load('E:\data\human CNS\EMD\Sz\ProcData\CAR\2013PP01Sz2_CAR')
%load windowed data
load('E:\data\human CNS\EMD\Sz\WinData\NEW\2013PP01Sz2_CAR_Win.mat')

f = 7;
ch =97;

onsetsamps(f,:) = ((str2num(clonset{f}(1:2))*3600)+(str2num(clonset{f}(4:5))*60)+(str2num(clonset{f}(7:8))))*Fs;
clpstrtsamps(f,:) = ((str2num(clpstrt{f}(1:2))*3600)+(str2num(clpstrt{f}(4:5))*60)+(str2num(clpstrt{f}(7:8))))*Fs;
offsetsamps(f,:) = onsetsamps(f,:) - clpstrtsamps(f,:);
offsetwin(f,:) = floor((offsetsamps(f,:)/Fs)/3);

x = data(ch,:)-nanmean(data(ch,:));

subplot(4,4,2)
plot([offsetsamps(f) offsetsamps(f)], [-3000 5000],'r','LineWidth',1);
hold on;
plot([(EMDonset(ch,1)*1500) (EMDonset(ch,1)*1500)], [-3000 5000],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
plot(x,'k');
% set(gca,'OuterPosition',[0.74 0.5 0.22 0.45])
xlim([0 300000]);
set (gca,'xtick',[0 60000 120000 180000 240000 300000]);
set (gca,'xticklabel',['' '' '' '' '' '']);
ylim([-1000 1000])
set (gca,'ytick',[-1000 0 1000]);
set (gca,'yticklabel',{['' '' '']});
set (gca,'TickLength',[0.02 0.02]);
title('B','FontSize',12,'FontName','Times New Roman','FontWeight','bold')
% ylabel('Voltage (mV)','FontSize',12,'FontName','Arial');
% xlabel('Time (min)','FontSize',12,'FontName','Arial');
hold off;

subplot(4,4,6)
plot([offsetwin(f) offsetwin(f)], [0 10],'r','LineWidth',1);
hold on;
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


%Patient 3 Sz 9  Channel 82
%load data
load('E:\data\human CNS\EMD\Sz\ProcData\CAR\2014PP01Sz9_CAR')
%load windowed data
load('E:\data\human CNS\EMD\Sz\WinData\NEW\2014PP01Sz9_CAR_Win.mat')

f = 14;
ch =49;

onsetsamps(f,:) = ((str2num(clonset{f}(1:2))*3600)+(str2num(clonset{f}(4:5))*60)+(str2num(clonset{f}(7:8))))*Fs;
clpstrtsamps(f,:) = ((str2num(clpstrt{f}(1:2))*3600)+(str2num(clpstrt{f}(4:5))*60)+(str2num(clpstrt{f}(7:8))))*Fs;
offsetsamps(f,:) = onsetsamps(f,:) - clpstrtsamps(f,:);
offsetwin(f,:) = floor((offsetsamps(f,:)/Fs)/3);

x = data(ch,:)-nanmean(data(ch,:));

subplot(4,4,3)
plot([offsetsamps(f) offsetsamps(f)], [-3000 5000],'r','LineWidth',1);
hold on;
plot([(EMDonset(ch,1)*1500) (EMDonset(ch,1)*1500)], [-3000 5000],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
plot(x,'k');
% set(gca,'OuterPosition',[0.74 0.5 0.22 0.45])
xlim([0 300000]);
set (gca,'xtick',[0 60000 120000 180000 240000 300000]);
set (gca,'xticklabel',['' '' '' '' '' '']);
ylim([-1000 1000])
set (gca,'ytick',[-1000 0 1000]);
set (gca,'yticklabel',{['' '' '']});
set (gca,'TickLength',[0.02 0.02]);
title('C','FontSize',12,'FontName','Times New Roman','FontWeight','bold')
% ylabel('Voltage (mV)','FontSize',12,'FontName','Arial');
% xlabel('Time (min)','FontSize',12,'FontName','Arial');
hold off;

subplot(4,4,7)
plot([offsetwin(f) offsetwin(f)], [0 10],'r','LineWidth',1);
hold on;
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



%Patient 4 Sz 3 channel 73
%load data
load('E:\data\human CNS\EMD\Sz\ProcData\CAR\2014PP02Sz3_CAR')
%load windowed data
load('E:\data\human CNS\EMD\Sz\WinData\NEW\2014PP02Sz3_CAR_Win.mat')

f = 17;
ch =73;

onsetsamps(f,:) = ((str2num(clonset{f}(1:2))*3600)+(str2num(clonset{f}(4:5))*60)+(str2num(clonset{f}(7:8))))*Fs;
clpstrtsamps(f,:) = ((str2num(clpstrt{f}(1:2))*3600)+(str2num(clpstrt{f}(4:5))*60)+(str2num(clpstrt{f}(7:8))))*Fs;
offsetsamps(f,:) = onsetsamps(f,:) - clpstrtsamps(f,:);
offsetwin(f,:) = floor((offsetsamps(f,:)/Fs)/3);

x = data(ch,:)-nanmean(data(ch,:));

subplot(4,4,4)
plot([offsetsamps(f) offsetsamps(f)], [-3000 5000],'r','LineWidth',1);
hold on;
plot([(EMDonset(ch,1)*1500) (EMDonset(ch,1)*1500)], [-3000 5000],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
% legend ('Clinical Onset','EMD Onset')
plot(x,'k');
% set(gca,'OuterPosition',[0.74 0.5 0.22 0.45])
xlim([0 300000]);
set (gca,'xtick',[0 60000 120000 180000 240000 300000]);
set (gca,'xticklabel',['' '' '' '' '' '']);
ylim([-500 500])
set (gca,'ytick',[-500 0 500]);
set (gca,'yticklabel',{['' '' '']});
set (gca,'TickLength',[0.02 0.02]);
title('D','FontSize',12,'FontName','Times New Roman','FontWeight','bold')
% ylabel('Voltage (mV)','FontSize',12,'FontName','Arial');
% xlabel('Time (min)','FontSize',12,'FontName','Arial');
hold off;

subplot(4,4,8)
plot([offsetwin(f) offsetwin(f)], [0 10],'r','LineWidth',1);
hold on;
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
xlabel('Time (min)','FontSize',12,'FontName','Times New Roman','FontWeight','normal');
hold off;



% Patient 5 Sz 4 Channel 70
%load data
load('E:\data\human CNS\EMD\Sz\ProcData\CAR\2014PP04Sz4_CAR')
%load windowed data
load('E:\data\human CNS\EMD\Sz\WinData\NEW\2014PP04Sz4_CAR_Win.mat')

f = 25;
ch =70;

onsetsamps(f,:) = ((str2num(clonset{f}(1:2))*3600)+(str2num(clonset{f}(4:5))*60)+(str2num(clonset{f}(7:8))))*Fs;
clpstrtsamps(f,:) = ((str2num(clpstrt{f}(1:2))*3600)+(str2num(clpstrt{f}(4:5))*60)+(str2num(clpstrt{f}(7:8))))*Fs;
offsetsamps(f,:) = onsetsamps(f,:) - clpstrtsamps(f,:);
offsetwin(f,:) = floor((offsetsamps(f,:)/Fs)/3);

x = data(ch,:)-nanmean(data(ch,:));

subplot(4,4,9)
plot([offsetsamps(f) offsetsamps(f)], [-3000 5000],'r','LineWidth',1);
hold on;
plot([(EMDonset(ch,1)*1500) (EMDonset(ch,1)*1500)], [-3000 5000],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
plot(x,'k');
% % set(gca,'OuterPosition',[0.273 0.5 0.21 0.45])
xlim([0 300000]);
set (gca,'xtick',[0 60000 120000 180000 240000 300000]);
set (gca,'xticklabel',['' '' '' '' '' '']);
ylim([-2000 2000])
set (gca,'ytick',[-2000 0 2000]);
set (gca,'yticklabel',[-2 0 2]);
set (gca,'TickLength',[0.02 0.02]);
title('E','FontSize',12,'FontName','Times New Roman','FontWeight','bold')
ylabel({'Voltage','(mV)'},'FontSize',12,'FontName','Times New Roman','FontWeight','normal');
% xlabel('Time (min)','FontSize',12,'FontName','Arial');
hold off;

subplot(4,4,13)
plot([offsetwin(f) offsetwin(f)], [0 10],'r','LineWidth',1);
hold on;
plot([EMDonset(ch,1) EMDonset(ch,1)], [0 10],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
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



% Patient 6 Sz 1 Channel 8
%load data
load('E:\data\human CNS\EMD\Sz\ProcData\CAR\2014PP05Sz1_CAR')
%load windowed data
load('E:\data\human CNS\EMD\Sz\WinData\NEW\2014PP05Sz1_CAR_Win.mat')

f = 38;
ch =8;

onsetsamps(f,:) = ((str2num(clonset{f}(1:2))*3600)+(str2num(clonset{f}(4:5))*60)+(str2num(clonset{f}(7:8))))*1000;
clpstrtsamps(f,:) = ((str2num(clpstrt{f}(1:2))*3600)+(str2num(clpstrt{f}(4:5))*60)+(str2num(clpstrt{f}(7:8))))*1000;
offsetsamps(f,:) = onsetsamps(f,:) - clpstrtsamps(f,:);
offsetwin(f,:) = floor((offsetsamps(f,:)/1000)/3);

x = data(ch,:)-nanmean(data(ch,:));

subplot(4,4,10)
plot([offsetsamps(f) offsetsamps(f)], [-3000 5000],'r','LineWidth',1);
hold on;
plot([(EMDonset(ch,1)*3000) (EMDonset(ch,1)*3000)], [-3000 5000],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
plot(x,'k');
% set(gca,'OuterPosition',[0.74 0.5 0.22 0.45])
xlim([0 600000]);
set (gca,'xtick',[0 120000 240000 360000 480000 600000]);
set (gca,'xticklabel',['' '' '' '' '' '']);
ylim([-2000 2000])
set (gca,'ytick',[-2000 0 2000]);
set (gca,'yticklabel',{['' '' '']});
set (gca,'TickLength',[0.02 0.02]);
title('F','FontSize',12,'FontName','Times New Roman','FontWeight','bold')
% ylabel('Voltage (mV)','FontSize',12,'FontName','Arial');
% xlabel('Time (min)','FontSize',12,'FontName','Arial');
hold off;

subplot(4,4,14)
plot([offsetwin(f) offsetwin(f)], [0 10],'r','LineWidth',1);
hold on;
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


% Patient 7 Sz 7 Channel 79
%load data
load('E:\data\human CNS\EMD\Sz\ProcData\CAR\2014PP06Sz7_CAR')
%load windowed data
load('E:\data\human CNS\EMD\Sz\WinData\NEW\2014PP06Sz7_CAR_Win.mat')

f = 54;
ch =79;

onsetsamps(f,:) = ((str2num(clonset{f}(1:2))*3600)+(str2num(clonset{f}(4:5))*60)+(str2num(clonset{f}(7:8))))*Fs;
clpstrtsamps(f,:) = ((str2num(clpstrt{f}(1:2))*3600)+(str2num(clpstrt{f}(4:5))*60)+(str2num(clpstrt{f}(7:8))))*Fs;
offsetsamps(f,:) = onsetsamps(f,:) - clpstrtsamps(f,:);
offsetwin(f,:) = floor((offsetsamps(f,:)/Fs)/3);

x = data(ch,:)-nanmean(data(ch,:));

subplot(4,4,11)
plot([offsetsamps(f) offsetsamps(f)], [-3000 5000],'r','LineWidth',1);
hold on;
plot([(EMDonset(ch,1)*1500) (EMDonset(ch,1)*1500)], [-3000 5000],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
plot(x,'k');
% set(gca,'OuterPosition',[0.507 0.5 0.21 0.45])
xlim([0 300000]);
set (gca,'xtick',[0 60000 120000 180000 240000 300000]);
set (gca,'xticklabel',['' '' '' '' '' '']);
ylim([-2000 2000])
set (gca,'ytick',[-2000 0 2000]);
set (gca,'yticklabel',{['' '' '']});
set (gca,'TickLength',[0.02 0.02]);
title('G','FontSize',12,'FontName','Times New Roman','FontWeight','bold')
% ylabel('Voltage (mV)','FontSize',12,'FontName','Arial');
% xlabel('Time (min)','FontSize',12,'FontName','Arial');
hold off;

subplot(4,4,15)
% set(gca,'Position',[0 0 1 1])
plot([offsetwin(f) offsetwin(f)], [0 10],'r','LineWidth',1);
hold on;
plot([EMDonset(ch,1) EMDonset(ch,1)], [0 10],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
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

% Patient 8 Sz 5 Channel 43
%load data
load('E:\data\human CNS\EMD\Sz\ProcData\CAR\2014PP07Sz3_CAR')
%load windowed data
load('E:\data\human CNS\EMD\Sz\WinData\NEW\2014PP07Sz3_CAR_Win.mat')

f = 67;
ch =75;

onsetsamps(f,:) = ((str2num(clonset{f}(1:2))*3600)+(str2num(clonset{f}(4:5))*60)+(str2num(clonset{f}(7:8))))*Fs;
clpstrtsamps(f,:) = ((str2num(clpstrt{f}(1:2))*3600)+(str2num(clpstrt{f}(4:5))*60)+(str2num(clpstrt{f}(7:8))))*Fs;
offsetsamps(f,:) = onsetsamps(f,:) - clpstrtsamps(f,:);
offsetwin(f,:) = floor((offsetsamps(f,:)/Fs)/3);

x = data(ch,:)-nanmean(data(ch,:));

subplot(4,4,12)
plot([offsetsamps(f) offsetsamps(f)], [-3000 5000],'r','LineWidth',1);
hold on;
plot([(EMDonset(ch,1)*1500) (EMDonset(ch,1)*1500)], [-3000 5000],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
plot(x,'k');
% set(gca,'OuterPosition',[0.74 0.5 0.22 0.45])
xlim([0 300000]);
set (gca,'xtick',[0 60000 120000 180000 240000 300000]);
set (gca,'xticklabel',['' '' '' '' '' '']);
ylim([-3000 5000])
set (gca,'ytick',[-3000 0 3000 5000]);
set (gca,'yticklabel',{['' '' '' '']});
set (gca,'TickLength',[0.02 0.02]);
title('H','FontSize',12,'FontName','Times New Roman','FontWeight','bold')
% ylabel('Voltage (mV)','FontSize',12,'FontName','Arial');
% xlabel('Time (min)','FontSize',12,'FontName','Arial');
hold off;

subplot(4,4,16)
plot([offsetwin(f) offsetwin(f)], [0 10],'r','LineWidth',1);
hold on;
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

%% Figure 2

[~,clpstrt] = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','J3:J100');
Fs = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','H3:H100');
sznum = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','E3:E100');
[~,clonset] = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','L3:L100');

% Patient 1 Sz 1
%load data
load('E:\data\human CNS\EMD\Sz\ProcData\CAR\2012PP05Sz1_CAR')
%load windowed data
load('E:\data\human CNS\EMD\Sz\WinData\NEW\2012PP05Sz1_CAR_Win.mat')
f = 1;

clonsetsamps(f,:) = (str2double(clonset{f}(1:2))*3600 + str2double(clonset{f}(4:5))*60 + str2double(clonset{f}(7:8)))*Fs(f);
clpstrtsamps(f,:) = (str2double(clpstrt{f}(1:2))*3600 + str2double(clpstrt{f}(4:5))*60 + str2double(clpstrt{f}(7:8)))*Fs(f);
offsetsamps(f) = clonsetsamps(f,:) - clpstrtsamps(f,:);
onsetwin(f) = floor(offsetsamps(f)/(Fs(f)*3));

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
plot([onsetwin(f) onsetwin(f)],[0 65],'color','r','LineWidth',1);
hold on;
plot([idx idx], [0 65],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
plot(ss,'k')
ylabel('Number of Onsets','FontName','Times New Roman','FontSize',12)
ylim([0 65])
set (gca,'ytick',[0 10 20 30 40 50 60]);
set (gca,'yticklabel',[0 10 20 30 40 50 60]);
set (gca,'TickLength',[0.02 0.02]);
xlim([0 200])
set (gca,'xtick',[0 40 80 120 160 200]);
hold off;

subplot(4,4,1);
plot([onsetwin(f) onsetwin(f)],[0 121],'color','r','LineWidth',1);
hold on;
plot([idx idx], [0 121],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
plot(EMDonset(rs,:),rs,'k.')
title('A','FontName','Times New Roman','FontSize',12,'FontWeight','bold')
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
load('E:\data\human CNS\EMD\Sz\ProcData\CAR\2013PP01Sz2_CAR')
%load windowed data
load('E:\data\human CNS\EMD\Sz\WinData\NEW\2013PP01Sz2_CAR_Win.mat')
f = 7;

clonsetsamps(f,:) = (str2double(clonset{f}(1:2))*3600 + str2double(clonset{f}(4:5))*60 + str2double(clonset{f}(7:8)))*Fs(f);
clpstrtsamps(f,:) = (str2double(clpstrt{f}(1:2))*3600 + str2double(clpstrt{f}(4:5))*60 + str2double(clpstrt{f}(7:8)))*Fs(f);
offsetsamps(f) = clonsetsamps(f,:) - clpstrtsamps(f,:);
onsetwin(f) = floor(offsetsamps(f)/(Fs(f)*3));

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
plot([onsetwin(f) onsetwin(f)],[0 65],'color','r','LineWidth',1);
hold on;
plot([idx idx], [0 65],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
plot(ss,'k')
ylabel('Number of Onsets','FontName','Times New Roman','FontSize',12)
ylim([0 65])
set (gca,'ytick',[0 10 20 30 40 50 60]);
set (gca,'yticklabel',[0 10 20 30 40 50 60]);
set (gca,'TickLength',[0.02 0.02]);
xlim([0 200])
set (gca,'xtick',[0 40 80 120 160 200]);
hold off;

subplot(4,4,2);
plot([onsetwin(f) onsetwin(f)],[0 121],'color','r','LineWidth',1);
hold on;
plot([idx idx], [0 121],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
plot(EMDonset(rs,:),rs,'k.')
title('B','FontName','Times New Roman','FontSize',12,'FontWeight','bold')
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
load('E:\data\human CNS\EMD\Sz\ProcData\CAR\2014PP01Sz9_CAR')
%load windowed data
load('E:\data\human CNS\EMD\Sz\WinData\NEW\2014PP01Sz9_CAR_Win.mat')
f = 14;


clonsetsamps(f,:) = (str2double(clonset{f}(1:2))*3600 + str2double(clonset{f}(4:5))*60 + str2double(clonset{f}(7:8)))*Fs(f);
clpstrtsamps(f,:) = (str2double(clpstrt{f}(1:2))*3600 + str2double(clpstrt{f}(4:5))*60 + str2double(clpstrt{f}(7:8)))*Fs(f);
offsetsamps(f) = clonsetsamps(f,:) - clpstrtsamps(f,:);
onsetwin(f) = floor(offsetsamps(f)/(Fs(f)*3));

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
plot([onsetwin(f) onsetwin(f)],[0 65],'color','r','LineWidth',1);
hold on;
plot([idx idx], [0 65],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
plot(ss,'k')
ylabel('Number of Onsets','FontName','Times New Roman','FontSize',12)
ylim([0 65])
set (gca,'ytick',[0 10 20 30 40 50 60]);
set (gca,'yticklabel',[0 10 20 30 40 50 60]);
set (gca,'TickLength',[0.02 0.02]);
xlim([0 200])
set (gca,'xtick',[0 40 80 120 160 200]);
hold off;

subplot(4,4,3);
plot([onsetwin(f) onsetwin(f)],[0 121],'color','r','LineWidth',1);
hold on;
plot([idx idx], [0 121],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
plot(EMDonset(rs,:),rs,'k.')
title('C','FontName','Times New Roman','FontSize',12,'FontWeight','bold')
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


% Patient 4 Seizure 3
%load data
load('E:\data\human CNS\EMD\Sz\ProcData\CAR\2014PP02Sz3_CAR')
%load windowed data
load('E:\data\human CNS\EMD\Sz\WinData\NEW\2014PP02Sz3_CAR_Win.mat')
f = 17;

clonsetsamps(f,:) = (str2double(clonset{f}(1:2))*3600 + str2double(clonset{f}(4:5))*60 + str2double(clonset{f}(7:8)))*Fs(f);
clpstrtsamps(f,:) = (str2double(clpstrt{f}(1:2))*3600 + str2double(clpstrt{f}(4:5))*60 + str2double(clpstrt{f}(7:8)))*Fs(f);
offsetsamps(f) = clonsetsamps(f,:) - clpstrtsamps(f,:);
onsetwin(f) = floor(offsetsamps(f)/(Fs(f)*3));

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
plot([onsetwin(f) onsetwin(f)],[0 65],'color','r','LineWidth',1);
hold on;
plot([idx idx], [0 65],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
plot(ss,'k')
ylabel('Number of Onsets','FontName','Times New Roman','FontSize',12)
ylim([0 65])
set (gca,'ytick',[0 10 20 30 40 50 60]);
set (gca,'yticklabel',[0 10 20 30 40 50 60]);
set (gca,'TickLength',[0.02 0.02]);
xlim([0 200])
set (gca,'xtick',[0 40 80 120 160 200]);
hold off;

subplot(4,4,4);
plot([onsetwin(f) onsetwin(f)],[0 121],'color','r','LineWidth',1);
hold on;
plot([idx idx], [0 121],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
plot(EMDonset(rs,:),rs,'k.')
title('D','FontName','Times New Roman','FontSize',12,'FontWeight','bold')
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
load('E:\data\human CNS\EMD\Sz\ProcData\CAR\2014PP04Sz4_CAR')
%load windowed data
load('E:\data\human CNS\EMD\Sz\WinData\NEW\2014PP04Sz4_CAR_Win.mat')
f = 25;
%4/25

clonsetsamps(f,:) = (str2double(clonset{f}(1:2))*3600 + str2double(clonset{f}(4:5))*60 + str2double(clonset{f}(7:8)))*Fs(f);
clpstrtsamps(f,:) = (str2double(clpstrt{f}(1:2))*3600 + str2double(clpstrt{f}(4:5))*60 + str2double(clpstrt{f}(7:8)))*Fs(f);
offsetsamps(f) = clonsetsamps(f,:) - clpstrtsamps(f,:);
onsetwin(f) = floor(offsetsamps(f)/(Fs(f)*3));

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
plot([onsetwin(f) onsetwin(f)],[0 65],'color','r','LineWidth',1);
hold on;
plot([idx idx], [0 65],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
plot(ss,'k')
ylabel('Number of Onsets','FontName','Times New Roman','FontSize',12)
ylim([0 65])
set (gca,'ytick',[0 10 20 30 40 50 60]);
set (gca,'yticklabel',[0 10 20 30 40 50 60]);
set (gca,'TickLength',[0.02 0.02]);
xlim([0 200])
set (gca,'xtick',[0 40 80 120 160 200]);
hold off;

subplot(4,4,9);
plot([onsetwin(f) onsetwin(f)],[0 121],'color','r','LineWidth',1);
hold on;
plot([idx idx], [0 121],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
plot(EMDonset(rs,:),rs,'k.')
title('E','FontName','Times New Roman','FontSize',12,'FontWeight','bold')
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
load('E:\data\human CNS\EMD\Sz\ProcData\CAR\2014PP05Sz1_CAR')
%load windowed data
load('E:\data\human CNS\EMD\Sz\WinData\NEW\2014PP05Sz1_CAR_Win.mat')
f = 38;


clonsetsamps(f,:) = (str2double(clonset{f}(1:2))*3600 + str2double(clonset{f}(4:5))*60 + str2double(clonset{f}(7:8)))*Fs(f);
clpstrtsamps(f,:) = (str2double(clpstrt{f}(1:2))*3600 + str2double(clpstrt{f}(4:5))*60 + str2double(clpstrt{f}(7:8)))*Fs(f);
offsetsamps(f) = clonsetsamps(f,:) - clpstrtsamps(f,:);
onsetwin(f) = floor(offsetsamps(f)/(Fs(f)*3));

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
plot([onsetwin(f) onsetwin(f)],[0 65],'color','r','LineWidth',1);
hold on;
plot([idx idx], [0 65],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
plot(ss,'k')
ylabel('Number of Onsets','FontName','Times New Roman','FontSize',12)
ylim([0 65])
set (gca,'ytick',[0 10 20 30 40 50 60]);
set (gca,'yticklabel',[0 10 20 30 40 50 60]);
set (gca,'TickLength',[0.02 0.02]);
xlim([0 200])
set (gca,'xtick',[0 40 80 120 160 200]);
hold off;

subplot(4,4,10);
plot([onsetwin(f) onsetwin(f)],[0 121],'color','r','LineWidth',1);
hold on;
plot([idx idx], [0 121],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
plot(EMDonset(rs,:),rs,'k.')
title('F','FontName','Times New Roman','FontSize',12,'FontWeight','bold')
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
load('E:\data\human CNS\EMD\Sz\ProcData\CAR\2014PP06Sz7_CAR')
%load windowed data
load('E:\data\human CNS\EMD\Sz\WinData\NEW\2014PP06Sz7_CAR_Win.mat')
f = 54;


clonsetsamps(f,:) = (str2double(clonset{f}(1:2))*3600 + str2double(clonset{f}(4:5))*60 + str2double(clonset{f}(7:8)))*Fs(f);
clpstrtsamps(f,:) = (str2double(clpstrt{f}(1:2))*3600 + str2double(clpstrt{f}(4:5))*60 + str2double(clpstrt{f}(7:8)))*Fs(f);
offsetsamps(f) = clonsetsamps(f,:) - clpstrtsamps(f,:);
onsetwin(f) = floor(offsetsamps(f)/(Fs(f)*3));

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
plot([onsetwin(f) onsetwin(f)],[0 65],'color','r','LineWidth',1);
hold on;
plot([idx idx], [0 65],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
plot(ss,'k')
ylabel('Number of Onsets','FontName','Times New Roman','FontSize',12)
ylim([0 65])
set (gca,'ytick',[0 10 20 30 40 50 60]);
set (gca,'yticklabel',[0 10 20 30 40 50 60]);
set (gca,'TickLength',[0.02 0.02]);
xlim([0 200])
set (gca,'xtick',[0 40 80 120 160 200]);
hold off;

subplot(4,4,11);
plot([onsetwin(f) onsetwin(f)],[0 121],'color','r','LineWidth',1);
hold on;
plot([idx idx], [0 121],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
plot(EMDonset(rs,:),rs,'k.')
title('G','FontName','Times New Roman','FontSize',12,'FontWeight','bold')
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
load('E:\data\human CNS\EMD\Sz\ProcData\CAR\2014PP07Sz5_CAR')
%load windowed data
load('E:\data\human CNS\EMD\Sz\WinData\NEW\2014PP07Sz5_CAR_Win.mat')
f = 67;


clonsetsamps(f,:) = (str2double(clonset{f}(1:2))*3600 + str2double(clonset{f}(4:5))*60 + str2double(clonset{f}(7:8)))*Fs(f);
clpstrtsamps(f,:) = (str2double(clpstrt{f}(1:2))*3600 + str2double(clpstrt{f}(4:5))*60 + str2double(clpstrt{f}(7:8)))*Fs(f);
offsetsamps(f) = clonsetsamps(f,:) - clpstrtsamps(f,:);
onsetwin(f) = floor(offsetsamps(f)/(Fs(f)*3));

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

% ee= sum(sum(~isnan(EMDonset(rs,:))));
% elecevents = [elecevents ee];
% 
% EMDoffset = EMDonset - onsetwin(end);
% avgoff = nanmean(nanmean(EMDoffset));
% EMDavg = [EMDavg avgoff];


subplot(4,4,16)
plot([onsetwin(f) onsetwin(f)],[0 65],'color','r','LineWidth',1);
hold on;
plot([idx idx], [0 65],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
plot(ss,'k')
ylabel('Number of Onsets','FontName','Times New Roman','FontSize',12)
ylim([0 65])
set (gca,'ytick',[0 10 20 30 40 50 60]);
set (gca,'yticklabel',[0 10 20 30 40 50 60]);
set (gca,'TickLength',[0.02 0.02]);
xlim([0 200])
set (gca,'xtick',[0 40 80 120 160 200]);
hold off;

subplot(4,4,12);
plot([onsetwin(f) onsetwin(f)],[0 121],'color','r','LineWidth',1);
hold on;
plot([idx idx], [0 121],'color',[0 0.7 0],'LineStyle','--','LineWidth',1);
plot(EMDonset(rs,:),rs,'k.')
title('H','FontName','Times New Roman','FontSize',12,'FontWeight','bold')
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

[~,clpstrt] = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','J3:J100');
sznum = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','E3:E100');
[~,clonset] = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','L3:L100');
Fs = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','H3:H100');


%Seizure
files = dir(['E:\data\human CNS\EMD\Sz\WinData\NEW\', '*.mat']);

for f = 1:size(files,1)
    patnum{f} = files(f).name(1:10);
end
ptnum = unique(patnum);

for f = 1:size(files,1)
    iddash = strfind(files(f).name,'_');
    patnum{f} = files(f).name(1:(iddash-1));
end

pltinfo = {'.b' '.r' '.g' '.c' '.m' '.k' '+b' '+r' '+g' '+c' '+m' '+k' 'ob' 'or' 'og' 'oc' 'om' 'ok'};
threshold = {'mode' 'avg' 'var'};

for p = 1
    filecomp{p} = strncmp(ptnum(p),patnum,8);
    [~,c]= find(filecomp{p}==1);
    disp (ptnum{p})
    
    allsz.var = [];
    
    figure;

    for f = c(1):c(end)%convert seizure onset and clip start times to number of samples
        
        name = strcat(ptnum(p),num2str(sznum(f)));
        load(['E:\data\human CNS\EMD\Sz\WinData\NEW\',name{1},'_CAR_Win.mat']); %seizure
                
        clonsetsamps(f,:) = (str2double(clonset{f}(1:2))*3600 + str2double(clonset{f}(4:5))*60 + str2double(clonset{f}(7:8)))*Fs(f);
        clpstrtsamps(f,:) = (str2double(clpstrt{f}(1:2))*3600 + str2double(clpstrt{f}(4:5))*60 + str2double(clpstrt{f}(7:8)))*Fs(f);
        offsetsamps(f) = clonsetsamps(f,:) - clpstrtsamps(f,:);
        onsetwin(f) = floor(offsetsamps(f)/(Fs(f)*3));
        
        center = EMDonset - onsetwin(f);
        allsz.var = [allsz.var,center];
                
        s = isnan(center);
        [rs,~] = find(s==0);
        
        subplot(3,2,1);
%         set(subplot(3,1,1),'Position',[0.13 0.709 0.6 0.25]);
        plot([0 0],[0 121],'color','r','LineWidth',1);
        hold on;
        plot(center(rs,:),rs,pltinfo{sznum(f)})
        ylabel('Electrodes','FontName','Times New Roman','FontSize',12)
        xlim([-100 100])
        set (gca,'xtick',[-100 -80 -60 -40 -20 0 20 40 60 80 100]);
    set (gca,'xticklabel',['' '' '' '' '' '' '' '' '' '' '']);
        ylim([0 100])
        set(gca,'ytick',[0 25 50 75 100]);
        set(gca,'yticklabel',{'0' '' '50' '' '100'});
        set (gca,'TickLength',[0.01 0.01]);
        hold on
        clear rm ra rs
        
        ww = 1;
        for w = -100:100
            [rs,~] = find(center == w);
            id{ww} = rs;
            ws(ww,:) =size(rs,1);
            ww = ww+1;
        end
        
        total{p}(f,:)= ws;
        clear rm ra rs
        
        y = [-100:1:100];
        plt = {'b' 'r' 'g' 'c' 'm' 'k' '--b' '--r' '--g' '--c' '--m' '--k' '-.b' '-.r' '-.g' '-.c' '-.m' '-.k'};
        
       subplot(3,2,3);
%         set(subplot(3,1,2),'Position',[0.13 0.409 0.6 0.25])
%         subplot(3,1,2)
        plot([0 0],[0 25],'color','r','LineWidth',1);
        hold on;
        plot(y,ws,plt{sznum(f)});
        hold on;
        ylabel({'Number of Onsets', 'Per Seizure'},'FontName','Times New Roman','FontSize',12)
        xlim([-100 100])
        set (gca,'xtick',[-100 -80 -60 -40 -20 0 20 40 60 80 100]);
        set (gca,'xticklabel',['' '' '' '' '' '' '' '' '' '' '']);
        ylim([0 25])
        set(gca,'ytick',[0 5 10 15 20])
        set (gca,'yticklabel',{'0' '' '' '' '20'});
        set (gca,'TickLength',[0.01 0.01]);
        hold on
        clear EMDonset
        
    end
    
    tt=-100:5:100;
    for t = 1:size(tt,2)-1
        [idch,~] = find(allsz.var > tt(t)& allsz.var < tt(t+1));
        ss(t,:) = size(idch,1);
    end
    
   subplot(3,2,5);
%     set(subplot(3,1,3),'Position',[0.13 0.11 0.6 0.25]);
%     set(gca,'Position',[0.13 0.11 0.6 0.25])
%     subplot(3,1,3)
    plot([0 0],[0 150],'color','r','LineWidth',1);
    hold on;
    h = histogram(allsz.var,20,'BinLimits',[-100 100],'FaceColor',[0 0 0],'FaceAlpha',1);
    ylabel('Number of Onsets','FontName','Times New Roman','FontSize',12)
    xlabel('Window Relative to Clinically Determined Seizure Onset','FontName','Times New Roman','FontSize',12)
    xlim([-100 100]) 
    ylim([0 150])
    set (gca,'xtick',[-100 -80 -60 -40 -20 0 20 40 60 80 100]);
    set (gca,'xticklabel',{'-5' '' '' '' '' '0' '' '' '' '' '5'});
    set(gca,'ytick',[0 50 100 150]);
    set(gca,'yticklabel',{'0' '' '100' ''});
    set (gca,'TickLength',[0.01 0.01]);
    
    clear allsz tt t ss edgess
end

%example of bad
clear all

[~,clpstrt] = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','J3:J100');
sznum = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','E3:E100');
[~,clonset] = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','L3:L100');
Fs = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','H3:H100');

%
%
%Seizure
files = dir(['E:\data\human CNS\EMD\Sz\WinData\NEW\', '*.mat']);

for f = 1:size(files,1)
    patnum{f} = files(f).name(1:10);
end
ptnum = unique(patnum);

for f = 1:size(files,1)
    iddash = strfind(files(f).name,'_');
    patnum{f} = files(f).name(1:(iddash-1));
end

pltinfo = {'.b' '.r' '.g' '.c' '.m' '.k' '+b' '+r' '+g' '+c' '+m' '+k' 'ob' 'or' 'og' 'oc' 'om' 'ok'};
threshold = {'mode' 'avg' 'var'};

for p = 4
    filecomp{p} = strncmp(ptnum(p),patnum,8);
    [~,c]= find(filecomp{p}==1);
    disp (ptnum{p})
    
    allsz.var = [];
    
    for f = c(1):c(end)%convert seizure onset and clip start times to number of samples
        
        name = strcat(ptnum(p),num2str(sznum(f)));
        load(['E:\data\human CNS\EMD\Sz\WinData\NEW\',name{1},'_CAR_Win.mat']); %seizure
                
        clonsetsamps(f,:) = (str2double(clonset{f}(1:2))*3600 + str2double(clonset{f}(4:5))*60 + str2double(clonset{f}(7:8)))*Fs(f);
        clpstrtsamps(f,:) = (str2double(clpstrt{f}(1:2))*3600 + str2double(clpstrt{f}(4:5))*60 + str2double(clpstrt{f}(7:8)))*Fs(f);
        offsetsamps(f) = clonsetsamps(f,:) - clpstrtsamps(f,:);
        onsetwin(f) = floor(offsetsamps(f)/(Fs(f)*3));
        
        center = EMDonset - onsetwin(f);
        allsz.var = [allsz.var,center];
                
        s = isnan(center);
        [rs,~] = find(s==0);
        
        subplot(3,2,2);
        plot([0 0],[0 121],'color','r','LineWidth',1);
        hold on;
        plot([-100 100],[65 65],'color',[0.5 0.5 0.5],'LineWidth',1);
        plot([-100 100],[76 76],'color',[0.5 0.5 0.5],'LineWidth',1);
        plot(center(rs,:),rs,pltinfo{sznum(f)})
        ylabel('Electrodes','FontName','Times New Roman','FontSize',12)
        xlim([-100 100])
        set (gca,'xtick',[-100 -80 -60 -40 -20 0 20 40 60 80 100]);
    set (gca,'xticklabel',['' '' '' '' '' '' '' '' '' '' '']);
        ylim([0 100])
        set(gca,'ytick',[0 25 50 75 100]);
        set(gca,'yticklabel',{'0' '' '50' '' '100'});
        set (gca,'TickLength',[0.01 0.01]);
        hold on
        clear rm ra rs
        
        ww = 1;
        for w = -100:100
            [rs,~] = find(center == w);
            id{ww} = rs;
            ws(ww,:) =size(rs,1);
            ww = ww+1;
        end
        
        total{p}(f,:)= ws;
        clear rm ra rs
        
        y = [-100:1:100];
        plt = {'b' 'r' 'g' 'c' 'm' 'k' '--b' '--r' '--g' '--c' '--m' '--k' '-.b' '-.r' '-.g' '-.c' '-.m' '-.k'};
        
       subplot(3,2,4);
%         set(subplot(3,1,2),'Position',[0.13 0.409 0.6 0.25])
%         subplot(3,1,2)
        plot([0 0],[0 25],'color','r','LineWidth',1);
        hold on;
        plot(y,ws,plt{sznum(f)});
        hold on;
        ylabel({'Number of Onsets', 'Per Seizure'},'FontName','Times New Roman','FontSize',12)
        xlim([-100 100])
        set (gca,'xtick',[-100 -80 -60 -40 -20 0 20 40 60 80 100]);
        set (gca,'xticklabel',['' '' '' '' '' '' '' '' '' '' '']);
        ylim([0 25])
        set(gca,'ytick',[0 5 10 15 20 25])
        set (gca,'yticklabel',{'0' '' '' '' '' '25'});
        set (gca,'TickLength',[0.01 0.01]);
        hold on
        clear EMDonset
        
    end
    
    tt=-100:5:100;
    for t = 1:size(tt,2)-1
        [idch,~] = find(allsz.var > tt(t)& allsz.var < tt(t+1));
        ss(t,:) = size(idch,1);
    end
    
   subplot(3,2,6);
%     set(subplot(3,1,3),'Position',[0.13 0.11 0.6 0.25]);
%     set(gca,'Position',[0.13 0.11 0.6 0.25])
%     subplot(3,1,3)
    plot([0 0],[0 200],'color','r','LineWidth',1);
    hold on;
    h = histogram(allsz.var,20,'BinLimits',[-100 100],'FaceColor',[0 0 0],'FaceAlpha',1);
    ylabel('Number of Onsets','FontName','Times New Roman','FontSize',12)
    xlabel('Window Relative to Clinically Determined Seizure Onset','FontName','Times New Roman','FontSize',12)
    xlim([-100 100]) 
    set (gca,'xtick',[-100 -80 -60 -40 -20 0 20 40 60 80 100]);
    set (gca,'xticklabel',{'-5' '' '' '' '' '0' '' '' '' '' '5'});
    set(gca,'ytick',[0 50 100 150 200]);
    set(gca,'yticklabel',{'0' '' '100' '' '200'});
    set (gca,'TickLength',[0.01 0.01]);
    
    clear allsz tt t ss edgess
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

Fs = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','H3:H100');
sznum = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','E3:E100');

files = dir(['E:\data\human CNS\EMD\Sz\WinData\NEW\', '*.mat']);

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
     allsz{p} = [];  
     
    for f = c(1):c(end)%convert seizure onset and clip start times to number of samples
        
        name = strcat(ptnum(p),num2str(sznum(f)));
        load(['E:\data\human CNS\EMD\Sz\WinData\NEW\',name{1},'_CAR_Win.mat']); %seizure
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
        allsz{p} = [allsz{p},size(rs,1)];
    end
end


%%  Comparing onsets
clear all

[~,clpstrt] = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','J3:J100');
sznum = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','E3:E100');
[~,clonset] = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','L3:L100');
Fs = xlsread('E:\data\human CNS\EMDDatabase.xlsx','Sz','H3:H100');

files = dir(['E:\data\human CNS\EMD\Sz\WinData\NEW\', '*.mat']);

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
    sz = 1;
    allsz=[];
    for f = c(1):c(end)%convert seizure onset and clip start times to number of samples
        
        name = strcat(ptnum(p),num2str(sznum(f)));
        load(['E:\data\human CNS\EMD\Sz\WinData\NEW\',name{1},'_CAR_Win.mat']); %seizure
        
        clonsetsamps(f,:) = (str2double(clonset{f}(1:2))*3600 + str2double(clonset{f}(4:5))*60 + str2double(clonset{f}(7:8)))*Fs(f);
        clpstrtsamps(f,:) = (str2double(clpstrt{f}(1:2))*3600 + str2double(clpstrt{f}(4:5))*60 + str2double(clpstrt{f}(7:8)))*Fs(f);
        offsetsamps(f) = clonsetsamps(f,:) - clpstrtsamps(f,:);
        onsetwin(f) = floor(offsetsamps(f)/(Fs(f)*3));
        
        center = EMDonset - onsetwin(f);
        allsz = [allsz,center];
       sz = sz+1; 
    end
        
        totsz{p}= allsz(~isnan(allsz));
        avg{p}=nanmean(nanmean(allsz,2));
        clear allsz
        
 
end
    
%         idch = ~isnan(onsetchans{p}(sz,:));
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
%         sz = sz+1;
%         clear ch idch id
%     end
% end

%% Flow diagram with data

%load data
load('E:\data\human CNS\EMD\Sz\ProcData\CAR\2012PP05Sz1_CAR')
%load windowed data
load('E:\data\human CNS\EMD\Sz\WinData\NEW\2012PP05Sz1_CAR_Win.mat')

win1 = data(9,(1:2500));
win2 = data(9,(2501:5000));
winsz = data(9,(161000:163499));
winlast = data(9,(297500:(297500+2499)));

figure;
subplot(3,2,1)
plot(data(9,:));
xlim([0 300000]);
hold on;
plot([1 1],[-2000 5000],'color',[0.5 0.5 0.5],'LineWidth',0.5);
plot([2500 2500],[-2000 5000],'color',[0.5 0.5 0.5],'LineWidth',0.5);
plot([1500 1500],[-2000 5000],'color',[0.5 0.5 0.5],'LineWidth',0.5);
plot([4000 4000],[-2000 5000],'color',[0.5 0.5 0.5],'LineWidth',0.5);
plot([163500 163500],[-2000 5000],'color',[0.5 0.5 0.5],'LineWidth',0.5);
plot([166000 166000 ],[-2000 5000],'color',[0.5 0.5 0.5],'LineWidth',0.5);
plot([297500 297500],[-2000 5000],'color',[0.5 0.5 0.5],'LineWidth',0.5);
plot([300000 300000],[-2000 5000],'color',[0.5 0.5 0.5],'LineWidth',0.5);

subplot (3,2,2)
plot(win1);
xlim([0 2500]);

subplot (3,2,3)
plot(win2);
xlim([0 2500]);

subplot (3,2,4)
plot(winsz);
xlim([0 2500]);

subplot (3,2,5)
plot(winlast);
xlim([0 2500]);

subplot(3,2,6)
plot(IMFperWin(9,:),'.')
ylim([0 10])
xlim([0 200])

imfs_win1 = EMD(win1,500);
figure;
subplot(3,2,1)
plot(win1);
xlim([0 2500]);
for k = 1:(size(imfs_win1,2))
subplot(3,2,k+1)
plot(imfs_win1{k})
ylim([-400 300])
xlim([0 2500])
end
subplot(3,2,6)
plot(imfs_win1{5})
xlim([0 2500])

[imfs_win2,residue2] = EMD(win2,500);
figure;
subplot(3,2,1)
plot(win2);
xlim([0 2500]);
for k = 1:(size(imfs_win2,2))
subplot(3,2,k+1)
plot(imfs_win2{k})
ylim([-500 400])
xlim([0 2500])
end
subplot(3,2,6)
plot(imfs_win2{5})
xlim([0 2500])

imfs_winsz = EMD(winsz,500);
figure;
for k = 1:size(imfs_winsz,2)
subplot(3,2,k)
plot(imfs_winsz{k})
ylim([-1500 1200])
xlim([0 2500])
end
subplot(3,2,6)
plot(imfs_winsz{6})
xlim([0 2500])

imfs_winlast = EMD(winlast,500);
figure;
subplot(3,2,1)
plot(winlast);
xlim([0 2500]);
ylim([-700 700])
for k = 1:(size(imfs_winlast,2))
subplot(3,2,k+1)
plot(imfs_winlast{k})
ylim([-700 700])
xlim([0 2500])
end
subplot(3,2,5)
plot(imfs_winlast{4})
xlim([0 2500])
ylim([-700 700])


figure;
for i = 1:size(residue, 2)
subplot(2,2,i)
plot(residue(:,i))
%ylim([-400 300])
xlim([0 2500])
end

figure;
[maxenv,minenv,avgenv]=Envelopes(win1);
subplot(3,2,1)
plot(win1); hold on; plot(maxenv,'g'); plot(minenv,'g'); plot(avgenv,'r')
xlim([0 2500])
ylim([-200 1000])
clear maxenv minenv avgenv
for i = 1:size(residue, 2)
    [maxenv,minenv,avgenv]=Envelopes(residue(:,i));
    subplot(3,2,i+1)
    plot(residue(:,i)); hold on; plot(maxenv,'g'); plot(minenv,'g'); plot(avgenv,'r')
    xlim([0 2500])
    ylim([-200 1000])
    clear maxenv minenv avgenv
end

figure;
[maxenv,minenv,avgenv]=Envelopes(win2);
subplot(3,2,1)
plot(win2); hold on; plot(maxenv,'g'); plot(minenv,'g'); plot(avgenv,'r')
xlim([0 2500])
ylim([-200 1000])
clear maxenv minenv avgenv
for i = 1:size(residue2, 2)
    [maxenv,minenv,avgenv]=Envelopes(residue2(:,i));
    subplot(3,2,i+1)
    plot(residue2(:,i)); hold on; plot(maxenv,'g'); plot(minenv,'g'); plot(avgenv,'r')
    xlim([0 2500])
    ylim([-200 1000])
    clear maxenv minenv avgenv
end
