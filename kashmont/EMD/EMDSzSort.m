%This code sorts seizure onset windows to determine the channel order of
%onset.

%load 
function EMDSzSort(folderpath, xlfile, sheet, ictal_state)

files = dir([folderpath, '/*.mat']);

for f = 1:length(files)
    patnum = files(f).name(1:11);
    disp (patnum)
    d = load([folderpath,'/',files(f).name]);
    
    m = fieldnames(d);
    data = d.(m{1});

%Some channels will have multiple onset times detected.
for ch = 1:length(Raw_szwin)
    firstwin(ch,:) = Raw_szwin{ch}(:,1);
end
$$$$$$$$$$$$
%"szwin" data is padded with zeros to make arrays the same size.
%Sorting will move all zeros to top.
Raw_szwin(Raw_szwin == 0) = NaN;
[win_raw,ch_raw] = sort(Raw_szwin);
%Write the list of channels to sheet 2 of the excel file
xlswrite (xlfile,win_raw,'Sheet3','B3');
xlswrite (xlfile,ch_raw,'Sheet3','A3');
%Convert the window number to number of samps (from start of clip) all channels
Raw_onset = ((Raw_szwin * 2) + 1) * Fs(f);


%Sort onset window results within each channel
DNszwin(DNszwin == 0) = NaN;
[win_dn,ch_dn] = sort(DNszwin);
%Write the list of channels to sheet 2 of the excel file
xlswrite (xlfile,win_dn,'Sheet3','D3');
xlswrite (xlfile,ch_dn,'Sheet3','C3');
%Convert the onset window to number of samps
%start of clip would be (idwin*2)-1...to get median of window changed to
%(idwin*2)+1
DNonset = ((DNszwin * 2) + 1) * Fs(f);

%Sort onset window results within each channel
CARszwin(CARszwin == 0) = NaN;
[win_car,ch_car] = sort(CARszwin);
%Write the list of channels to sheet 2 of the excel file
xlswrite (xlfile,win_car,'Sheet3','F3');
xlswrite (xlfile,ch_car,'Sheet3','E3');
%Convert the onset window to number of samps
CARonset = ((CARszwin * 2) + 1) * Fs(f);

%Sort onset window results within each channel
DN_CARszwin(DN_CARszwin == 0) = Nan;
[win_dn_car,ch_dn_car] = sort(DN_CARszwin);
%Write the list of channels to sheet 2 of the excel file
xlswrite (xlfile,win_car,'Sheet3','H3');
xlswrite (xlfile,ch_car,'Sheet3','G3');
%Convert the onset window to number of samps
DN_CARonset = ((DN_CARszwin * 2) + 1) * Fs(f);