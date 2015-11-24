%This function can be used to remove identifying patient information from
%EDF files without loading the entire file into the workspace.

function edf_deidentify(folder)

%Identify all EDF files in a given folder
files = dir([folder '\*.edf']);

for f = 1:length(files)
    
    % filename = 'D:\human CNS\PCH\XLTek_Data\2015PP02_D01_OR.edf';
    % fid = fopen(filename,'r+');
    
    %Open the file
    fid = fopen([folder '\' files(f).name],'r+');
    
    %Move 8 bytes into the file (bof = beginning of file)
    fseek(fid,8,'bof');
    
    %Write over the existing text with the desired string
    %This should be writing over the patient's name
    fwrite(fid,[files(f).name '                      ']);
    
    %Move 168 bytes into the file
    fseek(fid,168,'bof');
    
    %Write over the start date
    fwrite(fid,'XX.XX.XX');
    
    %Close the file
    fclose(fid);
    
end

% [header] = edfread(['F:\2015PP03\' files(f).name]);
% header
% header.patientID