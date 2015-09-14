
filename = 'D:\human CNS\PCH\XLTek_Data\2015PP02_D01_OR.edf';

fid = fopen(filename,'r+');

fseek(fid,8,'bof');

fwrite(fid,'2015PP02_D01_OR                      ');

fseek(fid,168,'bof');

fwrite(fid,'XX.XX.XX');
fclose(fid);

[header] = edfread(filename);
header
header.patientID