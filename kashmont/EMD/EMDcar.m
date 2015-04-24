function EMDcar(folderpath,ictal_state)

files = dir([folderpath, '/*.mat']);

for f = 1:length(files)
    iddot = strfind(files(f).name,'.');
    patnum = files(f).name(1:(iddot-1));
    disp (patnum)
    d = load([folderpath,'/',files(f).name]);
    
    %n = files(f).name(1,(1:11));
    m = fieldnames(d);
    data = d.(m{1});
    
    sigavg = nanmean(data);
    
    for ch = 1:size(data,1)
        disp(ch)
        DNCARdata(ch,:) = data(ch,:) - sigavg;
    end
    
    save(['E:\data\human CNS\EMD\' ictal_state '\ProcData\DN_CAR\' patnum '_DNCAR.mat'],'DNCARdata');
    
   % clear CARdata data sigavg patnum fieldnames
    
end
