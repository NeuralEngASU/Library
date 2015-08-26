%folderpath = 'E:\data\human CNS\EMD'
%ictal_state = 'Sz' or 'NonSz'
%subfolder = 'clips' or 'ProcData\DN'
%patient = 2014PP01
%type = 'CAR'

function EMDcar(folderpath,ictal_state,subfolder,xlfile)

grids{1} = [1 64; 65 70; 71 76; 77 82; 83 86; 87 90; 91 94; 95 98]; %2012PP05
grids{2} = [1 64; 65 80; 81 96; 97 104; 105 112; 113 118]; %2013PP01
grids{3} = [1 64; 65 80; 81 96; 97 102; 103 108; 109 114; 115 120]; %2014PP01
grids{4} = [1 64; 65 70; 71 76; 77 82; 83 88; 89 94]; %2014PP02
grids{5} = [1 64; 65 70; 71 76; 77 84; 85 89]; %2014PP04
grids{6} = [1 64; 65 68; 69 74; 75 78; 79 82; 83 88]; %2014PP05
grids{7} = [1 64; 65 70; 71 76; 77 82; 83 86; 87 90]; %2014PP06
grids{8} = [1 16; 17 32; 33 52; 53 72; 73 78; 79 84; 85 90]; %2014PP07

num = xlsread(xlfile,ictal_state,'E3:E100');

files = dir([folderpath '\' ictal_state '\' subfolder '\*.mat']);

for f = 1:size(files,1)
    patnum{f} = files(f).name(1:13);
end
ptnum = unique(patnum);

for f = 1:size(files,1)
    iddot = strfind(files(f).name,'.');
    patnum{f} = files(f).name(1:(iddot-1));
end
clear f

for p = 1:size(ptnum,2)
    filecomp{p} = strncmp(ptnum{p},patnum,11);
    [~,c]= find(filecomp{p}==1);
    disp (ptnum{p})
    
    for f = c(1):c(end)
        
        %         load(['/Users/kariashmont/Desktop/Data/WinData/2HzStop/CAR/',files(f).name]);
        name = num2str(patnum{f})
        load(['E:\data\human CNS\EMD\NonSz\clips\',name,'.mat']);

    for g = 1:size(grids{p},1)
        sigavg(g,:) = nanmean(data((grids{p}(g,1):grids{p}(g,2)),:));
          
        for ch = grids{p}(g,1):grids{p}(g,2)
            disp(ch)
            newdata(ch,:) = data(ch,:) - sigavg(g,:);
        end
        
    end
    
    clear data

    data = newdata;
    
    header.Patient = ptnum{p}(1:8);
    header.IctalClassifier = name(9:end);
    header.DataType = 'CAR';
   
    save(['E:\data\human CNS\EMD\' ictal_state '\ProcData\CAR\' num2str(patnum{f}) '_CAR.mat'],'data', 'header','-v7.3');
%     save(['E:\data\human CNS\EMD\NonSz\ProcData\CAR\2014PP07NonSz5_CAR.mat'],'data', 'header','-v7.3');
   
    %save(['E:\data\human CNS\EMD\' ictal_state '\ProcData\DN_CAR\' patnum 'CAR.mat'],'data', 'header');
    
    clear CARdata data newdata rawdata sigavg fieldnames patfiles
    
   % clear CARdata data sigavg patnum fieldnames
    
    end
    clear f c
end

