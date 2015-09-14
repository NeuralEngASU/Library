% This function is called by EMD.m.  See parent function (EMD.m) for additional information (see also Huang, 2005).

% This function determines if the waveform remaining after the subtraction of the most recently found IMF contains sufficient information to continue the sifting process.
% 2Hz and 20uV were determined the lower level of "substantial consequence" such that the waveform contains biologically relevant data.

function [ResidueCheck] = ResCheck(res)

rise_fall = sign(diff(res));

maxpts = (find(diff(rise_fall)<0))+1;

minpts = (find(diff(rise_fall)>0))+1;

s = (length(maxpts)+length(minpts))/2;

%determine how many seconds of data there are
t=(round((length(res))/500));

%calculate the approximate frequency of the residue
hz = s/t;

extdiff=length(maxpts)-length(minpts);

if extdiff>0
    ppdiff=res(maxpts(1:length(minpts)))-res(minpts);
    avgdiff=mean(ppdiff);
else
    ppdiff=res(maxpts)-res(minpts(1:length(maxpts)));
    avgdiff=mean(ppdiff);
end

ResidueCheck = hz < 2 | avgdiff<20;

end




