% generate figures of auto-correlation functions
clear all;
close all;
clc;

%{
    0.0458    0.0020   -0.0049    0.0004
    0.0634    0.0059   -0.0064    0.0013
    0.0396    0.0049   -0.0074    0.0006
    0.0811    0.0029   -0.0108    0.0011
    0.1309    0.0106   -0.0738    0.0101
    0.1074    0.0121   -0.0097    0.0029
    0.0298    0.0140   -0.0038    0.0038
    0.0319    0.0041   -0.0036    0.0012
    0.0600    0.0152   -0.0046    0.0016
    0.0660    0.0236   -0.0120    0.0032
%}

% set up environment
use('cleanpath');
use('parfor',8);
use('pkgs/skellis');

% define grids
grids=defgrids;

% whether to generate figures or not
GEN_FIGS=0;

% rereferencing
ref='unr';

% loop over grids
bv=cell(size(grids));
hh=cell(size(grids));
for g=5%1:length(grids)
    disp(['grid ' num2str(g)]);
    
    % load data
    load(['d:/matlab/ecogres/g' num2str(g) 'acfvtime_' upper(ref) '.mat']);

    % baseline value
    bv{g}=mean(squeeze(mean(acfs(end-499:end,:,setdiff(1:size(acfs,3),grids(g).badchan)))),1);

    % % % full duration half maximum
    % % lhsidx=find(lags<0);
    % % lhserr=abs(acfs( lhsidx,:,: )-0.5).^2;
    % % [dummy,lhs]=min(lhserr);
    % % lhs=squeeze(lhsidx(lhs));
    % % rhsidx=find(lags>0);
    % % rhserr=abs(acfs( rhsidx,:,: )-0.5).^2;
    % % [dummy,rhs]=min(rhserr);
    % % rhs=squeeze(rhsidx(rhs));
    % % fdhm=lags(rhs)-lags(lhs);
    
    % half-height measure
    lhsidx=find(lags<0);
    lhserr=abs(acfs( lhsidx,:,: )-0.5).^2;
    [dummy,lhs]=min(lhserr);
    lhs=squeeze(lhsidx(lhs));
    rhsidx=find(lags>0);
    rhserr=abs(acfs( rhsidx,:,: )-0.5).^2;
    [dummy,rhs]=min(rhserr);
    rhs=squeeze(rhsidx(rhs));
    hhm=lags(rhs)-lags(lhs);

    % find common outliers
    bad=cell(1,size(hhm,2));
    for k=1:size(hhm,2)
        bad{k}=outliers(hhm(:,k));
    end
    bad=cat(1,bad{:});
    unique_bad=sort(unique(bad),'ascend');
    common_bad=unique_bad(histc(bad,unique_bad)>0.5*size(hhm,2));

    ok_time=setdiff(1:size(hhm,1),common_bad);
    ok_chan=setdiff(1:size(hhm,2),grids(g).badchan);
    hh{g}=mean(hhm(ok_time,ok_chan),1);
end

% columns are
% AVG FDHM, STD FDHM, AVG BASELINE VALUE, STD BASELINE VALUE
excel_data=[cellfun(@mean,hh') cellfun(@std,hh') cellfun(@mean,bv') cellfun(@std,bv')];

% % % save fit parameters for statistical testing later
% % save(['d:\results\ecogres\acf' append '_fitparams.mat'],'fdhm','sval','sidx')
