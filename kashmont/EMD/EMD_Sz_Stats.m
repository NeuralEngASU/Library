

function [] = EMD_Sz_Stats(xlfile_S, xlfile_NS, filepath)

%load arrays
load([filepath 'Raw_onset.mat']);
load([filepath 'DNonset.mat']);
load([filepath 'CARonset.mat']);
load([filepath 'DN_CARonset.mat']);


%load seizure onset times from excel file
onset = xlsread(xlfile_S,1,'K3:K103');

%load clip start times from excel file
sz_clpstrt = xlsread(xlfile_S,1,'H3:H103');

%Read clinical onset channel from excel file
szch = xlsread(xlfile_S,1,'L3:L103');

for n = 1:length(onset)
    %convert seizure onset times to number of samples
    convonset(n,:) = (onset(n,(1:2))*3600) + (onset(n,(4:5))*60) + (onset(n,(7:8))*500);
    
    %convert clip start times to number of samples
    sz_clpstrtsamps(n,:) = (sz_clpstrt(n,(1:2))*3600) + (sz_clpstrt(n,(4:5))*60) + (sz_clpstrt(n,(7:8))*500);
    
    for w = 1:length(Raw_onset)
        
        %Compare EMD detected onset to clinical onset in designated onset
        %channel
        R_diff(w) = abs(convonset(n) - (clpstrtsamps(n) + Raw_onset(szch(n),w)));
        
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
        DNdiff = convonset(n) - (clpstrtsamps(n) + DNonset);
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
        CARdiff = convonset(n) - (clpstrtsamps(n) + CARonset);
        
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
        DN_CARdiff = convonset(n) - (clpstrtsamps(n) + DN_CARonset);
        
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

%%
%Concatinate the different analysis types into one matrix and save
%Column 1 = Raw, 2 = Denoised, 3 = CAR, 4 = DN+CAR

Sz_TP = [RawTP DN_TP CAR_TP DN_CAR_TP];
save(['/Users/kariashmont/Desktop/Data/clips/seizure/' Sz_TP '.mat'],'Sz_TP');
%save(['C:\Users\Kari\Desktop\Epilepsy\Matlab\data\clips\seizure\' Sz_TP'.mat'],'Sz_TN');

Sz_FN = [RawFN DN_FN CAR_FN DN_CAR_FN];
save(['/Users/kariashmont/Desktop/Data/clips/seizure/' Sz_FN '.mat'],'Sz_FN');
%save(['C:\Users\Kari\Desktop\Epilepsy\Matlab\data\clips\seizure\' Sz_FN'.mat'],'Sz_TN');