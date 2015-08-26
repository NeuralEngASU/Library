%Channel Map:  
%1:  empty
%2-16:  No headstage, good reference (grid elecs 79-65)
%17:  empty
%18-32:  No headstage, poor reference(grid elecs 94-80) 
%33:  empty
%34-48:  No headstage, no reference (grid elecs 109-95)
%49:  empty
%50-64:  Headstage, no reference (grid elecs 124-110)
%65: empty
%66-80:  Headstage, poor reference (grid elecs 139-125)
%81:  empty
%82-96:  Headstage, good reference (grid elecs 154-140)
%97:  empty
%98-112:  Headstage, good reference (grid elecs 169-155)
%113:  emtpy
%114-128:  Headstage, good reference (grid elecs 184-170)


load('E:\data\human CNS\PCH\2015PP01\2015PP01_JOVE\2015PP01_2015PP01_JOVE.mat')
Fs = Header.Fs;

Case1 = [];
for ch = 2:16
       Case1 = [Case1;eval(['C' num2str(ch)])];
end
clear ch

Case2 = [];
for ch = 18:32
    Case2 = [Case2;eval(['C' num2str(ch)])];
end
clear ch

Case3 = [];
for ch = 34:48
    Case3 = [Case3;eval(['C' num2str(ch)])];
end
clear ch

Case4 = [];
for ch = 50:64
    Case4 = [Case4;eval(['C' num2str(ch)])];
end
clear ch

Case5 = [];
for ch = 66:80
    Case5 = [Case5;eval(['C' num2str(ch)])];
end
clear ch

Case6 = [];
for ch = [82:96 98:112 114:128]
    Case6 = [Case6;eval(['C' num2str(ch)])];
end
clear ch

save(['E:\data\human CNS\JOVE\Case1.mat'],'Case1', 'header1','-v7.3');