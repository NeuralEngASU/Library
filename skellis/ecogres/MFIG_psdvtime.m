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

    % update user
    disp(['grid ' num2str(g) '/' num2str(length(grids))]);

    % load data
    load(['d:/results/ecogres/g' num2str(g) 'psdvtime' reref_append],'f','psds','layout');

    % determine bin power as integral of PSD over those frequencies
    idx=find( (f>30&f<58)|(f>62&f<80) );
    mpwr=squeeze(mean(10*log10(psds(idx,:,:)),2));
    binpwr=squeeze(sum((10*log10(psds(idx,:,:))-permute(repmat(mpwr,[1 1 size(psds,2)]),[1 3 2])).^2,1));
    binpwr(:,grids(g).badchan)=nan;

    % plot
    binpwrpop=binpwr(:);
    BOT=300;
    TOP=2200;
    if(g==9)
        BOT=300;
        TOP=4200;
    end
    figure('Position',[157 100 1385 280],'PaperPositionMode','auto');
    mymap=colormap('jet');
    mymap=[0 0 0; mymap];
    colormap(mymap);

    % boxplot
    axes('Position',[0.04 0.11 0.60 0.8]);
    boxplot(binpwr,'PlotStyle','compact','outliersize',3,'symbol','.','medianstyle','line','jitter',0.2,'positions',1:size(binpwr,2));
    delete(findobj(gca,'tag','Median')); % remove median indicator
    set(gca,'XTickLabel',{' '}); % remove channel labels
    title(['Gamma Power Deviation: ' grids(g).label]);
    ylim([BOT TOP]);
    xlim([0 97]);
    ylabel('SSE');

    % barplot
    axes('Position',[0.65 0.11 0.15 0.8])
    [n,x]=histc(binpwrpop,BOT:40:TOP);
    n=n/sum(n); % normalize
    bh=barh(BOT:40:TOP,n,'histc');
    set(bh(1),'facecolor','b','edgecolor','none')
    set(gca,'YTick',[],'XTick',[]); % remove count labels
    ylim([BOT TOP]);

    % layout (mean value)
    axes('Position',[0.81 0.52 0.16 0.39])
    mbinpwr=vec2layout(mean(binpwr,1),grids(g).layout);
    imagesc(mbinpwr);
    colorbar
    set(gca,'CLim',[BOT+300 TOP-600]);
    set(gca,'XTickLabel',{' '},'XTick',[],'YTick',[]);

    % layout (standard error)
    axes('Position',[0.81 0.11 0.16 0.39])
    sbinpwr=vec2layout(std(binpwr,[],1),grids(g).layout);
    imagesc(sbinpwr);
    colorbar
    set(gca,'CLim',[BOT+300 TOP-600]);
    set(gca,'XTickLabel',{' '},'XTick',[],'YTick',[]);

    saveas(gcf,['d:/results/ecogres/figures/MPVT_' grids(g).filename reref_append '.fig']);
    saveas(gcf,['d:/results/ecogres/figures/MPVT_' grids(g).filename reref_append '.png']);

    % % % plot ACFs in grid layout
    % % screendim=get(0,'screensize');
    % % figure('Position',[1 41 screendim(3) screendim(4)-110]);
    % % for k=1:size(acfs,2)
    % %     clf
    % %     gridplot2(lags(4001:end),acfs(4001:end,k,:),layout,'axisargs',struct('ylim',[-0.4 1.1]))
    % %     set(gcf,'Name',[num2str(k) '/' num2str(size(acfs,2))]);
    % %     pause
    % % end

    % % % imagesc of ACF data
    % % figure;
    % % for k=1:size(acfs,2)
    % %     imagesc(1:96,lags(8001:end),squeeze(acfs(8001:end,k,:)));
    % %     xlabel('channels');
    % %     ylabel('lag (sec)');
    % %     title(['ACFs (' num2str(k) '/' num2str(size(acfs,2)) ')']);
    % %     pause(0.1);
    % % end

    % % % plot ACFs
    % % for c=1:numel(unique(chanpairs(:)))
    % %     figure;
    % %     for k=1:size(raw,2)
    % %         plot(lags,acfs(:,k,c));
    % %         title(['Channel ' num2str(c) ' win ' num2str(k) '/' num2str(size(raw,2))]);
    % %         xlabel('lag (s)');
    % %         ylabel('correlation');
    % %         ylim([-0.4 1.1]);
    % %         pause(0.05);
    % %     end
    % % end

    % % % plot ACF surfaces
    % % figure;
    % % for c=1:5%numel(unique(chanpairs(:)))
    % %     surf(0:10:7190,lags(8001:end),acfs(8001:end,:,c),'EdgeColor','none');
    % %     zlim([-0.2 1.1]);
    % %     view([223 50]);
    % %     set(gca,'YScale','log');
    % %     xlabel('time (s)');
    % %     ylabel('lag (s)');
    % %     zlabel('correlation');
    % %     pause
    % % end
    clear f psds layout binpwr;
end