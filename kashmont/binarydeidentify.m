% F:\2015PP03

function binarydeidentify(file_location)

files = dir([file_location '\*.edf']);

for f = 1:length(files)
    
    % filename = 'D:\human CNS\PCH\XLTek_Data\2015PP02_D01_OR.edf';
    % fid = fopen(filename,'r+');
    fid = fopen(['F:\2015PP03\' files(f).name],'r+');
    
    fseek(fid,8,'bof');
    
    fwrite(fid,[files(f).name '                      ']);
    
    fseek(fid,168,'bof');
    
    fwrite(fid,'XX.XX.XX');
    fclose(fid);
    
end

% [header] = edfread(['F:\2015PP03\' files(f).name]);
% header
% header.patientID