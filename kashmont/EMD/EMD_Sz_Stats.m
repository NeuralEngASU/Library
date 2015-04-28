

function [] = EMD_Sz_Stats(filepath,xlfile,ictal_state)

%Read seizure onset and clip start times, clinical onset channel and sampling rate from excel file
clonset = xlsread(xlfile,1,'L3:L103');
clpstrt = xlsread(xlfile,1,'J3:J103');
clszch = xlsread(xlfile,1,'M3:M103');
Fs = xlsread(xlfile,1,'H3:H103');

%create aray of clinical onset and clip start times
for n = 1:length(clonset)
    
    %convert seizure onset and clip start times to number of samples
    clonsetsamps(n,:) = (clonset(n,(1:2))*3600) + (clonset(n,(4:5))*60) + (clonset(n,(7:8))*500);
    clpstrtsamps(n,:) = (clpstrt(n,(1:2))*3600) + (clpstrt(n,(4:5))*60) + (clpstrt(n,(7:8))*500);
    
end


%load arrays
type = ['Raw' 'CAR' 'DN' 'DN_CAR'];

for t = 1:4
    
files = dir([folderpath '\' ictal_state '\WinData\' type(t) , '/*.mat'])

for f = 1:length(files)
    disp (files(f).name)
    d = load([folderpath,'/',files(f).name]);
    
    m = fieldnames(d);
    IMFperWin = d.(m{1});
    $$EMDonset??

    %%
    threshold = char('mode', 'avg', 'sd')
    for thresh = 1:3
    EMD = EMDonset.(threshold(thresh,:));

    %convert EMDonset window number to number of samples and add to clip onset
    EMDsamps = ((EMD.*2)+2)+clpstrtsamps(n,:);

    %convert EMD detected onset window to sample number within clip
%start of clip would be (idwin*2)-1...to get median of window changed to
%(idwin*2)+1
emdonset = ((idwin * 2) + 1) * 500;
    
    for ch = 1:length(EMDsamps)
        
        %Compare EMD detected onset to clinical onset in designated onset
        %channel
        R_diff(ch,:) = abs((EMDsamps(ch,:)) - clonsetsamps(n,:) );
    end
        
        %Determine if the difference is within one minute(30000 samples) and
        %write an 'x' in the excel column if it is.
        
        %Label true positives
        if R_diff(w) <= 30000
            Raw_TP(w) = 1;
        end
        
        %Label false negatives
        if R_diff(w) >= 30000
            Raw_FN(w) = 4;
        end
        
    end
    
    clear w
    
    for w = 1:length(DNonset)
        %Compare EMD detected onset to clinical onset
        DNdiff = clonsetsamps(n) - (clpstrtsamps(n) + DNonset);
        %Label true positives
        if DNdiff <= 30000
           DN_TP(w) = 1;
        end
        
        %Label false negatives
        if DNdiff(w) >= 30000
           DN_FN(w) = 4;
        end
    end
    
    clear w
    
    for w = 1:length(CARonset)
        
        %Compare EMD detected onset to clinical onset
        CARdiff = clonsetsamps(n) - (clpstrtsamps(n) + CARonset);
        
        %Label true positives
        if CARdiff <= 30000
            CAR_TP(w) = 1;
        end
        
        %Label false negatives
        if CARdiff >= 30000
            CAR_FN(w) = 4;
        end
        
    end
    
    clear w
    
    for w = 1:length(DN_CARonset)
        
        %Compare EMD detected onset to clinical onset
        DN_CARdiff = clonsetsamps(n) - (clpstrtsamps(n) + DN_CARonset);
        
        %Label true positives
        if DN_CARdiff <= 30000
            DN_CAR_TP(w) = 1;
        end
        
        %Label false negatives
        if DN_CARdiff >= 30000
            DN_CAR_FN(w) = 4;
        end
        
    end
    
end

end
%%
%Concatinate the different analysis types into one matrix and save
%Column 1 = Raw, 2 = Denoised, 3 = CAR, 4 = DN+CAR

Sz_TP = [RawTP DN_TP CAR_TP DN_CAR_TP];
save(['/Users/kariashmont/Desktop/Data/clips/seizure/' Sz_TP '.mat'],'Sz_TP');
%save(['C:\Users\Kari\Desktop\Epilepsy\Matlab\data\clips\seizure\' Sz_TP'.mat'],'Sz_TN');

Sz_FN = [RawFN DN_FN CAR_FN DN_CAR_FN];
save(['/Users/kariashmont/Desktop/Data/clips/seizure/' Sz_FN '.mat'],'Sz_FN');
%save(['C:\Users\Kari\Desktop\Epilepsy\Matlab\data\clips\seizure\' Sz_FN'.mat'],'Sz_TN');