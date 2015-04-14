% test re-referencing schemes to find the source of large negative
% correlation at large separation distances
clear all;
close all;
clc;

% set up environment
use('cleanpath');
use('pkgs/skellis');
use('pkgs/chronux');
use('parfor',8);

% Chronux parameters
chr.Fs=1e3;
chr.tapers=[3 5];
chr.pad=0;
chr.fpass=[0 500];
chr.trialave=1;

% define grids
grids=defgrids;
movingwin=[10 10];
maxlag=8;

disp(' ');
disp('test_negative_correlation');
disp(' ');

% define re-reref's to compare
meth={'none','car'};
sg=round(linspace(0.5,2,length(meth))*10)/10;

%% load data
g=1;
disp(['grid ' num2str(g)]);
disp('  loading data');
layout=grids(g).layout;
spacing=grids(g).spacing;
load(['d:\data\ecogres\g' num2str(g) 's1.mat'],'raw','params');
data=raw; clear raw;
fs=params.fs;
N=0;

% set up channel pairs
minch=min(layout(layout>0));
maxch=max(layout(:));
numch=maxch-minch+1;
p0=repmat((minch:maxch),numch,1);
p1=repmat((minch:maxch)',1,numch);
chanpairs=[p0(:) p1(:)];

%% rereference the data
raw=cell(size(meth));
rlabel=cell(size(meth));
prc=cell(size(raw));
rho=cell(size(raw));
rhosep=cell(size(raw));
seps=cell(size(raw));
population=cell(size(raw));
for m=1:length(raw)
    
    % re-reference the data
    switch(lower(meth{m}))
        case 'none'
            rlabel{m}='raw';
            raw{m}=reref(data,meth{m});
        case 'car'
            rlabel{m}='car';
            raw{m}=reref(data,meth{m});
        case 'sar'
            rlabel{m}=['sar \sigma=' num2str(sg(m)) ' mm'];
            raw{m}=reref(data,meth{m},layout,spacing,sg(m),'badchan',grids(g).badchan);
    end

    % find 25th/75th percentiles in the data after re-referencing
    prc{m}=prctile(raw{m},[25 75])';

    % reshape by window
    nseg=floor(size(raw{m},1)/(movingwin(1)*fs));
    raw{m}=reshape(raw{m}(1:movingwin(1)*fs*nseg,:),movingwin(1)*fs,nseg,size(raw{m},2));

    % calculate zero-lag correlation coefficient
    rho{m}=zeros(size(raw{m},3),size(chanpairs,1));
    for k=1:size(raw{m},2)
        tmprho=corrcoef(squeeze(raw{m}(:,k,:)));
        rho{m}(k,:)=tmprho(:);
    end

    % average at each separation
    [rhosep{m},sp,pp]=avgpersep(rho{m},chanpairs,layout,spacing);

    % reconstruct collection of values at each separation
    maxnum=0;
    pop=nan(size(rho{m},1),length(pp),length(sp));
    for k=1:length(sp)
        num=nnz(pp==sp(k));
        pop(:,1:num,k)=rho{m}(:,pp==sp(k));
        if(num>maxnum),maxnum=num; end
    end
    pop(:,maxnum+1:end,:)=[];
    pop=permute(pop,[2 3 1]);
    
    % assign out results
    seps{m}=sp;
    population{m}=pop;

end

%% plot

figure
[nr,nc]=bestplotdim(length(raw));
for m=1:length(raw)
    subplot(nr,nc,m);
    hist(prc{m},-75:1:75);
    title(rlabel{m});
end

figure;
cmap=colormap('jet');
rcolor=cmap(round(linspace(1,size(cmap,1),length(raw))),:);
hold on
% plot means
for m=1:length(rhosep)
    plot(seps{m},mean(rhosep{m},1),'LineWidth',2,'Color',rcolor(m,:));
end
% plot population data
for m=1:length(rhosep)
    boxplot(mean(population{m},3),seps{m},'PlotStyle','compact','outliersize',3,'symbol','.','medianstyle','line','jitter',0.2,'positions',seps{m},'colors',rcolor(m,:));
    delete(findobj(gca,'tag','Median')); % remove median indicator
    if(m<length(rhosep))
        set(gca,'XTickLabel',{' '}); % remove channel labels
    end
end
hold off
legend(rlabel,'Location','southwest');
title('Comparison of re-referencing schemes');
grid on;
ylim([-1 1.1]);



% % figure;
% % for k=1:size(population1,3)
% %     
% %     % plot means
% %     plot(seps,rhosep1(k,:),'b','LineWidth',2);
% %     hold on;
% %     plot(seps,rhosep2(k,:),'r','LineWidth',2);
% %     plot(seps,rhosep3(k,:),'g','LineWidth',2);
% %     plot(seps,rhosep4(k,:),'c','LineWidth',2);
% %     
% %     % plot population data
% %     boxplot(population1(:,:,k),seps,'PlotStyle','compact','outliersize',3,'symbol','.','medianstyle','line','jitter',0.2,'positions',seps,'colors','b');
% %     delete(findobj(gca,'tag','Median')); % remove median indicator
% %     set(gca,'XTickLabel',{' '}); % remove channel labels
% %     
% %     boxplot(population2(:,:,k),seps,'PlotStyle','compact','outliersize',3,'symbol','.','medianstyle','line','jitter',0.2,'positions',seps,'colors','r');
% %     delete(findobj(gca,'tag','Median')); % remove median indicator
% %     set(gca,'XTickLabel',{' '}); % remove channel labels
% %     
% %     boxplot(population3(:,:,k),seps,'PlotStyle','compact','outliersize',3,'symbol','.','medianstyle','line','jitter',0.2,'positions',seps,'colors','g');
% %     delete(findobj(gca,'tag','Median')); % remove median indicator
% %     set(gca,'XTickLabel',{' '}); % remove channel labels
% %     
% %     boxplot(population4(:,:,k),seps,'PlotStyle','compact','outliersize',3,'symbol','.','medianstyle','line','jitter',0.2,'positions',seps,'colors','c');
% %     hold off
% %     
% %     legend({rlabel{1},rlabel{2},rlabel{3},rlabel{4}},'Location','southwest');
% %     
% %     title(k)
% %     ylim([-1 1.1]);
% %     pause(0.05)
% % end