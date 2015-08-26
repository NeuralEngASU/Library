% This function is called by "EMD".  See EMD.m for background information.

% This function determines if the EMD sifting process should be stopped due to a lack of change in the potential IMFs the algorithm is detecting.
% If the checks are true, "S" (in the EMD function) will be increased by 1.  The recommended number of iterations for S is 6 (see Huang, 2005).

function [StopCheck1,StopCheck2,StopCheck3] = StopCheck(nzeroxings,nextrema)

%Compare the current and previous number of zero crossings
zero_comp = nzeroxings(end) - nzeroxings(end-1);

%Compare the current and previous number of extrema
ext_comp =  nextrema(end) - nextrema(end-1);

%Is the number of zero crossings the same as the previous round of sifting? 1 to stop
StopCheck1 = abs(zero_comp) == 0;

%Is the number of zero crossings the same as the previous round of sifting? 1 to stop
StopCheck2 = abs(ext_comp) == 0;

%Are the number of extrema and the number of zerocrossings the same or differ at most by one? 1 to stop.
StopCheck3 = abs(nzeroxings(end) - nextrema(end)) > 1;
