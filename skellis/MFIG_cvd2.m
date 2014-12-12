% generate figures of zero-lag cross-correlation vs. separation distance
clear all;
close all;
clc;

% set up environment
use('cleanpath');
use('pkgs/skellis');
use('parfor',8);

% define grids
grids=defgrids;

% specify rereferencing
ref='unr';

% loop over grids
d=cell(size(grids));
for g=1:length(grids)
    % load data
    disp(['loading g' num2str(g) '...']);
    d{g}=load(['d:/Spencer/ecogres/g' num2str(g) 'cvd_' upper(ref) '.mat']);

    % delete bad channels
    idx=cell(size(grids(g).badchan));
    for k=1:length(grids(g).badchan)
        idx{k}=find(...
            d{g}.chanpairs(:,1)==grids(g).badchan(k)|...
            d{g}.chanpairs(:,2)==grids(g).badchan(k));
    end
    idx=unique(cat(1,idx{:}));
    d{g}.chanpairs(idx,:)=[];
    d{g}.rho(:,idx)=[];

    % % % find common (i.e., present in >=50% of channel pairs) outliers
    % % bad=cell(1,size(d{g}.rho,2));
    % % for k=1:size(d{g}.rho,2)
    % %     bad{k}=outliers(d{g}.rho(:,k));
    % % end
    % % bad=cat(1,bad{:});
    % % unique_bad=sort(unique(bad),'ascend');
    % % d{g}.bad=[];%unique_bad(histc(bad,unique_bad)>=0.5*size(d{g}.rho,2));
end


%% PLOT ALL TOGETHER: JUST MEANS
figure('PaperPositionMode','auto','Position',[100 208 1700 600]);
mymap=colormap(hsv);
clr=[mymap([1 2 3 4 5 6 7 35 36],:); 0 0 0;];
ls={'-','-.','--','-','-.','--','-','-.','--','-'};
subplot(211);
hold all;
for g=1:length(grids)
    % % ok=setdiff(1:size(d{g}.rho,1),d{g}.bad);
    ok=1:size(d{g}.rho,1);
    plot(d{g}.avg.seps,nanmean(d{g}.avg.rho(ok,:),1),'Color',clr(g,:),'LineWidth',2);
end
hold off
ylabel('correlation');
ylim([-1 1]);
legend({grids(:).shortname})
grid on;
box on;
title(['Average correlation vs. distance (' ref ')']);

subplot(212);
hold all;
for g=1:length(grids)
    % % ok=setdiff(1:size(d{g}.rho,1),d{g}.bad);
    ok=1:size(d{g}.rho,1);
    plot(d{g}.avg.seps,nanmean(d{g}.avg.rho(ok,:),1),'Color',clr(g,:),'LineWidth',2);
end
hold off
box on;
grid on;
set(gca,'YTickLabel',[]);
ylim([0 1]);
xlim([0 5]);
saveas(gcf,['d:/Spencer/ecogres/figures/MCVD_AVG_' upper(ref) '.fig']);
saveas(gcf,['d:/Spencer/ecogres/figures/MCVD_AVG_' upper(ref) '.png']);
saveas(gcf,['d:/Spencer/ecogres/figures/MCVD_AVG_' upper(ref) '.eps'],'epsc2');


%% PLOT ALL UECOG GRIDS TOGETHER
figure('PaperPositionMode','auto','Position',[100 208 1700 600]);
colormap(hsv);

% plot distribution over space
hold all;
for g=[1:5 7 6]
    % % ok=setdiff(1:size(d{g}.rho,1),d{g}.bad);
    ok=1:size(d{g}.rho,1);
    plot(d{g}.avg.seps,nanmean(d{g}.avg.rho(ok,:),1),ls{g},'Color',clr(g,:),'LineWidth',3);
    boxplot(nanmean(d{g}.avg.population(:,:,ok),3),d{g}.avg.seps,...
        'PlotStyle','compact','outliersize',3,'symbol','.',...
        'medianstyle','line','jitter',0.2,'positions',d{g}.avg.seps,...
        'colors',clr(g,:),'labels',d{g}.avg.seps,'labelverbosity','all');
    delete(findobj(gca,'tag','Median')); % remove median indicator
    if(g~=6)
        set(gca,'XTickLabel',{' '});
    end
