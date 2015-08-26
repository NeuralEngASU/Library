% Use OUTPUT = openNSx(fname, 'read', 'report', 'e:xx:xx', 'c:xx:xx', 't:xx:xx', 'mode', 'precision', 'skipfactor').
%1,2,4,11,16,17,28,29,30,31,32,36,37,38,41,42,43,46,60,62,65,76,83,85,96,120

% %% Extract clips from Utah patient 201101 clinical EDF file

[header,rcd] = edfread('E:\data\human CNS\201101\20110323-185852\Fxxx~ Rxxx_701a652d-b380-4538-95a3-05e5a9058e8c.edf');

%Mclip1
data = rcd(:,(27000000:28000000));
hdr.patient = 'Utah Patient 2011'
hdr.parentfile = 'Fxxx~ Rxxx_701a652d-b380-4538-95a3-05e5a9058e8c.edf'
hdr.parentfilestarttime = '14.23.03'
hdr.parentfiledate = '23.03.11'
hdr.Fs = '1000'
hdr.clipsamplerange = '27000000 to 28000000'
hdr.clipstarttime = '21.53.03'

save('E:\data\human CNS\201101\Mclip1.mat','data','hdr');

%Mclip2
data = rcd(:,(34000000:36000000));
hdr.patient = 'Utah Patient 201101'
hdr.parentfile = 'Fxxx~ Rxxx_701a652d-b380-4538-95a3-05e5a9058e8c.edf'
hdr.parentfilestarttime = '14.23.03'
hdr.parentfiledate = '23.03.11'
hdr.Fs = '1000'
hdr.clipsamplerange = '282570000 to 285570000'
hdr.clipstarttime = '22.14.00'

save('E:\data\human CNS\201101\Macro2.mat','data','hdr');



micro10minclip1 = openNSx('E:\data\human CNS\201101\20110323-185852\20110323-185852-001.ns4','read','t:70000:6070000','sample');
%9070000:12070000
micro10minclip2 = openNSx('E:\data\human CNS\201101\20110323-185852\20110323-185852-002.ns4','read','t:50000:6050000','sample');

micro10mindata1 = double(micro10minclip1.Data);
micro10mindata2 = double(micro10minclip2.Data);

save

Mclip1 = load ('E:\data\human CNS\201101\Mclip1.mat');
Mclip2 = load ('E:\data\human CNS\201101\Mclip2.mat');

Macro1 = Mclip1.data((1:14),(357000:957000));
Macro2 = Mclip2.data((1:14),(557000:1157000)); 
Macro2 = Mclip2.data((1:14),(282570000:285570000);