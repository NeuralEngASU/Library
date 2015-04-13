%Assumes "clip.m" has already been run and clip is in form of ".mat" file.
%Files should contain the folderpath and "*.mat"
%runs "window.m" and "EMD.m" (called within windows.m) files


%folderpath = folder containing all raw clips
%ictal_state = Sz or NonSz (also denotes the sheet of the xlfile)
%datatype = 'Raw', 'DN', 'CAR', 'DNCAR'

function EMDanaly(folderpath, xlfile,ictal_state,datatype)
%folderpath = '/Users/kariashmont/Desktop/Data/clips';

files = dir([folderpath, '/*.mat']);
%load sampling rates from excel file
Fs = xlsread(xlfile,ictal_state,'H3:H100');

distcomp.feature( 'LocalUseMpiexec', false );
parpool(16);

for f = 1:length(files)
    iddot = strfind(files(f).name,'.');
    patnum = files(f).name(1:(iddot-1));
    disp (patnum)
    d = load([folderpath,'/',files(f).name]);
    
    m = fieldnames(d);
    data = d.(m{1});
    
    WinLen = 5;
    OvLp = 3;
    
    IMFperWin = [];
    
   parfor ch = 1:size(data,1)
        disp(ch)
        
        %Perform windowed EMD on each channel of raw data
        [IMFs] = window(data(ch,:),Fs(f),WinLen,ch,OvLp);
        
        IMFperWin(ch,:) = nonzeros(IMFs);
        
    end
            
    %Save processed data and windowing results
    save(['E:\data\human CNS\EMD\' ictal_state '\WinData\' datatype '\' patnum '_Win.mat'],'IMFperWin');
    
    clear IMperWin iddot patnum
    
end

 delete(gcp('nocreate'));

% for ch = 1:length(IMFperWin)
%     t(ch,:) = nonzeros(IMFperWin{ch});
% end
% figure; plot(t(49,:),'.')



