clear all;
close all;
clc;

use('cleanpath');
use('pkgs/skellis');
use('pkgs/nsx');

% % grids=defgrids;
% % g=1;
% % layout=grids(g).layout;
% % layout=[layout layout+16];

% % subject='nu';
% % layout=uea_map('nu');
% % stch=1;
% % totch=96;

% for 201201
subject='201201';
layout=[
    16   1   2   3   4   5   6   7
     8   9  10  11  12  13  14  15
    17  18  19  20  21  22  23  24
    25  26  27  28  29  30  31  32
    33  34  35  36  37  38  39  40
    41  42  43  44  45  46  47  48
    49  50  51  52  53  54  55  56
    57  58  59  60  61  62  63  64]';

% % % for iota
% % subject='iota';
% % layout=[
% %     16 -1 01 02 03 04;
% %     05 06 07 08 09 10;
% %     11 12 13 14 15 -1;
% %     17 18 19 20 21 -1;
% %     22 23 24 25 26 27;
% %     28 29 30 31 -1 -1]';

% % % for 201101
% % subject='201101';
% % layout=[
% %     63	61	59	57	55	53	51	49	47	45	43
% %     41	39	37	35	33	127	125	123	121	119	117
% %     115	113	111	109	107	105	103	101	99	97	95
% %     93	91	89	87	85	83	81	79	77	75	73
% %     71	69	67	65	27	25	23	21	19	17	15
% %     13	11	9	7	5	3	64	62	60	58	56
% %     54	52	50	48	46	44	42	40	38	36	34
% %     128	126	124	122	120	118	116	114	112	110	108
% %     106	104	102	100	98	96	94	92	90	88	86
% %     84	82	80	78	76	74	72	70	68	66	26
% %     24	22	20	18	16	14	12	10	8	6	4];

% % % for 201102
% % subject='201102';
% % layout=[
% %     -1  32	30	28	26	24	22	20
% %     18	16	14	12	10	8	6	4
% %     63	61	59	57	55	53	51	49
% %     47	45	43	41	39	37	35	33
% %     64	62	60	58	56	54	52	50
% %     48	46	44	42	40	38	36	34
% %     31	29	27	25	23	21	19	17
% %     15	13	11	9	7	5	3   -1];

% % % for delta arm
% % subject='delta';
% % layout=[    
% %     7 11 14 16;
% %     4  8 12 15;
% %     2  5  9 13;
% %     1  3  6 10;];

% % files={'D:\data\delta\20080725-193658\20080725-193658-008.ns5'};
% % files=fsearch('D:\data\iota\','*.ns3','flat','depth',2);
% % files=fsearch('n:\human\201101\','*.ns4','flat','depth',2);
% % files=cell(size(grids(g).sources));
% % for s=1:length(grids(g).sources)
% %     files{s}=grids(g).sources(s).file;
% % end
% % files=flipud(files);
% % files{1}='D:\data\delta\20080730-154223\20080730-154223-001.ns5';
% % files{1}='D:\data\201102\20111019-185810\20111019-185810-008.ns4';
% % files{1}='D:\data\nu\20090803-193522\20090803-193522-009.ns5';

files=fsearch('D:\Spencer\201201\','*.ns4','flat');


winsize=100;
for k=1:length(files)
    disp(files{k});
    ns=nsopen(files{k});
    if(~isnan(ns.Length) && ns.Channel_Count>10)
        [path,fname,dir]=fileparts(ns.Filename);
        for m=0:winsize:ns.Length
            disp(['  ' num2str(m) '/' num2str(ns.Length)]);
            tot=min(winsize,floor(ns.Length-m));
            % data=nsread(ns,1,ns.Channel_Count,m,tot);
            % for iota
            data=nsread(ns,min(layout(layout>0)),nnz(layout(layout>0)),m,tot);
            %data=nsread(ns,65,31,m,tot);
            if(ns.fs==30e3)
                data=data(:,1:15:end)';
                t=m:1/2e3:(m+tot-1/2e3);
            elseif(ns.fs==10e3)
                data=data(:,1:5:end)';
                t=m:1/2e3:(m+tot-1/2e3);
            elseif(ns.fs==2e3)
                data=data';
                t=m:1/2e3:(m+tot-1/2e3);
            elseif(ns.fs==1e3)
                data=data';
                t=m:1/1e3:(m+tot-1/1e3);
            end
            figure('Position',[1 41 1920 1090],'PaperPositionMode','auto','Visible','off');
            gridplot2(t,data,layout,'axisargs',struct('ylim',[-1e3 1e3]));
            %saveas(gcf,['D:\matlab\ecogres\figures\raw\' grids(g).subject '\' fname '_' num2str(m) '-' num2str(m+tot) '.png']);
            saveas(gcf,['D:\Spencer\201201\figures\raw\' subject '\' fname '_' num2str(m) '-' num2str(m+tot) '.png']);
            close(gcf);
        end
    else
        disp('  skipping')
    end
end