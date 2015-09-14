%load the first nonseizure clip for each patient and calculate the average
%number of IMFs per window and the standard deviation for that clip.  This
%will serve as a baseline measure to compare the ictal and non ictal clips
%for that patient to.

files = dir(['E:\data\human CNS\EMD\NonSz\WinData\NEW\*.mat']);

xlfile =  'E:\data\human CNS\EMDDatabase.xlsx';

for f = 1:size(files,1)
    patnum{f} = files(f).name(1:13);
end
ptnum = unique(patnum);

for f = 1:size(files,1)
    iddot = strfind(files(f).name,'.');
    patnum{f} = files(f).name(1:(iddot-1));
end

clear iddot f c
%%


for p = 1:size(ptnum,2)
    clear f c 
        
        filecomp{p} = strncmp(ptnum{p},patnum,13);
        [~,c]= find(filecomp{p}==1);
        disp (ptnum{p})
        cp=1;
        for f = c(1):c(end)
        load(['E:\data\human CNS\EMD\NonSz\WinData\NEW\',files(f).name]);
        
        sd{p}(cp,:) = roundn(std(IMFperWin,0,2),-2);
        avg{p}(cp,:) = roundn(nanmean(IMFperWin,2),-2);
        v{p}(cp,:) = roundn(var(IMFperWin,0,2),-2);
        m{p}(cp,:) = mode(IMFperWin,2);
        
        cp=cp+1;
        end
    
    baseavg{p} = roundn(nanmean(avg{p},1),-2)';
    basestd{p} = roundn(nanmean(sd{p},1),-2)';
    basevar{p} = roundn(nanmean(v{p},1),-2)';
    basemode{p} = nanmean(m{p},1)';
    
    
    clear sz c
end

%%
save('E:\data\human CNS\EMD\XLvariables\baseavg.mat','baseavg');
save('E:\data\human CNS\EMD\XLvariables\basestd.mat','basestd');
save('E:\data\human CNS\EMD\XLvariables\basevar.mat','basevar');
save('E:\data\human CNS\EMD\XLvariables\basemode.mat','basemode');


%%
grids{1} = [1 64; 65 70; 71 76; 77 82; 83 86; 87 90; 91 94; 95 98]; %2012PP05
grids{2} = [1 64; 65 80; 81 96; 97 104; 105 112; 113 118]; %2013PP01
grids{3} = [1 64; 65 80; 81 96; 97 102; 103 108; 109 114; 115 120]; %2014PP01
grids{4} = [1 64; 65 70; 71 76; 77 82; 83 88; 89 94]; %2014PP02
grids{5} = [1 64; 65 70; 71 76; 77 84; 85 89]; %2014PP04
grids{6} = [1 64; 65 68; 69 74; 75 78; 79 82; 83 88]; %2014PP05
grids{7} = [1 64; 65 70; 71 76; 77 82; 83 86; 87 90]; %2014PP06
grids{8} = [1 16; 17 32; 33 52; 53 72; 73 78; 79 84; 85 90]; %2014PP07

for g = 1:size(grids,2)
for p = 1:size(ptnum,2)
    clear f c 
        
        filecomp{p} = strncmp(ptnum{p},patnum,13);
        [~,c]= find(filecomp{p}==1);
        disp (ptnum{p})
        cp=1;
        for f = c(1):c(end)
        load(['E:\data\human CNS\EMD\NonSz\WinData\2HzStop\5wins\CAR\NEW\3wins\',files(f).name]);
        
        sd{p}(cp,:) = roundn(std(IMFperWin,0,2),-2);
        avg{p}(cp,:) = roundn(nanmean(IMFperWin,2),-2);
        v{p}(cp,:) = roundn(var(IMFperWin,0,2),-2);

        cp=cp+1;
        end
    
    baseavg{p} = roundn(nanmean(avg{p},1),-2)';
    basestd{p} = roundn(nanmean(sd{p},1),-2)';
    basevar{p} = roundn(nanmean(v{p},1),-2)';
    
    
    clear sz c
end
