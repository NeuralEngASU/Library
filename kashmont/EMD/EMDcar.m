%folderpath = 'E:\data\human CNS\EMD'
%ictal_state = 'Sz' or 'NonSz'
%subfolder = 'clips' or 'ProcData\DN'
%patient = 2014PP01
%type = 'CAR'

function EMDcar(folderpath,ictal_state,subfolder,patient,xlfile,type)

% grids = [1 64; 65 70; 71 76; 77 82; 83 86; 87 90; 91 94; 95 98]; %2012PP05
 grids = [1 64; 65 80; 81 96; 97 104; 105 112; 113 118]; %2013PP01
% grids = [1 64; 65 80; 81 96; 97 102; 103 108; 109 114; 115 120]; %2014PP01
% grids = [1 64; 65 70; 71 76; 77 82; 83 88; 89 94]; %2014PP02
% grids = [1 64; 65 70; 71 76; 77 84; 85 89]; %2014PP04
% grids = [1 64; 65 68; 69 74; 75 78; 79 82; 83 88]; %2014PP05
% grids = [1 64; 65 70; 71 76; 77 82; 83 86; 87 90]; %2014PP06
% grids = [1 16; 17 32; 33 52; 53 72; 73 78; 79 84; 85 90]; %2014PP07

files = dir([folderpath '\' ictal_state '\' subfolder '/*.mat']);

%Load sampling frequency from excel sheet
Fs = xlsread(xlfile,ictal_state,'H3:H100');

%identify the files matching the desired patient
for f = 1:length(files)
    patnum(f,:) = files(f).name(1:8);
    idfiles(f,:) = strcmp (patnum(f,:),patient);
end

[r,~] = find (idfiles == 1);

for i = 1:size(r,1)
    patfiles(i,:) = files(r(i)).name;
    
    iddot = strfind(patfiles(i,:),'.');
    patnum = patfiles(i,(1:(iddot-1)));
    disp (patnum)
    d = load([folderpath '\' ictal_state '\' subfolder '\' patfiles(i,:)]);
    
    m = fieldnames(d);
    rawdata = d.(m{1});
    
<<<<<<< HEAD
    for g = 1:size(grids,1)
        sigavg(g,:) = nanmean(rawdata((grids(g,1):grids(g,2)),:));
=======
    for ch = 1:size(data,1)
        disp(ch)
        DNCARdata(ch,:) = data(ch,:) - sigavg;
>>>>>>> f535cc595bf05d99bee6a68bdd2c9e649ca8c6ae
    end
  
    for g = 1:size(grids,1)
        
        for ch = grids(g,1):grids(g,2)
            disp(ch)
            data(ch,:) = rawdata(ch,:) - sigavg(g,:);
        end
        
    end
    
    header.Patient = patnum(1:8);
    header.IctalClassifier = patnum(9:end);
    header.DataType = type;
    header.SamplingFrequency = Fs(r(i));
    
<<<<<<< HEAD
    save(['E:\data\human CNS\EMD\' ictal_state '\ProcData\CAR\' patnum '_CAR.mat'],'data', 'header','-v7.3');
    %save(['E:\data\human CNS\EMD\' ictal_state '\ProcData\DN_CAR\' patnum 'CAR.mat'],'data', 'header');
    
    clear CARdata data rawdata sigavg patnum fieldnames patfiles
=======
    save(['E:\data\human CNS\EMD\' ictal_state '\ProcData\DN_CAR\' patnum '_DNCAR.mat'],'DNCARdata');
    
   % clear CARdata data sigavg patnum fieldnames
>>>>>>> f535cc595bf05d99bee6a68bdd2c9e649ca8c6ae
    
end
