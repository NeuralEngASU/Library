[] = EMDStats(xlfile,clpstart,offset,idwin)

%calculate sample point within clip corresponding to clinical seizure onset
%load seizure onset times from excel file
clonset = xlsread(xlfile,1,'K3:K50');
    
%convert seizure onset times to number of samples
convonset(n,:) = (onset(n,(1:2))*3600) + (onset(n,(4:5))*60) + (onset(n,(7:8))*500);
    
%convert EMD detected onset window to sample number within clip
%start of clip would be (idwin*2)-1...to get median of window changed to
%(idwin*2)+1
emdonset = ((idwin * 2) + 1) * 500;

%calculate difference between clinical and EMD onset
onsetdiff = clonset - emdonset;

