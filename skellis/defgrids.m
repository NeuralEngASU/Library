function grids=defgrids
% define data grids
g=0;

% %
% % Grid 1
% % Delta(Micro-ECoG)
% % 
% % patient delta, hand area of motor cortex
% g=g+1;
% grids(g).subject='delta';
% grids(g).label='Micro ECoG (Delta)';
% grids(g).filename='delta';
% grids(g).shortname='microecog1';
% grids(g).class=1; % micro-ECoG
% grids(g).layout=[...
%     7 11 14 16;
%     4  8 12 15;
%     2  5  9 13;
%     1  3  6 10;];
% grids(g).badchan=[];
% grids(g).spacing=1; % in mm
% grids(g).sources(1).file='D:\Spencer\delta\20080726-113238\20080726-113238-002.ns5';
% grids(g).sources(1).nschans=[1 16];
% grids(g).sources(1).block=[500 1000]; % start time, total time (seconds)
% grids(g).sources(1).remln=1; % whether to filter out line noise
% 
% %
% % Grid 2
% % 201204 (Micro-ECoG)
% % 20120706-170724-001, 2600s +1000s
% %
% % patient 201204
% g=g+1;
% grids(g).subject='201204';
% grids(g).label='Micro ECoG (201204)';
% grids(g).filename='201204';
% grids(g).shortname='microecog2';
% grids(g).class=1; % micro-ECoG
% grids(g).layout=[...
%     28    23    17    10    -1    -1;
%     29    24    18    11     5    -1;
%     30    25    19    12     6     1;
%     31    26    20    13     7     2;
%     -1    27    21    14     8     3;
%     -1    -1    22    15     9     4;];
% grids(g).badchan=[17 19];
% grids(g).spacing=2; % in mm
% grids(g).sources(1).file='D:\Spencer\201204\20120706-170724-001_2600-3600s_raw.mat';
% grids(g).sources(1).nschans=32;
% grids(g).sources(1).block=[0 1000]; % start time, total time (seconds)
% grids(g).sources(1).remln=1; % whether to filter out line noise
% 
% %
% % Grid 3
% % 201203 (Micro-ECoG)
% % 20120627-164445-001, 5800s +1000s
% %
% % patient 201203
% g=g+1;
% grids(g).subject='201203';
% grids(g).label='Micro ECoG (201203)';
% grids(g).filename='201203';
% grids(g).shortname='microecog3';
% grids(g).class=1; % micro-ECoG
% grids(g).layout=[...
%     28    23    17    10    -1    -1;
%     29    24    18    11     5    -1;
%     30    25    19    12     6     1;
%     31    26    20    13     7     2;
%     -1    27    21    14     8     3;
%     -1    -1    22    15     9     4;];
% grids(g).badchan=[];
% grids(g).spacing=2; % in mm
% grids(g).sources(1).file='D:\Spencer\201203\20120627-164445-001_5800-6800s_raw.mat';
% grids(g).sources(1).nschans=32;
% grids(g).sources(1).block=[0 1000]; % start time, total time (seconds)
% grids(g).sources(1).remln=1; % whether to filter out line noise
% 
% %
% % Grid 4
% % Gamma (UEA)
% %
% g=g+1;
% grids(g).subject='gamma';
% grids(g).label='Utah Electrode Array (Gamma)';
% grids(g).filename='gamma';
% grids(g).shortname='uea1';
% grids(g).class=2; % Utah array
% grids(g).layout=[...
%      1     2    -1    -1    -1    -1     8    10    14     4
%     65    66    33    34     7     9    11    12    16    18
%     67    68    35    36     5    17    13    23    20    22
%     69    70    37    38    48    15    19    25    27    24
%     71    72    39    40    42    50    54    21    29    26
%     73    74    41    43    44    46    52    62    31    28
%     75    76    45    47    51    56    58    60    64    30
%     77    78    82    49    53    55    57    59    61    32
%     79    80    84    86    87    89    91    94    63    95
%      3    81    83    85    88    90    92    93    96     6];
% grids(g).badchan=[5 18 20 22 24 25 26 59 62];
% grids(g).spacing=0.4;
% % this data was recorded 6/26 from 9:50 am to 10:20 am (according to file
% % timestamps).  video indicates awake resting (being washed from 10:00 am
% % to 10:20 am).
% grids(g).sources(1).file='D:\Spencer\gamma\20080625-195431\20080625-195431-007.ns5';
% grids(g).sources(1).nschans=[1 96];
% grids(g).sources(1).block=[3400 1000];
% grids(g).sources(1).remln=1; % whether to filter out line noise
% 
% %
% % Grid 5
% % Epsilon (UEA)
% %
% g=g+1;
% grids(g).subject='epsilon';
% grids(g).label='Utah Electrode Array (Epsilon)';
% grids(g).filename='epsilon';
% grids(g).shortname='uea2';
% grids(g).class=2; % Utah array
% grids(g).layout=[...
%     -1     2     1     3     4     6     8    10    14    -1
%     65    66    33    34     7     9    11    12    16    18
%     67    68    35    36     5    17    13    23    20    22
%     69    70    37    38    48    15    19    25    27    24
%     71    72    39    40    42    50    54    21    29    26
%     73    74    41    43    44    46    52    62    31    28
%     75    76    45    47    51    56    58    60    64    30
%     77    78    82    49    53    55    57    59    61    32
%     79    80    84    86    87    89    91    94    63    95
%     -1    81    83    85    88    90    92    93    96   -1];
% grids(g).badchan=[];
% grids(g).spacing=0.4;
% grids(g).sources(1).file='D:\Spencer\epsilon\20080824-101948\20080824-101948-003.ns5';
% grids(g).sources(1).nschans=[1 96];
% grids(g).sources(1).block=[1000 1000];
% grids(g).sources(1).remln=1; % whether to filter out line noise

