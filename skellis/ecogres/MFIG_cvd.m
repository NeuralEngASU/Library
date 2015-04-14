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

% load data
d=cell(size(grids));
for g=1:length(grids)
    disp(['loading g' num2str(g) '...']);
    d{g}=load(['d:/Spencer/ecogres/g' num2str(g) 'cvd_' upper(ref) '.mat']);
    d{g}.bad=[];
end


% PLOT ALL TOGETHER: JUST MEANS
figure('PaperPositionMode','auto','Position',[52 184 673 896]);
mymap=colormap(hsv);
clr=[mymap([1 3 5 35 37],:); 0 0 0;];
ls={'-','-.','--','-','-.','--','-','-.','--','-'};
ax(1)=axes('Position',[0.08 0.79 0.88 0.2]);
hold all;
for g=1:length(grids)
    ok=setdiff(1:size(d{g}.rho,1),d{g}.bad);
    plot(d{g}.avg.seps,nanmean(d{g}.avg.rho(ok,:),1),'Color',clr(g,:),'LineWidth',2);
end
hold off;
ylabel('correlation');
ylim([-0.2 1.1]);
legend({grids(:).shortname})
grid on;
box on;

ax(2)=axes('Position',[0.24 0.88 0.45,0.10]);
hold all;
for g=1:length(grids)
    ok=setdiff(1:size(d{g}.rho,1),d{g}.bad);
    plot(d{g}.avg.seps,nanmean(d{g}.avg.rho(ok,:),1),'Color',clr(g,:),'LineWidth',2);
end
hold off
box on;
grid on;
ylim([0.2 1.1]);
xlim([0 5]);
set(ax(2),'XTick',0:5,'XTickLabel',{'0','','','','','5'});
set(ax(2),'YTick',[0.3 1],'YTickLabel',{'0.3','1'});


% PLOT ALL UECOG GRIDS TOGETHER
ax(3)=axes('Position',[0.08 0.58 0.88 0.18]);
micro_idx=find([grids(:).class]==1);
hold all;
max_sep=0;
for g=micro_idx
    ok=setdiff(1:size(d{g}.rho,1),d{g}.bad);
    if(max(d{g}.avg.seps)>max_sep)
        max_sep=max(d{g}.avg.seps);
    end
    plot(d{g}.avg.seps,nanmean(d{g}.avg.rho(ok,:),1),ls{g},'Color',clr(g,:),'LineWidth',3);
    boxplot(nanmean(d{g}.avg.population(:,:,ok),3),d{g}.avg.seps,...
        'PlotStyle','compact','outliersize',3,'symbol','.',...
        'medianstyle','line','jitter',0.2,'positions',d{g}.avg.seps,...
        'colors',clr(g,:),'labels',d{g}.avg.seps,'labelverbosity','all');
    delete(findobj(gca,'tag','Median')); % remove median indicator
    if(g<micro_idx(end))
        set(gca,'XTickLabel',{' '});
    end
end
set(ax(3),'Position',[0.08 0.58 0.88 0.18]); % hack fix for boxplot resizing the axis
ylabel('correlation');
ylim([0 1.1]);
xlim([0 ceil(max_sep)]);
grid on;
legend(grids(micro_idx).shortname,'Location','SouthWest')


% PLOT ALL UEA GRIDS TOGETHER
ax(4)=axes('Position',[0.08 0.34 0.88 0.18]);
uea_idx=find([grids(:).class]==2);
hold all;
max_sep=0;
for g=fliplr(uea_idx) % maybe need to go backward? weird issues with x-axis tick marks if the last one to plot isn't the one we keep
    ok=setdiff(1:size(d{g}.rho,1),d{g}.bad);
    if(max(d{g}.avg.seps)>max_sep)
        max_sep=max(d{g}.avg.seps);
    end
    plot(d{g}.avg.seps,nanmean(d{g}.avg.rho(ok,:),1),ls{g},'Color',clr(g,:),'LineWidth',3);
    boxplot(nanmean(d{g}.avg.population(:,:,ok),3),d{g}.avg.seps,...
        'PlotStyle','compact','outliersize',3,'symbol','.',...
        'medianstyle','line','jitter',0.2,'positions',d{g}.avg.seps,...
        'colors',clr(g,:));
    delete(findobj(gca,'tag','Median')); % remove median indicator
    if(g~=uea_idx(1))
        set(gca,'XTickLabel',{' '});
    end
end
set(ax(4),'Position',[0.08 0.34 0.88 0.18]); % hack fix for boxplot resizing the axis
ylabel('correlation');
ylim([0 1.1]);
xlim([0 ceil(max_sep)]);
grid on;
legend(grids(fliplr(uea_idx)).shortname,'Location','SouthWest')


% PLOT SUBDURAL MACRO
ax(5)=axes('Position',[0.08 0.08 0.88 0.2]);
g=find([grids(:).class]==3);

% plot distribution over space
hold all;
ok=setdiff(1:size(d{g}.rho,1),d{g}.bad);
plot(d{g}.avg.seps,nanmean(d{g}.avg.rho(ok,:),1),ls{g},'Color',clr(g,:),'LineWidth',3);
boxplot(nanmean(d{g}.avg.population(:,:,ok),3),d{g}.avg.seps,...
        'PlotStyle','compact','outliersize',3,'symbol','.',...
        'medianstyle','line','jitter',0.2,'positions',d{g}.avg.seps,...
        'colors',clr(g,:));
delete(findobj(gca,'tag','Median')); % remove median indicator
set(ax(5),'Position',[0.08 0.08 0.88 0.2]);
ylabel('correlation');
xlabel('separation distance (mm)');
ylim([-0.2 1.1]);
xlim([0 100]);
grid on;
legend(grids(g).label,'Location','SouthWest')

saveas(gcf,['d:/Spencer/ecogres/figures/MCVD_' upper(ref) '.fig']);
saveas(gcf,['d:/Spencer/ecogres/figures/MCVD_' upper(ref) '.png']);
saveas(gcf,['d:/Spencer/ecogres/figures/MCVD_' upper(ref) '.eps'],'epsc2');

close(gcf);