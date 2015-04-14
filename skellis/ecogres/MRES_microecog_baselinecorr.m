% generate figures of auto-correlation functions
clear all;
close all;
clc;

% set up environment
use('cleanpath');
use('pkgs/skellis');

% define grids
grids=defgrids;

rho=cell(1,2);
for k=[1 3]
    d1=load(['d:/matlab/ecogres/g' num2str(k) 's1.mat']);
    d2=load(['d:/matlab/ecogres/g' num2str(k+1) 's1.mat']);

    d1.raw(:,grids(k).badchan)=[];
    d2.raw(:,grids(k+1).badchan)=[];
    
    rho{k}=zeros(size(d2.raw,2),size(d1.raw,2));
    for m=1:size(d1.raw,2)
        tmp=corrcoef([d1.raw(:,m) d2.raw]);
        rho{k}(:,m)=tmp(2:end,1);
    end
end

pop=cat(1,rho{1}(:),rho{3}(:));
mean(pop)
std(pop)