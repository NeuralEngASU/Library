% Create matlab variables from excel values

[~,patnum] = xlsread(xlfile,ictal_state,'A3:A100');
[~,day] = xlsread(xlfile,ictal_state,'D3:D100');
[~,clpstrt] = xlsread(xlfile,ictal_state,'A3:A100');

sznum = xlsread(xlfile,ictal_state,'E3:E100');
Fs = xlsread(xlfile,ictal_state,'E3:E100');
clonset = xlsread(xlfile,ictal_state,'E3:E100');

onsetchans{1} = [1 9 17 25; 18 49 NaN NaN; 1 9 17 25; 1 9 17 25; 1 9 17 25;1 9 17 25];
onsetchans{2} = [97 98; 97 98; 97 98];
onsetchans{3} = [82; 82; 82; 82; 82; 82];
onsetchans{4} = [5; 5; 5; 5; 5; 5; 5; 5; 5];
onsetchans{5} = [51 NaN; 43 35; 26 35; 65 71; 65 71; 65 71; 65 71; 65 71; 65 71; 65 71; 65 71; 65 71; 65 71;65 71; 65 71; 65 71;];
onsetchans{6} = [16 NaN NaN NaN NaN NaN; 16 NaN NaN NaN NaN NaN; 16 NaN NaN NaN NaN NaN; 69 70 71 72 73 74; 69 70 71 72 73 74; 69 70 71 72 73 74; 16 NaN NaN NaN NaN NaN; 16 NaN NaN NaN NaN NaN; 16 NaN NaN NaN NaN NaN; 16 NaN NaN NaN NaN NaN];
onsetchans{7} = [79 80 NaN; 73 80 NaN; 73 NaN NaN; 73 80 NaN; 73 NaN NaN; 73 74 80; 79 80 NaN; 79 80 NaN];
onsetchans{8} = [87 88 89 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN; 8 88 89 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN; 87 88 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN; 75 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN; 75 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN; 1:16];

grids{1} = [1 64; 65 70; 71 76; 77 82; 83 86; 87 90; 91 94; 95 98]; %2012PP05
grids{2} = [1 64; 65 80; 81 96; 97 104; 105 112; 113 118]; %2013PP01
grids{3} = [1 64; 65 80; 81 96; 97 102; 103 108; 109 114; 115 120]; %2014PP01
grids{4} = [1 64; 65 70; 71 76; 77 82; 83 88; 89 94]; %2014PP02
grids{5} = [1 64; 65 70; 71 76; 77 84; 85 89]; %2014PP04
grids{6} = [1 64; 65 68; 69 74; 75 78; 79 82; 83 88]; %2014PP05
grids{7} = [1 64; 65 70; 71 76; 77 82; 83 86; 87 90]; %2014PP06
grids{8} = [1 16; 17 32; 33 52; 53 72; 73 78; 79 84; 85 90]; %2014PP07