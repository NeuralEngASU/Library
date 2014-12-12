function str=hms(sec)
% HMS calcaulte HH:MM:SS from seconds
%    STR=HMS(SEC) returns the amount of time, in the format HH:MM:SS,
%    contained in the integer number of seconds SEC, as a string.

hr=floor(sec/(60*60)); sec=sec-floor(sec/(60*60))*(60*60);
mn=floor(sec/60); sec=sec-floor(sec/60)*60;
sc=round(sec);
str=[sprintf('%02d',hr) ':' sprintf('%02d',mn) ':' sprintf('%02d',sc)];