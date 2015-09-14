

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
       
    %%
    %raster plot of EMD detected onset times vs. channels of detected
    %onsets, centered on clinically determined onset time with different
    %seizures in different colors
    
    %Raster by window number
    
    
%%
%             szoffset(f).(threshold{thresh}) = abs(EMDonset.(threshold{thresh})- onsetwin(f));
%             
%         end
%     end
%     
%   
%     for f = 1:size(files,1)
%         for thresh = 1:size(threshold,2)
%             %Label true positives
%             [rowsTP,colsTP] = find(szoffset(f).(threshold{thresh})<=5);
%             [rowsFP,colsFP] = find(szoffset(f).(threshold{thresh})>=5);
%        
%       for ch = 1:size(szoffset(f).(threshold{thresh}),1)
%             
%             if ~isempty (TP)
%                 labels.(threshold{thresh})(ch,(onsetwin(f)-5:onsetwin(f)+5)) = 1;
%             end
%             
%             if isempty (TP)
%                 labels.(threshold{thresh})(ch,(onsetwin(f)-5:onsetwin(f)+5)) = 4;
%             end
%             
%             if ~isempty(FP)
%                 labels.(threshold{thresh})(ch,(EMDonset  ) = 4;
% 
% 
%                     EMDcomp.(threshold{thresh}).(type{t}).FP = find(EMDcompare>=30);
%                                         
%                 R_diff(w) <= 30000
%                 Raw_TP(w) = 1;
%             end
%             
%             %Label false negatives
%             if R_diff(w) >= 30000
%                 Raw_FN(w) = 4;
%             end
%         
%         
%             idcomma = strfind(clszch{f},',');
%             onch = clszch{f}(1);
%             for i = 1:size(idcomma,2)
%                 ii = i+1;
%                 if ii <=size(idcomma,2)
%                     onch = [onch clszch{f}(idcomma(:,i)+1:idcomma(:,ii)-1)]
%                 end
%             end
%             onch = [onch clszch{f}(idcomma(:,end)+1:end)];
%             onch = str2num(onch);
%             
%     $$        for ch = 1:size(onch,2)
%             %Compare EMD detected onset to clinical onset in designated onset
%             %channel
%             R_diff(onch(ch),:) = abs((EMDsamps(onch(ch),:)) - clonsetsamps(f,:) );
%             end
%         
%         %Determine if the difference is within one minute(30000 samples) and
%         %write an 'x' in the excel column if it is.
%         
%     end
%     
%     clear w
%     
%     for w = 1:length(DNonset)
%         %Compare EMD detected onset to clinical onset
%         DNdiff = clonsetsamps(f) - (clpstrtsamps(f) + DNonset);
%         %Label true positives
%         if DNdiff <= 30000
%             DN_TP(w) = 1;
%         end
%         
%         %Label false negatives
%         if DNdiff(w) >= 30000
%             DN_FN(w) = 4;
%         end
%     end
%     
%     clear w
%     
%     for w = 1:length(CARonset)
%         
%         %Compare EMD detected onset to clinical onset
%         CARdiff = clonsetsamps(f) - (clpstrtsamps(f) + CARonset);
%         
%         %Label true positives
%         if CARdiff <= 30000
%             CAR_TP(w) = 1;
%         end
%         
%         %Label false negatives
%         if CARdiff >= 30000
%             CAR_FN(w) = 4;
%         end
%         
%     end
%     
%     clear w
%     
%     for w = 1:length(DN_CARonset)
%         
%         %Compare EMD detected onset to clinical onset
%         DN_CARdiff = clonsetsamps(f) - (clpstrtsamps(f) + DN_CARonset);
%         
%         %Label true positives
%         if DN_CARdiff <= 30000
%             DN_CAR_TP(w) = 1;
%         end
%         
%         %Label false negatives
%         if DN_CARdiff >= 30000
%             DN_CAR_FN(w) = 4;
%         end
%         
%     end
%     
% end
% 
% end
% %%
% %Concatinate the different analysis types into one matrix and save
% %Column 1 = Raw, 2 = Denoised, 3 = CAR, 4 = DN+CAR
% 
% Sz_TP = [RawTP DN_TP CAR_TP DN_CAR_TP];
% save(['/Users/kariashmont/Desktop/Data/clips/seizure/' Sz_TP '.mat'],'Sz_TP');
% %save(['C:\Users\Kari\Desktop\Epilepsy\Matlab\data\clips\seizure\' Sz_TP'.mat'],'Sz_TN');
% 
% Sz_FN = [RawFN DN_FN CAR_FN DN_CAR_FN];
% save(['/Users/kariashmont/Desktop/Data/clips/seizure/' Sz_FN '.mat'],'Sz_FN');
% %save(['C:\Users\Kari\Desktop\Epilepsy\Matlab\data\clips\seizure\' Sz_FN'.mat'],'Sz_TN');
% 
% 
% 
%             
% %             EMD = EMDonset.(threshold{thresh});
%             
% %             %convert EMDonset window number to number of samples and add to clip onset
% %             %EMDsamps = (EMD-(window length-overlap)/2)*(Fs(f)*(window length - overlap))+((Fs(f)*window length)/2)
% %             EMDsamps = (EMD-1)*(Fs(f)*2)+((Fs(f)*5)/2) + clpstrtsamps(f);
% %            
% %             %compare all of the EMD identified onset windows to the
% %             %clinical onset time (both in number of samples)
% %             EMDcompare = floor(abs(EMDsamps-clonsetsamps(f))/Fs(f));
%             
%             %Compare EMDonset window to clinical onset window