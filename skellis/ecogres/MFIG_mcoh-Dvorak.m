% generate figures of average cross-correlation function vs. separation distance
clear all;
close all;
clc;

% set up environment
use('cleanpath');
use('pkgs/skellis');

% freq bands for display only
fbands=[...
    0 4;
    4 8;
    8 12;
    12 30;
    30 80;
    80 200;
    200 400;];
fnames={'delta','theta','alpha','beta','gamma','chi','psi'};

% specify rereferencing
ref='unr';

% define grids
grids=defgrids;

% loop over the grids
for g=1:length(grids)
    load(['d:/Spencer/ecogres/g' num2str(g) 'mcoh_' upper(ref) '.mat'],'mcoh','f','chanpairs','layout','spacing');

    % get average
    [mcoh,seps,pairsep,secoh]=avgpersep(mcoh,chanpairs,layout,spacing,grids(g).badchan);

    % add in 0-mm separation
    seps=[0; seps];
    mcoh=[ones(size(mcoh,1),1) mcoh];

    % only use a subset of freqs to create the mesh
    % % fidx=fix(logspace(0,log10(length(f)-1),30));
    % % fidx=sort(unique(fidx),'ascend');
    fidx=[1 2 3 4 5 6 7 9 11 16 20 25 32 40 51 64 81 102 128 162 204 257 324 409 515 649 819]; % approximately log spaced (avoiding 60hz harmonics)
    sidx=fix(linspace(1,length(seps),20));
    sidx=sort(unique(sidx),'ascend');
    
    % mcoh with nans in place of 60-hz/harmonics
    no60idx=1:length(f);
    for k=fliplr(60:60:max(f))
        no60idx(f<(k+5) & f>(k-5))=[];
    end
    mcoh_no60=nan(size(mcoh));
    mcoh_no60(no60idx,:)=mcoh(no60idx,:);

    % plot with line-varying color scale
    figure('Name',['Coherence: ' grids(g).label],'PaperPositionMode','auto','Position',[140 237 1676 375]);
    cmap=colormap('copper');
    
    % TITLE
    ax(1)=subplot('Position',[0 0.07 0.03 0.89]);
    set(ax(1),'Visible','off');
    text(0.5,0.5,grids(g).shortname,'Parent',ax(1),'FontSize',14,'FontWeight','bold','HorizontalAlignment','center','VerticalAlignment','middle','Rotation',90);

    % MESH 3D PLOT OF AVG COH
    ax(2)=subplot('Position',[0.06 0.13 0.17 0.8]);

    % plot the lines in the "freq" direction
    plot3(ax(2),repmat(f(fidx)',1,length(seps(sidx))),...
        repmat(seps(sidx)',length(fidx),1),...
        mcoh(fidx,sidx),'b')
    hold on

    % plot the lines in the "sep" direction
    plot3(ax(2),repmat(f(fidx)',1,length(seps(sidx)))',...
        repmat(seps(sidx)',length(fidx),1)',...
        mcoh(fidx,sidx)','b');
    hold off;

    % set display properties
    xlim([floor(f(fidx(1))) ceil(f(fidx(end)))]);
    ylim([seps(sidx(1))-0.2 seps(sidx(end))+0.2]);
    zlim([0 1.1]);
    zlabel('coherence');
    set(ax(2),'XGrid','on','YGrid','on','ZGrid','on');
    set(ax(2),'XScale','log','YScale','lin','ZScale','lin');
    set(ax(2),'XTick',[1 100 400],'XTickLabel',{'1','','400'});
    yticks=linspace(0,floor(seps(sidx(end))),5);
    yticklabels=cell(size(yticks));
    yticklabels(:)={' '};
    yticklabels{1}=round(seps(1));
    yticklabels{end}=floor(seps(sidx(end)));
    set(ax(2),'YTick',yticks,'YTickLabel',yticklabels)
    set(ax(2),'ZTick',[0 0.5 1],'ZTickLabel',{'0','','1'});
    set(ax(2),'TickLength',[0 0]);
    view([115 49]);

    % PROJECTION TO PLOT COH VS. FREQ, DIFF LINE PER SEP
    ax(3)=subplot('Position',[0.285 0.15 0.28 0.7]);
    set(ax(3),'ColorOrder',cmap(fix(linspace(1,64,length(sidx))),:));
    hold all;
    sep_legstr=cell(1,length(sidx));
    for k=1:length(sidx)
        plot(f,mcoh_no60(:,k),'LineWidth',2);
        sep_legstr{k}=[num2str(seps(sidx(k)),2) ' mm'];
    end
    llegstr=repmat({' '},1,64);
    llegstr(fix(linspace(1,64,length(sidx))))=sep_legstr;
    lcolorbar(llegstr,'Parent',ax(3));
    xlabel('freq (Hz)');
    xlim([floor(f(no60idx(1))) ceil(f(no60idx(end)))]);
    ylim([0 1.1]);
    % set(ax(2),'XScale','log');
    grid on;

    % % % add inset to highlight dynamics at the beginning of the x-axis
    % % ax(3)=axes('Position',[0.63 0.7 0.25 0.2]);
    % % set(ax(3),'ColorOrder',cmap(fix(linspace(1,64,length(sidx))),:));
    % % hold all;
    % % for k=1:length(sidx)
    % %     plot(f,mcoh(:,k),'LineWidth',2);
    % % end
    % % xlim([0 100]);
    % % ylim([-0.2 1.1]);
    % % set(ax(3),'XScale','log');
    % % grid on;

    % PROJECT TO PLOT CCF VS. SEP, DIFF LINE PER LAG
    ax(4)=subplot('Position',[0.65 0.15 0.3 0.7]);
    set(ax(4),'ColorOrder',cmap(fix(linspace(1,64,length(fnames))),:));
    hold all;
    freq_legstr=cell(1,length(fnames));
    for k=1:length(fnames)
        %plot(seps,nanmean(mcoh_no60(f>=fbands(k,1)&f<fbands(k,2),:)),'--','LineWidth',1);
        plot(seps,nanmean(mcoh_no60(f>=fbands(k,1)&f<fbands(k,2),:)),'x','LineWidth',3,'MarkerSize',10);
        freq_legstr{k}=[num2str(fbands(k,1)) ' - ' num2str(fbands(k,2)) ' Hz'];
    end
    llegstr=repmat({' '},1,64);
    llegstr(fix(linspace(1,64,length(fnames))))=freq_legstr;
    lcolorbar(llegstr,'Parent',ax(4));
    xlabel('separation (mm)');
    xlim([seps(sidx(1)) seps(sidx(end))]);
    ylim([0 1.1]);
    grid on;
    
    saveas(gcf,['C:\Users\Spencer\SkyDrive\Publication\2012 JNE\figures\Testing\MCOH_' grids(g).shortname '_' upper(ref) '_marker.fig']);
    % saveas(gcf,['d:/Spencer/ecogres/figures/MCOH_' grids(g).shortname '_' upper(ref) '.fig']);
    % saveas(gcf,['d:/Spencer/ecogres/figures/MCOH_' grids(g).shortname '_' upper(ref) '.png']);
    % saveas(gcf,['d:/Spencer/ecogres/figures/MCOH_' grids(g).shortname '_' upper(ref) '.eps'],'epsc2');

    close(gcf);
end