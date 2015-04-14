% generate figures of zero-lag cross-correlation vs. separation distance
clear all;
close all;
clc;

% set up environment
use('cleanpath');
use('pkgs/skellis');

% define grids
grids=defgrids;

% specify rereferencing
ref='unr';

%% GRID 5: HUMANUEA1
% load data
load(['d:/matlab/ecogres/g5cvd_' upper(ref) '.mat']);

% find common outliers
bad=cell(1,size(rho,2));
for k=1:size(rho,2)
    bad{k}=outliers(rho(:,k));
end
bad=cat(1,bad{:});
unique_bad=sort(unique(bad),'ascend');
common_bad=unique_bad(histc(bad,unique_bad)>=0.2*size(rho,2));
tmprho=rho;
tmprho(common_bad,:)=nan;

% channels (14,6) and (14,92) are about the same distance apart but have
% (8,6) (8,90)
% (1,89) (1,55)
% very different correlations over time
idx1=find(chanpairs(:,1)==8&chanpairs(:,2)==6);
idx2=find(chanpairs(:,1)==8&chanpairs(:,2)==90);
figure
plot(0:4:(size(rho,1)-1)*4,rho(:,idx1)), ylim([0 1])
hold on
plot(0:4:(size(rho,1)-1)*4,rho(:,idx2),'r'), ylim([0 1])
legend({['Ch 8 & 6 (' num2str(avg.pairseps(idx1),3) ' mm)'],...
    ['Ch 8 & 90 (' num2str(avg.pairseps(idx2),3) ' mm)']},...
    'Location','SouthWest');
ylim([-0.2 1]);
grid on;

% save
saveas(gcf,['d:/matlab/ecogres/figures/MCRGRIDT_' grids(5).filename '_' upper(ref) '.fig']);
saveas(gcf,['d:/matlab/ecogres/figures/MCRGRIDT_' grids(5).filename '_' upper(ref) '.png']);
saveas(gcf,['d:/matlab/ecogres/figures/MCRGRIDT_' grids(5).filename '_' upper(ref) '.eps'],'epsc2');

%% GRID 1: SUBDURALMICRO1
% load data
load(['d:/matlab/ecogres/g1cvd_' upper(ref) '.mat']);

% find common outliers
bad=cell(1,size(rho,2));
for k=1:size(rho,2)
    bad{k}=outliers(rho(:,k));
end
bad=cat(1,bad{:});
unique_bad=sort(unique(bad),'ascend');
common_bad=unique_bad(histc(bad,unique_bad)>=0.2*size(rho,2));
tmprho=rho;
tmprho(common_bad,:)=nan;

% channels (7,16) and (7,15) are about the same distance apart but have
% very different correlations over time
idx1=find(chanpairs(:,1)==7&chanpairs(:,2)==16);
idx2=find(chanpairs(:,1)==7&chanpairs(:,2)==15);
figure
plot(0:4:(size(rho,1)-1)*4,rho(:,idx1)), ylim([0 1])
hold on
plot(0:4:(size(rho,1)-1)*4,rho(:,idx2),'r'), ylim([0 1])
legend({['Ch 7 & 16 (' num2str(avg.pairseps(idx1),3) ' mm)'],...
    ['Ch 7 & 15 (' num2str(avg.pairseps(idx2),3) ' mm)']},...
    'Location','SouthWest');
ylim([-0.2 1]);
grid on;

% save
saveas(gcf,['d:/matlab/ecogres/figures/MCRGRIDT_' grids(1).filename '_' upper(ref) '.fig']);
saveas(gcf,['d:/matlab/ecogres/figures/MCRGRIDT_' grids(1).filename '_' upper(ref) '.png']);
saveas(gcf,['d:/matlab/ecogres/figures/MCRGRIDT_' grids(1).filename '_' upper(ref) '.eps'],'epsc2');

%% GRID 6: HUMANUEA2
% load data
load(['d:/matlab/ecogres/g6cvd_' upper(ref) '.mat']);

% find common outliers
bad=cell(1,size(rho,2));
for k=1:size(rho,2)
    bad{k}=outliers(rho(:,k));
end
bad=cat(1,bad{:});
unique_bad=sort(unique(bad),'ascend');
common_bad=unique_bad(histc(bad,unique_bad)>=0.2*size(rho,2));
tmprho=rho;
tmprho(common_bad,:)=nan;

% channels (26,67) and (26,75) are about the same distance apart but have
% very different correlations over time
idx1=find(chanpairs(:,1)==26&chanpairs(:,2)==67);
idx2=find(chanpairs(:,1)==26&chanpairs(:,2)==75);
figure
plot(0:4:(size(rho,1)-1)*4,rho(:,idx1)), ylim([0 1])
hold on
plot(0:4:(size(rho,1)-1)*4,rho(:,idx2),'r'), ylim([0 1])
legend({['Ch 26 & 67 (' num2str(avg.pairseps(idx1),3) ' mm)'],...
    ['Ch 26 & 75 (' num2str(avg.pairseps(idx2),3) ' mm)']},...
    'Location','SouthWest');
ylim([-0.2 1]);
grid on;

% save
saveas(gcf,['d:/matlab/ecogres/figures/MCRGRIDT_' grids(6).filename '_' upper(ref) '.fig']);
saveas(gcf,['d:/matlab/ecogres/figures/MCRGRIDT_' grids(6).filename '_' upper(ref) '.png']);
saveas(gcf,['d:/matlab/ecogres/figures/MCRGRIDT_' grids(6).filename '_' upper(ref) '.eps'],'epsc2');


%% GRID 7: SUBDURALMACRO
% load data
load(['d:/matlab/ecogres/g7cvd_' upper(ref) '.mat']);

