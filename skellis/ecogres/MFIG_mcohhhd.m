% generate figures of average cross-correlation function vs. separation distance
clear all;
close all;
clc;

% set up environment
% use('cleanpath');
use('pkgs/skellis');
%use('parfor',4);

% specify rereferencing
ref='unr';

% define grids
grids=defgrids;
srcdir = '\\CHOPIN\Documents\Spencer\d_matlab\ecogres';%'E:\data\ecogres';

% loop over the grids
load(fullfile(srcdir,'g1mcoh_UNR.mat'),'f');
hhd=zeros(length(f),length(grids));
for g=1:length(grids)
    d=load(fullfile(srcdir,sprintf('g%dmcoh_%s.mat',g,upper(ref))),'mcoh','f','chanpairs','layout','spacing');
    [mcoh,seps,pairsep,secoh]=avgpersep(d.mcoh,d.chanpairs,d.layout,d.spacing,grids(g).badchan);

    % add in 0-mm separation
    seps=[0; seps];
    mcoh=[ones(size(mcoh,1),1) mcoh];

    tmphhd=zeros(1,length(f));
    figure;
    ax(1)=subplot(211);
    ax(2)=subplot(212);
    for k=1:length(f)
        % interpolate a smoothing spline
        ok_ = isfinite(seps) & isfinite(mcoh(k,:)');
        ft_ = fittype('smoothingspline');
        cf_ = fit(seps(ok_),mcoh(k,ok_)',ft_);
        
        hh  = cf_(0) - cf_(seps(end));
        x   = 0:0.001:seps(end);
        [val,idx]=min(abs(cf_(x)-(cf_(seps(end))+hh/2)));
        tmphhd(k)=x(idx);

        % % % plot the fit and original data
        % % subplot(ax(1));
        % % plot(seps,mcoh(k,ok_),'x');
        % % hold on;
        % % plot(cf_);
        % % plot(x(idx),cf_(x(idx)),'k.','MarkerSize',10);
        % % hold off;
        % % title([num2str(f(k)) ' Hz']);
        % % ylim([-0.2 1.1]);
        % % 
        % % subplot(ax(2))
        % % hold on;
        % % plot(f(k),x(idx),'k.','MarkerSize',10);
        % % xlim([f(1) f(end)]);
        % % ylim([seps(1) seps(end)]);
        % % hold off;
        % % drawnow;
    end
    hhd(:,g)=tmphhd;
end

% spaces in 60 hz/harmonics
hhd_no60=hhd;
for k=fliplr(60:60:f(end))
    hhd_no60(f>(k-5) & f<(k+5),:) = nan;
end

% average HHD between 300-400 Hz
mean(hhd_no60(f>300,:))

for g=1:length(grids)
    [maxValue,maxIndex]=nanmax(hhd_no60(:,g));
    [minValue,minIndex]=nanmin(hhd_no60(:,g));
    meanValue = nanmean(hhd_no60(f>300,g));
    fprintf('Grid %d: Mean: %+2.2f (300-400 Hz)\tMax %+2.2f at %2.2f Hz\tMin: %+2.2f at %2.2f Hz\n',g,meanValue,maxValue,f(maxIndex),minValue,f(minIndex));
end

figure;
hold all;
mymap=colormap(hsv);
clr=[mymap([1 3 5 35 37],:); 0 0 0;];
for g=1:length(grids)
    plot(f,hhd_no60(:,g),'Color',clr(g,:),'LineWidth',2);
end
set(gca,'YScale','log');
ylim([10^-2 10^1])
legend({grids(:).shortname})
grid on;

% saveas(gcf,['d:/Spencer/ecogres/figures/MCOHHHD_' upper(ref) '.fig']);
% saveas(gcf,['d:/Spencer/ecogres/figures/MCOHHHD_' upper(ref) '.png']);
% saveas(gcf,['d:/Spencer/ecogres/figures/MCOHHHD_' upper(ref) '.eps'],'epsc2');
