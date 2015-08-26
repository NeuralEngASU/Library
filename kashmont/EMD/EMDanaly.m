
%Assumes "clip.m" has already been run and clip is in form of ".mat" file.
%Files should contain the folderpath and "*.mat"
%runs "window.m" and "EMD.m" (called within windows.m) files


%folderpath = folder containing all raw clips
%ictal_state = Sz or NonSz (also denotes the sheet of the xlfile)
%datatype = 'Raw', 'DN', 'CAR', 'DNCAR'

%folderpath ='E:\data\human CNS\EMD\NonSz\ProcData\CAR'



function EMDanaly(folderpath,xlfile,ictal_state,datatype)

files = dir([folderpath, '\*.mat']);
for f = 1:size(files,1)
%     patnum{f} = files(f).name(1:10);
    patnum{f} = files(f).name(1:13);
end
ptnum = unique(patnum);

for f = 1:size(files,1)
    iddash = strfind(files(f).name,'_');
    patnum{f} = files(f).name(1:(iddash-1));
end

% % load sampling rates from excel file
% load('E:\data\human CNS\EMD\XLvariables\Fs.mat')
% load('E:\data\human CNS\EMD\XLvariables\sznum.mat')
% Fs = xlsread(xlfile,ictal_state,'H3:H100');
Fs = xlsread(xlfile,ictal_state,'F3:F100');
sznum = xlsread(xlfile,ictal_state,'E3:E100');


distcomp.feature( 'LocalUseMpiexec', false );
parpool(32);

for p = 1:size(ptnum,2)
%     filecomp{p} = strncmp(ptnum(p),patnum,8);
    filecomp{p} = strncmp(ptnum(p),patnum,11);
    [~,c]= find(filecomp{p}==1);
%     disp (ptnum{p})
    
    for f = c(1):c(end)
        
        name = strcat(ptnum(p),num2str(sznum(f)))
%         load(['E:\data\human CNS\EMD\Sz\ProcData\CAR\',name{1},'_CAR.mat']);
        load(['E:\data\human CNS\EMD\NonSz\ProcData\CAR\',name{1},'_CAR.mat']);

        
        WinLen = 5;
        %changed from 3
        OvLp = 2;
        
        IMFperWin = [];
        IMFs = [];
           
        parfor ch = 1:size(data,1)
            disp(ch)
            
            %Perform windowed EMD on each channel of raw data
            [IMFs] = window(data(ch,:),500,ch,WinLen,OvLp);
            
            IMFperWin(ch,:) = nonzeros(IMFs);
            
        end
        
        header.Patient = ptnum{p}(1:8);
        header.IctalClassifier = name{1}(9:end);
        header.DataType = 'Windowed CAR EMD';
        header.WindowSize = WinLen;
        header.WindowOverlab = OvLp;
        
        %Save processed data and windowing results
        save(['E:\data\human CNS\EMD\' ictal_state '\WinData\NEW\' name{1} '_CAR_Win.mat'],'IMFperWin','header');
           
        clear data IMFperWin IMFs ch header name 
        
    end
    
    clear f
    
end

delete(gcp('nocreate'));

% for ch = 1:length(IMFperWin)
%     t(ch,:) = nonzeros(IMFperWin{ch});
% end
% figure; plot(t(49,:),'.')



