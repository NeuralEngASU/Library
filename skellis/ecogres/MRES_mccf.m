% generate figures of auto-correlation functions
clear all;
close all;
clc;

% set up environment
use('cleanpath');
use('parfor',8);
use('pkgs/skellis');

% define grids
grids=defgrids;

% whether to generate figures or not
GEN_FIGS=0;

% rereferencing
ref='car';

% loop over grids
for g=1:4%1:length(grids)
    % load data
    load(['d:/matlab/ecogres/g' num2str(g) 'cvd_' upper(ref) '.mat']);
    tmprho=mean(avg.rho,1);
    tmpsep=avg.seps;
    
    disp(['Grid ' num2str(g)]);
    idx=find(tmpsep>=2,1);
    disp([' * correlation was ' num2str(tmprho(idx)) ' at ' num2str(tmpsep(idx)) ' mm']);
    disp([' * correlation was ' num2str(nanmean(tmprho(end-3:end))) ' between ' num2str(tmpsep(end-3)) ' and ' num2str(tmpsep(end)) ' mm']);
    disp(' ');

    % % % interpolate a smoothing spline
    % % ok_ = isfinite(tmpsep{g}) & isfinite(tmprho{g}(:));
    % % ft_ = fittype('smoothingspline');
    % % cf_{g} = fit(tmpsep{g}(ok_),tmprho{g}(ok_)',ft_);
    % % 
    % % hh  = cf_{g}(0) - cf_{g}(tmpsep{g}(end));
    % % x   = 0:0.001:tmpsep{g}(end);
    % % [val,idx]=min(abs(cf_{g}(x)-(cf_{g}(tmpsep{g}(end))+hh/2)));
    % % hhd(g)=x(idx);

    % % % plot
    % % plot(tmpsep{g},tmprho{g},'x');
    % % hold on;
    % % plot(x,cf_{g}(x),'r');
    % % hold off;
    % % pause;
end

%excel_data=[cellfun(@mean,fd') cellfun(@std,fd') cellfun(@mean,bv') cellfun(@std,bv')];

% % % save fit parameters for statistical testing later
% % save(['d:\results\ecogres\acf' append '_fitparams.mat'],'fdhm','sval','sidx')