% find common outliers
bad=cell(1,size(rho,2));
for k=1:size(rho,2)
    bad{k}=outliers(rho(:,k));
end
bad=cat(1,bad{:});
unique_bad=sort(unique(bad),'ascend');
common_bad=unique_bad(histc(bad,unique_bad)>=0.2*size(rho,2));
tmprho=rho;
tmprho(common_bad,:)=nan;

% channels (48,6) and (48,5) are about the same distance apart but have
% very different correlations over time
idx1=find(chanpairs(:,1)==48&chanpairs(:,2)==6);
idx2=find(chanpairs(:,1)==48&chanpairs(:,2)==5);
figure
plot(0:4:(size(rho,1)-1)*4,rho(:,idx1)), ylim([0 1])
hold on
plot(0:4:(size(rho,1)-1)*4,rho(:,idx2),'r'), ylim([0 1])
legend({['Ch 48 & 6 (' num2str(avg.pairseps(idx1),3) ' mm)'],...
    ['Ch 48 & 5 (' num2str(avg.pairseps(idx2),3) ' mm)']},...
    'Location','SouthWest');
ylim([-0.5 1]);
grid on;

% save
saveas(gcf,['d:/matlab/ecogres/figures/MCRGRIDT_' grids(7).filename '_' upper(ref) '.fig']);
saveas(gcf,['d:/matlab/ecogres/figures/MCRGRIDT_' grids(7).filename '_' upper(ref) '.png']);
saveas(gcf,['d:/matlab/ecogres/figures/MCRGRIDT_' grids(7).filename '_' upper(ref) '.eps'],'epsc2');







% % % find distant and close channel pairs
% % highthresh=prctile(avg.pairseps,80);
% % highsepidx=find(avg.pairseps>=highthresh);
% % highseppairs=chanpairs(highsepidx,:);
% % lowthresh=max(avg.pairseps)-highthresh;
% % lowsepidx=find(avg.pairseps<=lowthresh&avg.pairseps>0);
% % lowseppairs=chanpairs(lowsepidx,:);
% % 
% % % mean ± std over time
% % tmpmean=nanmean(tmprho,1);
% % tmpstd=nanstd(tmprho,[],1);
% % 
% % % plot
% % figure('PaperPositionMode','auto','Position',[100 50 600 900]);
% % 
% % % channel pair with large separation, high mean
% % [val,idx]=max(tmpmean(highsepidx));
% % idx= chanpairs(:,1)==highseppairs(idx,1)&chanpairs(:,2)==highseppairs(idx,2);
% % subplot(411);
% % plot(0:4:(size(tmprho,1)-1)*4,tmprho(:,idx))
% % title({['Grid ' num2str(g) ': ' grids(g).label],
% %     [num2str(chanpairs(idx,1)) ' & ' num2str(chanpairs(idx,2)) ...
% %     ' (' num2str(avg.pairseps(idx)) ' mm)' ...
% %     ' (' num2str(tmpmean(idx),3) ' ± ' num2str(tmpstd(idx),3) ')']})
% % ylim([-1 1]);
% % 
% % % channel pair with large separation, high std
% % [val,idx]=max(tmpstd(highsepidx));
% % idx= chanpairs(:,1)==highseppairs(idx,1)&chanpairs(:,2)==highseppairs(idx,2);
% % subplot(412);
% % plot(0:4:(size(tmprho,1)-1)*4,tmprho(:,idx))
% % title([num2str(chanpairs(idx,1)) ' & ' num2str(chanpairs(idx,2)) ...
% %     ' (' num2str(avg.pairseps(idx)) ' mm)' ...
% %     ' (' num2str(tmpmean(idx),3) ' ± ' num2str(tmpstd(idx),3) ')'])
% % ylim([-1 1]);
% % 
% % % channel pair with small separation, low mean
% % [val,idx]=min(tmpmean(lowsepidx));
% % idx= chanpairs(:,1)==lowseppairs(idx,1)&chanpairs(:,2)==lowseppairs(idx,2);
% % subplot(413);
% % plot(0:4:(size(tmprho,1)-1)*4,tmprho(:,idx))
% % title([num2str(chanpairs(idx,1)) ' & ' num2str(chanpairs(idx,2)) ...
% %     ' (' num2str(avg.pairseps(idx)) ' mm)' ...
% %     ' (' num2str(tmpmean(idx),3) ' ± ' num2str(tmpstd(idx),3) ')'])
% % ylim([-1 1]);
% % 
% % % channel pair with small separation, high std
% % [val,idx]=max(tmpstd(lowsepidx));
% % idx= chanpairs(:,1)==lowseppairs(idx,1)&chanpairs(:,2)==lowseppairs(idx,2);
% % subplot(414);
% % plot(0:4:(size(tmprho,1)-1)*4,tmprho(:,idx))
% % title([num2str(chanpairs(idx,1)) ' & ' num2str(chanpairs(idx,2)) ...
% %     ' (' num2str(avg.pairseps(idx)) ' mm)' ...
% %     ' (' num2str(tmpmean(idx),3) ' ± ' num2str(tmpstd(idx),3) ')'])
% % ylim([-1 1]);
% % xlabel('time (sec)');
% % 
% % % save
% % saveas(gcf,['d:/matlab/ecogres/figures/MCRGRIDT_' grids(g).filename '_' upper(ref) '.fig']);
% % saveas(gcf,['d:/matlab/ecogres/figures/MCRGRIDT_' grids(g).filename '_' upper(ref) '.png']);
% % saveas(gcf,['d:/matlab/ecogres/figures/MCRGRIDT_' grids(g).filename '_' upper(ref) '.eps'],'epsc2');