end
ylabel('correlation');
xlabel('separation distance (mm)');
ylim([-1.1 1.1]);
xlim([0 60]);
title(['\muECoG chan distribution (' ref ')']);
grid on;
legend(grids(1:7).shortname,'Location','SouthWest')
saveas(gcf,['d:/matlab/ecogres/figures/MCVD_uECoG_' upper(ref) '.fig']);
saveas(gcf,['d:/matlab/ecogres/figures/MCVD_uECoG_' upper(ref) '.png']);
saveas(gcf,['d:/matlab/ecogres/figures/MCVD_uECoG_' upper(ref) '.eps'],'epsc2');



%% PLOT ALL UEA GRIDS TOGETHER
figure('PaperPositionMode','auto','Position',[100 208 1700 600]);
colormap(hsv);

% plot distribution over space
hold all;
for g=9:-1:8 % weird issues with x-axis tick marks if the last one to plot isn't the one we keep
    % % ok=setdiff(1:size(d{g}.rho,1),d{g}.bad);
    ok=1:size(d{g}.rho,1);
    plot(d{g}.avg.seps,nanmean(d{g}.avg.rho(ok,:),1),ls{g},'Color',clr(g,:),'LineWidth',3);
    boxplot(nanmean(d{g}.avg.population(:,:,ok),3),d{g}.avg.seps,...
        'PlotStyle','compact','outliersize',3,'symbol','.',...
        'medianstyle','line','jitter',0.2,'positions',d{g}.avg.seps,...
        'colors',clr(g,:));
    delete(findobj(gca,'tag','Median')); % remove median indicator
    if(g>8)
        set(gca,'XTickLabel',{' '});
    end
end
ylabel('correlation');
xlabel('separation distance (mm)');
ylim([-1.1 1.1]);
xlim([0 5.5]);
title(['UEA chan distribution (' ref ')']);
grid on;
legend(grids(9:8).label,'Location','SouthWest')
saveas(gcf,['d:/matlab/ecogres/figures/MCVD_UEA_' upper(ref) '.fig']);
saveas(gcf,['d:/matlab/ecogres/figures/MCVD_UEA_' upper(ref) '.png']);
saveas(gcf,['d:/matlab/ecogres/figures/MCVD_UEA_' upper(ref) '.eps'],'epsc2');


%% PLOT SUBDURAL MACRO
figure('PaperPositionMode','auto','Position',[100 208 1700 600]);

% plot distribution over space
hold all;
g=10;
% % ok=setdiff(1:size(d{g}.rho,1),d{g}.bad);
ok=1:size(d{g}.rho,1);
plot(d{g}.avg.seps,nanmean(d{g}.avg.rho(ok,:),1),ls{g},'Color',clr(g,:),'LineWidth',3);
boxplot(nanmean(d{g}.avg.population(:,:,ok),3),d{g}.avg.seps,...
        'PlotStyle','compact','outliersize',3,'symbol','.',...
        'medianstyle','line','jitter',0.2,'positions',d{g}.avg.seps,...
        'colors',clr(g,:));
delete(findobj(gca,'tag','Median')); % remove median indicator
title(['ECoG chan distribution (' ref ')']);
ylabel('correlation');
xlabel('separation distance (mm)');
ylim([-1.1 1.1]);
xlim([0 100]);
grid on;
legend(grids(g).label,'Location','SouthWest')
saveas(gcf,['d:/matlab/ecogres/figures/MCVD_ECoG_' upper(ref) '.fig']);
saveas(gcf,['d:/matlab/ecogres/figures/MCVD_ECoG_' upper(ref) '.png']);
saveas(gcf,['d:/matlab/ecogres/figures/MCVD_ECoG_' upper(ref) '.eps'],'epsc2');
