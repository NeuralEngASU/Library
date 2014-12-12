% generate all correlation functions (ACFs and CCFs) and spectral coherence
% functions (SCFs)
clear all;
close all;
clc;

% set up environment
use('cleanpath');
use('pkgs/skellis');
%use('parfor',4);

% define grids
grids=defgrids;

% specify rereferencing
ref='unr';

% loop over grids
for g=1:length(grids)

    % update user
    disp(['grid ' num2str(g) '/' num2str(length(grids))]);

    % load data
    load(['d:/matlab/ecogres/g' num2str(g) 'acfvtime_' upper(ref)],'lags','acfs','layout');

    % full duration half maximum
    lhsidx=find(lags<0);
    lhserr=abs(acfs( lhsidx,:,: )-0.5).^2;
    [dummy,lhs]=min(lhserr);
    lhs=squeeze(lhsidx(lhs));
    rhsidx=find(lags>0);
    rhserr=abs(acfs( rhsidx,:,: )-0.5).^2;
    [dummy,rhs]=min(rhserr);
    rhs=squeeze(rhsidx(rhs));
    fdhm=lags(rhs)-lags(lhs);

    % find common outliers
    bad=cell(1,size(fdhm,2));
    for k=1:size(fdhm,2)
        bad{k}=outliers(fdhm(:,k));
    end
    bad=cat(1,bad{:});
    unique_bad=sort(unique(bad),'ascend');
    common_bad=unique_bad(histc(bad,unique_bad)>size(fdhm,2)/2);
    
    % remove outliers
    bad_time=common_bad;
    fdhm(bad_time,:)=nan;
    fdhm(:,grids(g).badchan)=nan;

    % plot
    fdhmpop=fdhm(:);
    nanmean(fdhmpop)
    TOP=ceil(prctile(fdhmpop,99));
    figure('Position',[157 100 1385 480],'PaperPositionMode','auto');
    mymap=colormap('jet');
    mymap=[0 0 0; mymap];
    colormap(mymap);
    
    % FDHM over time
    axes('Position',[0.04 0.56 0.91 0.38]);
    hold all;
    plot(0:4:(size(fdhm,1)-1)*4,fdhm,'Color',[0.7 0.7 0.7],'LineWidth',1);
    plot(0:4:(size(fdhm,1)-1)*4,nanmean(fdhm,2),'Color',[0 0 0],'LineWidth',1.5);
    ylim([0 TOP]);
    xlim([0 round((size(fdhm,1)-1)*4/100)*100]);
    box on;
    title(['Grid ' num2str(g) ': ' grids(g).label ' (' ref ')']);

    % boxplot
    axes('Position',[0.04 0.06 0.60 0.45]);
    boxplot(fdhm,'PlotStyle','compact','outliersize',3,'symbol','.','medianstyle','line','jitter',0.2,'positions',1:size(fdhm,2));
    delete(findobj(gca,'tag','Median')); % remove median indicator
    set(gca,'XTickLabel',{' '}); % remove channel labels
    ylim([0 TOP]);
    xlim([0 97]);
    ylabel('FDHM');

    % barplot
    axes('Position',[0.65 0.06 0.15 0.45])
    [n,x]=histc(fdhmpop,0:0.02:TOP);
    n=n/sum(n); % normalize
    bh=barh(0:0.02:TOP,n,'histc');
    set(bh(1),'facecolor','b','edgecolor','none')
    set(gca,'YTick',[],'XTick',[]); % remove count labels
    ylim([0 TOP]);

    % layout (mean value)
    axes('Position',[0.81 0.29 0.16 0.22])
    mfdhm=vec2layout(nanmean(fdhm,1),grids(g).layout);
    imagesc(mfdhm);
    colorbar
    set(gca,'CLim',[0 TOP/3.3333]);
    set(gca,'XTickLabel',{' '},'XTick',[],'YTick',[]);

    % layout (standard error)
    axes('Position',[0.81 0.06 0.16 0.22])
    sfdhm=vec2layout(nanstd(fdhm,[],1),grids(g).layout);
    imagesc(sfdhm);
    colorbar
    set(gca,'CLim',[0 TOP/3.3333]);
    set(gca,'XTickLabel',{' '},'XTick',[],'YTick',[]);

    saveas(gcf,['d:/matlab/ecogres/figures/MAVT_' grids(g).filename '_' upper(ref) '.fig']);
    saveas(gcf,['d:/matlab/ecogres/figures/MAVT_' grids(g).filename '_' upper(ref) '.png']);
    saveas(gcf,['d:/matlab/ecogres/figures/MAVT_' grids(g).filename '_' upper(ref) '.eps'],'epsc2');

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
    clear lags acfs layout fdhm;
end