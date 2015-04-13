%this function requires Chronux


function EMDdenoise(folderpath,xlfile,ictal_state)
%folderpath = '/Users/kariashmont/Desktop/Data/clips';

files = dir([folderpath, '\*.mat']);
Fs = xlsread(xlfile,ictal_state,'H3:H100');

parpool(8);

for f = 1:length(files)
    iddot = strfind(files(f).name,'.');
    patnum = files(f).name(1:(iddot-1));
    disp (patnum)
    d = load([folderpath,'/',files(f).name]);
    
    %n = files(f).name(1,(1:11));
    m = fieldnames(d);
    data = d.(m{1});
     
    params.tapers=[4.5 8];
    params.pad=5;
    params.Fs=Fs(f);
    params.fpass=[0 params.Fs/2];
    
    parfor ch = 1:size(data,1)
        disp(ch)
        DN=rmlinesc(data(ch,:),params,.05,'n');
        DNdata(ch,:) = DN;
    end
    
    save(['E:\data\human CNS\EMD\' ictal_state '\ProcData\DN\' patnum '_DN.mat'],'DNdata');
    
    clear DNdata data patnum fieldnames
    
end

delete(gcp('nocreate'));