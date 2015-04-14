% generate figures of auto-correlation functions
clear all;
close all;
clc;

% set up environment
use('cleanpath');
use('pkgs/skellis');

% define grids
grids=defgrids;

% find the average correlation of each raw channel with the common average
rho=cell(size(grids));
for g=1:length(grids)
    load(['d:\matlab\ecogres\g' num2str(g) 's1.mat']);
    [car,layout,spacing,ref]=reref(raw,'car','badchan',grids(g).badchan);
    tmp=corrcoef([ref raw]);
    rho{g}=tmp(2:end,1);
    rho{g}(grids(g).badchan)=[];
end

% means for each grid
cellfun(@mean,rho)
cellfun(@std,rho)

% mean across all SM grids
tmpval=cat(1,rho{1:4});
mean(tmpval)
std(tmpval)

% mean across all UA grids
tmpval=cat(1,rho{5:6});
mean(tmpval)
std(tmpval)
