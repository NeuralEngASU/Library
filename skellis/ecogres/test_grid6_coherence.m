% testing why grid 6 has higher coherence at high frequencies
clear all;
close all;
clc;

use('cleanpath');
use('pkgs/chronux');
use('pkgs/nsx');
use('pkgs/skellis');

% Chronux parameters
params.Fs=30e3;
params.tapers=[3 5];
params.pad=0;
params.fpass=[0 400];
params.trialave=0;
movingwin=[4 4];

% define grid
grids=defgrids;

for g=5:6
    % load some data
    ns=nsopen(grids(g).sources(1).file);
    data=nsread(ns,1,96,grids(g).sources(1).block(1),100);
% %     ns=nsopen('N:\human\nu\20090804-142641\20090804-142641-004.ns5');
% %     data=nsread(ns,1,96,3000,50);
    d1=data'; % RAW
    clear data;
    d2=reref(d1,'car','badchan',grids(g).badchan); % CAR
    car{g}=mean(d1,2);
    
    % spectrums and coherence
    [c1,p1,s1xy,s1x,s1y,f1]=coherencysegc(d1(:,1),d1(:,77),4,params);
    [c2,p2,s2xy,s2x,s2y,f2]=coherencysegc(d2(:,1),d2(:,77),4,params);
    [scar{g},fcar{g}]=mtspectrumsegc(car{g},4,params);
    sdata=zeros(size(scar{g},1),96);
    fdata=zeros(size(scar{g},1),96);
    parfor k=1:96
        [sdata(:,k),fdata(:,k)]=mtspectrumsegc(d1(:,k),4,params);
    end
    fdata=fdata(:,1);
    
    figure;
    plot(fdata,10*log10(sdata),'Color',[0.8 0.8 0.8],'LineWidth',1);
    hold on;
    plot(fcar{g},10*log10(scar{g}),'k','LineWidth',2);
    title(['Car Spectrum (' grids(g).label ')']);
    
    figure('Position',[917   109   648   876]);
    ax(1)=subplot(411);
    plot(f1,c1); hold on; plot(f2,c2,'r');
    title(['Coherence (' grids(g).label ')']);
    grid on;
    xlim([200 400]);
    legend({'raw','car'},'Location','east');
    ax(2)=subplot(412);
    plot(f1,abs(s1xy)); hold on; plot(f2,abs(s2xy),'r');
    title('Cross-spectra')
    grid on
    ax(3)=subplot(413);
    plot(f1,abs(s1x)); hold on; plot(f2,abs(s2x),'r');
    title('Ch 1 Spectra')
    grid on
    ax(4)=subplot(414);
    plot(f1,abs(s1y)); hold on; plot(f2,abs(s2y),'r');
    title('Ch 77 Spectra')
    grid on
    linkaxes(ax(2:4));
    xlim([200 400]);
    ylim([-0.1 0.3]);
end