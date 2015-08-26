% This function is called by EMD.m.  See parent function (EMD.m) for additional information.

% This function determines if 'data' (a potential IMF) meets the criteria of an IMF
% An IMF is a data set if: (1) The number of zero crossings and extrema in the data set are the same or differ at most by 1, and (2) at any point in the data, the mean of the envelope formed by the maxima and minima extrema is zero.

function [IMFCheck1,IMFCheck2,zeroxings,extrema] = IMFCheck(imf)

%%
%IMFcheck1 = Determine if the number of zero crossing and extrema are the same
%or differ at most by one

%Calculate the number of zero crossings in 'data
zeroxings=sum(find(diff(sign(imf)))~=0);

%Calculate the number of extrema in 'data'
h_extrema = sign(diff(imf));
extrema = sum(diff(h_extrema<0) | diff(h_extrema>0));

%Returns 1 if true, 0 if false.  Want 1.
ck1 = abs(zeroxings - extrema);
IMFCheck1 = ck1 <= 1;


%%
%IMFcheck2 = Determine if the average of the envelopes crosses zero at any time

%Calculate max and min envelope of 'data'
[maxenv,minenv]=Envelopes(imf);

%Calculate mean of 'data' envelope
avgenv = (maxenv+minenv)./2;

%Round avgenv to nearest hundreth
%ravgenv = roundn(avgenv,-2);
ravgenv = round(avgenv);

%Find where the average of the maxima and minima envelopes is zero
envzeroxing = find(ravgenv==0)';

%Returns 1 if true, 0 if false.  Want 1.
IMFCheck2 = ~isempty(envzeroxing);