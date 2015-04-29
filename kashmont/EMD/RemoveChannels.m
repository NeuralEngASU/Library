%Open an existing .mat file, read the total number of channels from an
%excel sheet and remove any empty channels from the .mat file and re-save.

%folderpath = parent folder containing files
%ictal_state = 'Sz' or 'NonSz'
%subfoler = 'clips', 'Raw', 'CAR', 'DN', 'DN_CAR'
%type = 'denoised', 'car', raw, etc.

function RemoveChannels(folderpath, xlfile,ictal_state,subfolder,type)

files = dir([folderpath '\' ictal_state '\' subfolder '/*.mat']);

%load number of channels from excel file
ch = xlsread(xlfile,ictal_state,'O3:O100');
Fs = xlsread(xlfile,ictal_state,'H3:H100');

parpool(16);

for f = 1:length(files)
    iddot = strfind(files(f).name,'.');
    patnum = files(f).name(1:(iddot-1));
    disp (patnum)
    d = load([folderpath,'\' ictal_state '\' subfolder '\',files(f).name]);
    
    m = fieldnames(d);
    olddata = d.(m{1});
    
    parfor nch = 1:ch(f)
        data(nch,:) = olddata(nch,:);
    end
    
    header.Patient = patnum(1:8);
    header.IctalClassifier = patnum(9:end);
    header.DataType = type;
    header.SamplingFrequency = Fs(f);
    
    save([folderpath '\' ictal_state '\' subfolder '\test\' patnum],'data','header');
    
    clear iddot patnum d m olddata data nch
    
end

 delete(gcp('nocreate'));