%
% Grid 6
% Seattle (ECoG)
%
g=g+1;
grids(g).subject='auditory1';
grids(g).label='ECoGTest';
grids(g).filename='AuditoryTest';
grids(g).shortname='ECoG1';
grids(g).class=3; % macro ECoG
grids(g).layout=[...
    57:64
    49:56
    41:48
    33:40
    25:32
    17:24
    9:16
    1:8];
grids(g).badchan=[];
grids(g).spacing=10;
grids(g).sources(1).file='D:\Kevin\SpencerPaper\201203\20120703-084201\20120703-084201-001.ns4';
grids(g).sources(1).nschans=[1, 64];
grids(g).sources(1).block=[1 648];
grids(g).sources(1).remln=1;





% % % %
% % % % Grid 2
% % % % UECOG2
% % % %
% % % % patient delta, arm area of motor cortex
% % % g=g+1;
% % % grids(g).subject='delta';
% % % grids(g).label='Subdural Micro ECoG (arm area motor cortex)';
% % % grids(g).filename='subduralmicro2';
% % % grids(g).shortname='µECoG2';
% % % grids(g).class=1; % micro-ECoG
% % % grids(g).layout=[... % corresponds to MATLAB array indices, NOT actual channels
% % %     7 11 14 16;
% % %     4  8 12 15;
% % %     2  5  9 13;
% % %     1  3  6 10;];
% % % grids(g).badchan=[1 7 10];
% % % grids(g).spacing=1; % in mm
% % % grids(g).sources(1).file='D:\Spencer\delta\20080726-113238\20080726-113238-002.ns5';
% % % grids(g).sources(1).nschans=[16 16];
% % % grids(g).sources(1).block=[500 1000]; % start time, total time (seconds)
% % % grids(g).sources(1).remln=1; % whether to filter out line noise
% % % 
% % % %
% % % % Grid 3
% % % % UECOG3
% % % %
% % % % patient delta, arm area of motor cortex
% % % g=g+1;
% % % grids(g).subject='delta';
% % % grids(g).label='Subdural Micro ECoG (face area motor cortex)';
% % % grids(g).filename='subduralmicro3';
% % % grids(g).shortname='µECoG3';
% % % grids(g).class=1; % micro-ECoG
% % % grids(g).layout=[... % corresponds to MATLAB array indices, NOT actual channels
% % %     7 11 14 16;
% % %     4  8 12 15;
% % %     2  5  9 13;
% % %     1  3  6 10;];
% % % grids(g).badchan=[6 8];
% % % grids(g).spacing=1; % in mm
% % % grids(g).sources(1).file='D:\Spencer\delta\processed\20080730-154223-001.ns5';
% % % grids(g).sources(1).nschans=[1 16];
% % % grids(g).sources(1).block=[2200 1000]; % start time, total time (seconds)
% % % grids(g).sources(1).remln=1; % whether to filter out line noise
% % % 
% % % %
% % % % Grid 4
% % % % UECOG4
% % % %
% % % % patient delta, arm area of motor cortex
% % % g=g+1;
% % % grids(g).subject='delta';
% % % grids(g).label='Subdural Micro ECoG (Wernicke''s area)';
% % % grids(g).filename='subduralmicro4';
% % % grids(g).shortname='µECoG4';
% % % grids(g).class=1; % micro-ECoG
% % % grids(g).layout=[... % corresponds to MATLAB array indices, NOT actual channels
% % %     7 11 14 16;
% % %     4  8 12 15;
% % %     2  5  9 13;
% % %     1  3  6 10;];
% % % grids(g).badchan=[1 2 7 8 10];
% % % grids(g).spacing=1; % in mm
% % % grids(g).sources(1).file='D:\Spencer\delta\processed\20080730-154223-001.ns5';
% % % grids(g).sources(1).nschans=[16 16];
% % % grids(g).sources(1).block=[2200 1000]; % start time, total time (seconds)
% % % grids(g).sources(1).remln=1; % whether to filter out line noise
% % % 
% % % %
% % % % Grid 5
% % % % UECOG5
% % % % 20120219-170748-001: 2000-3800 sec
% % % % 20120219-170748-001: 4500-5500 sec
% % % % 20120219-121917-001: 2100-4800 sec
% % % %
% % % % patient 201201
% % % g=g+1;
% % % grids(g).subject='201201';
% % % grids(g).label='Sudural Micro ECoG';
% % % grids(g).filename='subduralmicro5';
% % % grids(g).shortname='µECoG5';
% % % grids(g).class=1; % micro-ECoG
% % % grids(g).layout=[... % corresponds to MATLAB array indices, NOT actual channels
% % %     16   1   2   3   4   5   6   7
% % %      8   9  10  11  12  13  14  15
% % %     17  18  19  20  21  22  23  24
% % %     25  26  27  28  29  30  31  32
% % %     33  34  35  36  37  38  39  40
% % %     41  42  43  44  45  46  47  48
% % %     49  50  51  52  53  54  55  56
% % %     57  58  59  60  61  62  63  64];
% % % grids(g).badchan=[16 64 5 7 52];
% % % grids(g).spacing=3; % in mm;
% % % grids(g).sources(1).file='D:\Spencer\201201\20120219-170748\20120219-170748-001.ns4';
% % % grids(g).sources(1).nschans=[1 64];
% % % grids(g).sources(1).block=[2515 1000]; % start time, total time (seconds)
% % % grids(g).sources(1).remln=1; % whether to filter out line noise