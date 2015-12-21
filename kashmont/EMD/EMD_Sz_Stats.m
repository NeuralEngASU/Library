

function [] = EMD_Sz_Stats(filepath,xlfile,ictal_state)

%Read seizure onset and clip start times, clinical onset channel and sampling rate from excel file
[~,clonset] = xlsread(xlfile,1,'L3:L103');
[~,clpstrt] = xlsread(xlfile,1,'J3:J103');
[~,clszch] = xlsread(xlfile,1,'N3:N103');
Fs = xlsread(xlfile,1,'H3:H103');


%% convert seizure onset and clip start times to number of samples
for f = 1:size(clonset,1)
    clonsetsamps(f,:) = (str2double(clonset{f}(1:2))*3600 + str2double(clonset{f}(4:5))*60 + str2double(clonset{f}(7:8)))*Fs(f);
    clpstrtsamps(f,:) = (str2double(clpstrt{f}(1:2))*3600 + str2double(clpstrt{f}(4:5))*60 + str2double(clpstrt{f}(7:8)))*Fs(f);

    offsetsamps(f) = clonsetsamps(f,:) - clpstrtsamps(f,:);
    onsetwin(f) = floor(offsetsamps(f)/(Fs(f)*2));
end


    
%load arrays
type = {'Raw' 'CAR' 'DN' 'DN_CAR'};

for t = 1:size(type,2)
    
    files = dir([folderpath '\' ictal_state '\WinData\2HzStop\' type{t}, '\*.mat'])
    
    for f = 1:size(files,1)
        
        disp (files(f).name)
        load([folderpath '\' ictal_state '\WinData\2HzStop\' type{t},'\',files(f).name]);
        threshold = {'mode' 'avg' 'sd'};
        
        for thresh = 1:size(threshold,2)
            classEMD.(threshold{thresh}) = zeros(size(IMFperWin,1),size(ii,2)-1);
            
            for ch = 1:size(IMFperWin,1)
                iii = [onsetwin(f)-6:-12:1];
                ii = horzcat(sort(iii),[onsetwin(f)+6:12:size(IMFperWin,2)]);
                
                for i = 1:(size(ii,2)-1)
                    class = find((labels.(threshold{thresh})(ch,(ii(i):ii(i+1)-1)))==1);
                                                    
                    if isempty(class)
                        %label true negatives (3 = TN)
                        classEMD.(threshold{thresh})(ch,i) = 3;
                    end
                    
                    if ~isempty(class)
                        %label false positives (2 = FP)
                        classEMD.(threshold{thresh})(ch,i) = 2;
                    end
                    
                end %i
                
                for w = (onsetwin(f)-5) : (onsetwin(f)+5)
                    reclass = find((classEMD.(threshold{thresh})(ch,w)==2));
                    
                    if ~isempty(reclass)
                        %label true postitives (1 = TP)
                        classEMD.(threshold{thresh})(ch,w) = 1;
                    end
                    
                    if isempty(reclass)
                        %label false negatives (4 = FN)
                        classEMD.(threshold{thresh})(ch,w) = 4;
                    end
                end %w
                
            end %ch
        end %thresh
    end %f
          
