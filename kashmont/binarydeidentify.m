

fid = fopen('/Users/kariashmont/Desktop/Data/KT/KT_7.edf','r+');

fseek(fid,8,'bof');

fwrite(fid,'2012PP02D03S7                      ');

fseek(fid,168,'bof');

fwrite(fid,'XX.XX.XX');
fclose(fid);

[header] = edfread('/Users/kariashmont/Desktop/Data/KT/KT_7.edf');
header
header.patientID