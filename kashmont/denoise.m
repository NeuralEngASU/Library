%this function requires Chronux

function [DNdata] = denoise(data,Fs)
    
params.tapers=[4.5 8];
params.pad=1;
params.Fs=Fs;
params.fpass=[0 params.Fs/2];

DNdata=rmlinesc(data,params,.05,'y');