% generate figures of average cross-correlation function vs. separation distance
clear all;
close all;
clc;

% set up environment
use('cleanpath');
use('pkgs/skellis');
use('parfor',8);

% specify rereferencing
ref='unr';

% define grids
grids=defgrids;

% loop over the grids
load('d:/matlab/ecogres/g1mccf_UNR.mat','lags');
hhd=zeros(nnz(lags>=0),length(grids));
parfor g=1:length(grids)
    d=load(['d:/matlab/ecogres/g' num2str(g) 'mccf_' upper(ref) '.mat'],'mccf','lags','chanpairs','layout','spacing');
    d.mccf(1:4000,:)=[];
    lg=d.lags(4001:end);
    [mccf,seps,pairsep,seccf]=avgpersep(d.mccf,d.chanpairs,d.layout,d.spacing,grids(g).badchan);

    tmphhd=zeros(1,size(lg,1));
    hh=zeros(1,size(lg,1));
    for k=1:size(lg,1)
        % interpolate a smoothing spline
        ok_ = isfinite(seps) & isfinite(mccf(k,:)');
        ft_ = fittype('smoothingspline');
        cf_ = fit(seps(ok_),mccf(k,ok_)',ft_);

        hh(k)=cf_(0) - cf_(seps(end));
        if(hh(k)>0)
            x=0:0.001:seps(end);
            [val,idx]=min(abs(cf_(x)-(cf_(seps(end))+hh(k)/2)));
            tmphhd(k)=x(idx);
        else
            tmphhd(k)=0;
        end

        % % % plot the fit and original data
        % % plot(seps,mccf(k,:)','x');
        % % hold on;
        % % plot(cf_);
        % % hold off;
        % % pause
    end
    hhd(:,g)=tmphhd;
end

figure;
hold all;
mymap=colormap(hsv);
clr=[mymap([1 5 8 10 35 37],:); 0 0 0;];
for g=1:length(grids)
    plot(lags(lags>=0),hhd(:,g),'Color',clr(g,:),'LineWidth',2);
end
%set(gca,'YScale','log');
legend({grids(:).shortname})
grid on;

saveas(gcf,['d:/matlab/ecogres/figures/MCCFHHD_' upper(ref) '.fig']);
saveas(gcf,['d:/matlab/ecogres/figures/MCCFHHD_' upper(ref) '.png']);
saveas(gcf,['d:/matlab/ecogres/figures/MCCFHHD_' upper(ref) '.eps'],'epsc2');
