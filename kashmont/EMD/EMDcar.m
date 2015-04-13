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
        CARdata(ch,:) = data(ch,:) - sigavg;
    end
    
    save(['D:\Kari\ECoG\Data\' ictal_state '\ProcData\CAR\' patnum '_CAR.mat'],'CARdata');
    
    clear CARdata data sigavg patnum fieldnames
    
end
