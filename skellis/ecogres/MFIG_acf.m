% generate figures of auto-correlation functions
clear all;
close all;
clc;

% set up environment
use('cleanpath');
use('pkgs/skellis');

% define grids
grids=defgrids;

% specify rereferencing
reref_method='none';
reref_label='none';
reref_append='_UNR';

% loop over grids
for g=1:length(grids)
    % load data
    d1=load(['d:/results/ecogres/g' num2str(g) 'mccf' reref_append '.mat'],'mccf','lags','chanpairs');
    lags=d1.lags;

    % find the ACFs
    idx=zeros(1,length(unique(d1.chanpairs(:))));
    for k=1:length(unique(d1.chanpairs(:)))
        idx(k)=find(d1.chanpairs(:,1)==k&d1.chanpairs(:,2)==k);
    end
    macf1=d1.mccf(:,idx);
    clear d1;

    % remove bad channels
    macf1=macf1(:,setdiff(1:size(macf1,2),grids(g).badchan));

    % open figure
    figure('Name',['ACF: ' grids(g).label],...
        'PaperPositionMode','auto','Position',[243 208 1440 782]);

    % first panel: zoomed out view
    subplot(211);
    hold all;
    R1_chan_h=plot(lags,macf1,'Color',[0.7 0.7 0.7],'LineWidth',1);
    R1_median_h=plot(lags,median(macf1,2),'Color',[0 0 0],'LineWidth',4);

    % set up groups for legend
    R1_chan_grp=hggroup;
    R1_median_grp=hggroup;
    set(R1_chan_h,'Parent',R1_chan_grp);
    set(R1_median_h,'Parent',R1_median_grp);
    set(get(get(R1_chan_grp,'Annotation'),'LegendInformation'),'IconDisplayStyle','on');
    set(get(get(R1_median_grp,'Annotation'),'LegendInformation'),'IconDisplayStyle','on');
    legend({...
        ['All channels (' reref_label ')'],...
        ['Median (' reref_label ')']});

    % annotate
    title([grids(g).label]);
    xlabel('lag (sec)');
    ylabel('correlation');
    grid on;
    xlim([0 lags(end)]);
    ylim([-0.3 1.1]);

    % second panel: zoomed in view
    subplot(212);
    hold all;
    R1_chan_h=plot(lags,macf1,'Color',[0.7 0.7 0.7],'LineWidth',1);
    R1_median_h=plot(lags,median(macf1,2),'Color',[0 0 0],'LineWidth',4);

    % set up groups for legend
    R1_chan_grp=hggroup;
    R1_median_grp=hggroup;
    set(R1_chan_h,'Parent',R1_chan_grp);
    set(R1_median_h,'Parent',R1_median_grp);
    set(get(get(R1_chan_grp,'Annotation'),'LegendInformation'),'IconDisplayStyle','on');
    set(get(get(R1_median_grp,'Annotation'),'LegendInformation'),'IconDisplayStyle','on');
    legend({...
        ['All channels (' reref_label ')'],...
        ['Median (' reref_label ')']});

    % annotate
    title([grids(g).label]);
    xlabel('lag (sec)');
    ylabel('correlation');
    grid on;
    xlim([0 1]);
    ylim([-0.3 1.1]);

    % save figure
    saveas(gcf,['d:/results/ecogres/figures/MACF_' grids(g).filename '.fig']);
    saveas(gcf,['d:/results/ecogres/figures/MACF_' grids(g).filename '.eps'],'epsc2');
    saveas(gcf,['d:/results/ecogres/figures/MACF_' grids(g).filename '.png']);

    % % screendim=get(0,'screensize');
    % % figure('Position',[1 41 screendim(3) screendim(4)-110]);
    % % gridplot2(lags,macf1,grids(g).layout,'axisargs',struct('ylim',[-0.3 1.1],'xlim',[0 4]));
end